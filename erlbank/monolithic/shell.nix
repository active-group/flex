{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
  erlang = pkgs.beam.packages.erlangR24.erlang;
in
mkShell {
  buildInputs = [ erlang ];
}
