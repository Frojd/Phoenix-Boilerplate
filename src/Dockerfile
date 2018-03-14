FROM elixir:1.6

ENV SCAFFOLD_APP_NAME=phoenix_app

RUN mix local.hex --force \
    && mix local.rebar --force

RUN apt-get update \
    && apt-get install -y inotify-tools

RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.0.ez

WORKDIR /app
ADD . /app

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["server"]
