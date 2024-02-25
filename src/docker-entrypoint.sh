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
    mix phx.new $SCAFFOLD_APP_NAME --no-assets --no-install --adapter=bandit

    echo "Move app to src"
    cp -Rp ./$SCAFFOLD_APP_NAME/. .
    rm -rf ./$SCAFFOLD_APP_NAME

    echo "Update configuration"
    sed -i -e "s/username:.*/username: System.get_env(\"DATABASE_USER\"),/" config/dev.exs
    sed -i -e "s/password:.*/password: System.get_env(\"DATABASE_PASSWORD\"),/" config/dev.exs
    sed -i -e "s/database:.*/database: System.get_env(\"DATABASE_NAME\"),/" config/dev.exs
    sed -i -e "s/hostname:.*/hostname: System.get_env(\"DATABASE_HOST\"),/" config/dev.exs
    sed -i '/hostname:.*/a\ \ port: System.get_env("DATABASE_PORT") |> String.to_integer,' config/dev.exs
    sed -i -e "s/ip:.{127, 0, 0, 1}/ip: {0, 0, 0, 0}/" config/dev.exs

    sed -i -e "s/username:.*/username: System.get_env(\"DATABASE_USER\"),/" config/test.exs
    sed -i -e "s/password:.*/password: System.get_env(\"DATABASE_PASSWORD\"),/" config/test.exs
    sed -i -e "s/database:.*/database: System.get_env(\"DATABASE_TEST_NAME\"),/" config/test.exs
    sed -i -e "s/hostname:.*/hostname: System.get_env(\"DATABASE_HOST\"),/" config/test.exs
    sed -i '/hostname:.*/a\ \ port: System.get_env("DATABASE_PORT") |> String.to_integer,' config/test.exs

    echo "Adding release"
    sed -i '/bandit/c \ \ \ \ \ \ {:bandit,\ "~> 1.2"},' mix.exs
    sed -i '/bandit/a \ \ \ \ \ \ {:toml,\ "~> 0.7"},' mix.exs

    rm config/prod.exs
    cp _templates/config/prod.exs config/prod.exs
    sed -i -e "s/example_app/$SCAFFOLD_APP_NAME/" config/prod.exs
    sed -i -e "s/ExampleApp/$SCAFFOLD_APP_PC_NAME/" config/prod.exs

    mix deps.get
    mix release.init
    cp _templates/lib/release.ex lib/release.ex

    sed -i '/deps()/c \ \ \ \ \ \ deps: deps(),' mix.exs
    sed -i '/deps()/a \ \ \ \ \ \ releases: [ realtime_api: [ include_executables_for: [:unix], applications: [runtime_tools: :permanent], steps: [:assemble, :tar], config_providers: [ {Toml.Provider, path: "config.toml"} ] ] ],' mix.exs

    cp _templates/config/defaults.toml config/defaults.toml
    sed -i -e "s/example_app/$SCAFFOLD_APP_NAME/" config/defaults.toml
    sed -i -e "s/ExampleApp/$SCAFFOLD_APP_PC_NAME/" config/defaults.toml

    echo "Apply code formatting"
    mix format
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
