#!/bin/bash
set -e

# $0 is a script name, $1, $2, $3 etc are passed arguments
# $1 is our command
# Credits: https://rock-it.pl/how-to-write-excellent-dockerfiles/
CMD=$1

# Wait until postgres is ready
until nc -z $DATABASE_HOST 5432; do
    echo "$(date) - waiting for postgres..."
    sleep 3
done

case "$CMD" in
    "server" )
        if [ ! -f ./mix.exs ]; then
            echo "Generating app"
            mix phx.new $SCAFFOLD_APP_NAME --no-webpack

            echo "Move app to src"
            cp -Rp ./$SCAFFOLD_APP_NAME/. .
            rm -rf ./$SCAFFOLD_APP_NAME

            echo "Update configuration"
            sed -i -e "s/username:.*/username: System.get_env(\"DATABASE_USER\"),/" config/dev.exs
            sed -i -e "s/password:.*/password: System.get_env(\"DATABASE_PASSWORD\"),/" config/dev.exs
            sed -i -e "s/hostname:.*/hostname: System.get_env(\"DATABASE_HOST\"),/" config/dev.exs
            sed -i -e "s/database:.*/database: System.get_env(\"DATABASE_NAME\"),/" config/dev.exs

            sed -i -e "s/username:.*/username: System.get_env(\"DATABASE_USER\"),/" config/test.exs
            sed -i -e "s/password:.*/password: System.get_env(\"DATABASE_PASSWORD\"),/" config/test.exs
            sed -i -e "s/hostname:.*/hostname: System.get_env(\"DATABASE_HOST\"),/" config/test.exs
            sed -i -e "s/database:.*/database: System.get_env(\"DATABASE_TEST_NAME\"),/" config/test.exs

        fi

        echo "Update deps"
        mix deps.get

        echo "Create db (if none exists)"
        mix ecto.create

        echo "Run migrations"
        mix ecto.migrate

        echo "Start server"
        exec mix phx.server
        ;;

    "test" )
        echo Running tests
        export MIX_ENV="test"
        exec mix test ${@:1}
        ;;

    * )
        # Run custom command. Thanks to this line we can still use
        # "docker run our_image /bin/bash" and it will work
        exec $CMD ${@:2}
        ;;
esac
