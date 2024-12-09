# Erlbank

All code examples of Erlbank are contained in the following sub-directories:

- monolithic: Erlbank legacy application that is reworked

In the course of the training, we split this application into the following services/components, each resided in a subdirectory accordingly:

- accounts: Service responsible for creating and managing accounts
- transfers: Service responsible for executing transfers between accounts
- statements: Service that prints bank statements
- nginx: Frontend integration for the services
- deployment: Docker deployment for the entire system

## Local operation

    # in accounts:
	rebar3 shell --sname=accounts
	# in transfers:
	env ACCOUNTS_HOST=<your-host> rebar3 shell --sname=transfers
	# in statements:
	env ACCOUNTS_HOST=<your-host> TRANSFERS_HOST=<your-host> shell --sname=statements
