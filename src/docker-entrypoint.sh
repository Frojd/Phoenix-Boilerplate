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

scaffold_project() {
    SCAFFOLD_APP_PC_NAME=$(echo $SCAFFOLD_APP_NAME | sed -r 's/(^|_)([a-z])/\U\2/g')

    echo "Generating app"
    mix phx.new $SCAFFOLD_APP_NAME --no-webpack

    echo "Move app to src"
    cp -Rp ./$SCAFFOLD_APP_NAME/. .
    rm -rf ./$SCAFFOLD_APP_NAME

    echo "Update configuration"
    sed -i -e "s/username:.*/username: System.get_env(\"DATABASE_USER\"),/" config/dev.exs
    sed -i -e "s/password:.*/password: System.get_env(\"DATABASE_PASSWORD\"),/" config/dev.exs
    sed -i -e "s/database:.*/database: System.get_env(\"DATABASE_NAME\"),/" config/dev.exs
    sed -i -e "s/hostname:.*/hostname: System.get_env(\"DATABASE_HOST\"),/" config/dev.exs
    sed -i '/hostname:.*/a\ \ port: System.get_env("DATABASE_PORT") |> String.to_integer,' config/dev.exs

    sed -i -e "s/username:.*/username: System.get_env(\"DATABASE_USER\"),/" config/test.exs
    sed -i -e "s/password:.*/password: System.get_env(\"DATABASE_PASSWORD\"),/" config/test.exs
    sed -i -e "s/database:.*/database: System.get_env(\"DATABASE_TEST_NAME\"),/" config/test.exs
    sed -i -e "s/hostname:.*/hostname: System.get_env(\"DATABASE_HOST\"),/" config/test.exs
    sed -i '/hostname:.*/a\ \ port: System.get_env("DATABASE_PORT") |> String.to_integer,' config/test.exs

    echo "Installing distillery"
    sed -i '/plug_cowboy/c \ \ \ \ \ \ {:plug_cowboy,\ "~> 2.0"},' mix.exs
    sed -i '/plug_cowboy/a \ \ \ \ \ \ {:distillery,\ "~> 2.0"},' mix.exs
    sed -i '/distillery/a \ \ \ \ \ \ {:toml,\ "~> 0.3"}' mix.exs

    rm config/prod.exs
    cp _templates/config/prod.exs config/prod.exs
    sed -i -e "s/example_app/$SCAFFOLD_APP_NAME/" config/prod.exs
    sed -i -e "s/ExampleApp/$SCAFFOLD_APP_PC_NAME/" config/prod.exs

    mix deps.get
    mix release.init

    echo "Copy commands"
    mkdir -p rel/commands
    cp _templates/rel/commands/migrate.sh rel/commands/migrate.sh
    sed -i -e "s/ExampleApp/$SCAFFOLD_APP_PC_NAME/" rel/commands/migrate.sh

    echo "Add commands to rel/config.exs"
    echo "$(cat _templates/rel/config.part.exs)" >> rel/config.exs
    sed -i -e "s/example_app/$SCAFFOLD_APP_NAME/" rel/config.exs
    sed -i -e "s/ExampleApp/$SCAFFOLD_APP_PC_NAME/" rel/config.exs

    echo "Configure toml"
    sed -i '/environment\ :prod/a \ \ set config_providers: [ {Toml.Provider, [path: "${RELEASE_ROOT_DIR}/config.toml"]} ]' rel/config.exs
    sed -i '/environment\ :prod/a \ \ set overlays: [ {:copy, "config/defaults.toml", "config.toml"} ]' rel/config.exs

    cp _templates/config/defaults.toml config/defaults.toml
    sed -i -e "s/example_app/$SCAFFOLD_APP_NAME/" config/defaults.toml
    sed -i -e "s/ExampleApp/$SCAFFOLD_APP_PC_NAME/" config/defaults.toml
}

if [ ! -f ./mix.exs ]; then
    scaffold_project
fi

case "$CMD" in
    "server" )
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
