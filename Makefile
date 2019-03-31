setup:
	git flow init
	cp docker/config/web.example.env docker/config/web.env
	ln -nfs $PWD/.githooks/bump-version.sh .git/hooks/post-flow-release-start
	ln -nfs $PWD/.githooks/bump-version.sh .git/hooks/post-flow-hotfix-start
	docker-compose up

test:
	docker-compose run --rm web test

fixcode:
	docker-compose exec web mix format

compile:
	docker-compose exec web bash -c "MIX_ENV=prod mix release --env=prod"
