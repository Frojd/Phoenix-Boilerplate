setup:
	git flow init
	cp docker/config/web.example.env docker/config/web.env
	ln -nfs $PWD/.githooks/bump-version.sh .git/hooks/post-flow-release-start
	ln -nfs $PWD/.githooks/bump-version.sh .git/hooks/post-flow-hotfix-start
	docker-compose up

fixcode:
	docker-compose exec web mix format
