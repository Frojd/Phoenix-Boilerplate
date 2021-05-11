setup:
	git flow init
	cp docker/config/elixir.example.env docker/config/elixir.env
	ln -nfs $PWD/.githooks/bump-version.sh .git/hooks/post-flow-release-start
	ln -nfs $PWD/.githooks/bump-version.sh .git/hooks/post-flow-hotfix-start
	docker-compose up

test:
	docker-compose run --rm web test

fixcode:
	docker-compose exec web mix format

compile:
	docker-compose exec web bash -c "MIX_ENV=prod mix release --env=prod"

cleanup_scaffold:
	rm -rf src/test src/rel src/priv src/lib src/config src/deps src/_build
	rm -f src/mix.*
	rm -f src/README.md
	rm -f src/.formatter.exs
	rm -f src/.gitignore
