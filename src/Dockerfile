FROM elixir:1.13

ENV SCAFFOLD_APP_NAME=phoenix_app \
    DATABASE_USER=postgres \
    DATABASE_PASSWORD=postgres \
    DATABASE_NAME=postgres \
    DATABASE_TEST_NAME=postgres_test \
    DATABASE_HOST=db \
    DATABASE_PORT=5432

RUN mix local.hex --force \
    && mix local.rebar --force

RUN apt-get update \
    && apt-get install -y inotify-tools vim netcat \
    && rm -rf /var/lib/apt/lists/*

RUN mix archive.install --force hex phx_new 1.5.9

WORKDIR /app
ADD . /app

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["server"]
