{
  description = "An Active Group presentation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    revealjs = {
      url = "github:hakimel/reveal.js";
      flake = false;
    };
    mathjax = {
      url = "github:mathjax/mathjax";
      flake = false;
    };
    plantumlC4 = {
      url = "github:plantuml-stdlib/c4-plantuml";
      flake = false;
    };
    plantumlEIP = {
      url = "github:plantuml-stdlib/EIP-PlantUML";
      flake = false;
    };
    decktape = {
      url = "github:astefanutti/decktape";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      supportedSystems = with flake-utils.lib.system; [
        x86_64-linux
        x86_64-darwin
        aarch64-darwin
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnsupportedSystem = true;
            allowBroken = true;
          };
        };
        decktapeWithDependencies = self.packages.${system}.decktapeWithDependencies;
      in
      {
        packages.decktapeWithDependencies = pkgs.stdenv.mkDerivation {
          name = "decktape-with-dependencies";
          src = inputs.decktape;
          buildInputs = [ pkgs.nodejs ];
          buildPhase = "HOME=$TMP npm install";
          installPhase = "cp -r . $out";
        };

        apps = {
          # The default target for `nix run`.  This builds the
          # reveal.js slides.
          default =
            let
              emacs = pkgs.emacs.pkgs.withPackages (p: [ p.org-re-reveal ]);
              app = pkgs.writeShellScript "org-re-reveal" ''
                if [ ! -e plantuml/plugins ]; then
                  mkdir -p plantuml/plugins
                  ln -snf ${inputs.plantumlC4}/*.puml plantuml/plugins/.
                  echo Symlinked PlantUML C4 to ./plantuml/plugins
                  ln -snf ${inputs.plantumlEIP}/dist/*.puml plantuml/plugins/.
                  echo Symlinked PlantUML EIP to ./plantuml/plugins
                fi

                export REVEAL_ROOT="${inputs.revealjs}"
                export REVEAL_MATHJAX_URL=
                export PATH=${pkgs.plantuml}/bin:$PATH

                echo $@
                ${emacs}/bin/emacs --batch -q -l export.el \
                    --eval="(org-re-reveal-export-file \"$@\" \"${inputs.revealjs}\" \"${inputs.mathjax}/es5/tex-chtml.js\")"
              '';
            in
            {
              type = "app";
              program = "${app}";
            };

          # May be used to create the PDF version of the talk.  See the
          # Makefile for an actual invocation.
          decktape =
            let
              app = pkgs.writeShellScript "run-decktape" "${pkgs.nodejs}/bin/node ${decktapeWithDependencies}/decktape.js $@";
            in
            {
              type = "app";
              program = "${app}";
            };

          printPdf =
            let
              app = pkgs.writeShellScript "print-pdf" ''
                DECKTAPECHROME=${decktapeWithDependencies}/node_modules/puppeteer/.local-chromium/mac-961656/chrome-mac/Chromium.app/Contents/MacOS/Chromium
                CHROME=''${3:-$DECKTAPECHROME}
                $CHROME --headless --disable-gpu --run-all-compositor-stages-before-draw --virtual-time-budget=10000 --disable-web-security --print-to-pdf=$2 "file://$(pwd)/$1?print-pdf"
              '';
            in
            {
              type = "app";
              program = "${app}";
            };
          pdfunite =
            let
              poppler = pkgs.poppler_utils;
            in
            {
              type = "app";
              program = "${poppler}/bin/pdfunite";
            };

          evalplantuml =
            let
              scriptname = "update-plantuml";
              app = pkgs.writeShellScript scriptname ''
                if [ ! -e plantuml/plugins ]; then
                  mkdir -p plantuml/plugins
                  ln -snf ${inputs.plantumlC4}/*.puml plantuml/plugins/.
                  echo Symlinked PlantUML C4 to ./plantuml/plugins
                  ln -snf ${inputs.plantumlEIP}/dist/*.puml plantuml/plugins/.
                  echo Symlinked PlantUML EIP to ./plantuml/plugins
                fi

                export PATH=${pkgs.plantuml}/bin:$PATH

                if [ $# -eq 1 ]; then
                   elisp="(org-update-plantuml-in-file \"$1\")"
                elif [ $# -eq 2 ]; then
                   elisp="(org-update-plantuml-in-file \"$1\" t)"
                else
                   echo "Usage: ${scriptname} FILE [FORCE-EVAL]"
                   exit 1
                fi

                echo "$elisp"
                ${pkgs.emacs}/bin/emacs --batch -q -l eval-plantuml.el --eval="$elisp"
              '';
            in
            {
              type = "app";
              program = "${app}";
            };

          # Export org to pdf, useful for exams, for example.
          org2pdf =
            let
              emacs = pkgs.emacsWithPackages (p: [ p.org-re-reveal ]);
              app = pkgs.writeShellScript "org2pdf" ''
                echo $@
                ${emacs}/bin/emacs --batch -q -l export.el \
                    --eval="(org-export-pdf \"$@\")"
              '';
            in
            {
              type = "app";
              program = "${app}";
            };
        };

        devShells = {
          default = pkgs.mkShell {
            packages = [ pkgs.erlang pkgs.rebar3
                         pkgs.elixir
                         pkgs.nginx ];
            shellHook = ''
              export PS1  ="\n\[\033[1;32m\][nix-shell:\W \[\033[1;31m\]FLEX\[\033[1;32m\]]\$\[\033[0m\] "
              echo -e "\n\033[1;31m ♣ ♠ Welcome to FLEX! ♥ ♦ \033[0m\n"
            '';
          };
        };
      }
    );
}
