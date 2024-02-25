# Phoenix Boilerplate

This is a Phoenix/Elixir boilerplate that includes a auto-setup, docker support and deploy scripts.


## Features

- Built in compile target support for Ubuntu 22.04
- Elixir 1.16
- Phoenix 1.7
- OTP 25
- Auto scaffolding (with `phx.new`)
- Dependencies and db migrations are automatically run when starting/restarting docker


## Requirements

- Docker ([Install instructions](#how-do-i-install-docker-on-macoswindows))
- [mkcert](https://github.com/FiloSottile/mkcert) for SSL


## Clean install

1. Copy configuration

    ```
    cp docker/config/elixir.example.env docker/config/elixir.env
    ```

2. Open `docker/config/elixir.env` and change `SCAFFOLD_APP_NAME=` to the otp name you want for your app
3. Run: docker-compose up
4. Done. Visit [localhost:8000](http://localhost:8000)


## Installation (when project is set up)

### Running in docker

1. Copy configuration

    ```
    cp docker/config/elixir.example.env docker/config/elixir.env
    ```

2. Include this ip on your hosts-file

    ```
    127.0.0.1 example.com.test
    ```

3. Add root cert: `mkcert -install` (if not already available)

4. Generate ssl cert:
    ```
    mkcert --cert-file docker/files/certs/cert.pem --key-file docker/files/certs/cert-key.pem example.com.test
    ```

5. Enable SSL in Nginx
    ```
    sed -i.bak 's/\#mkcert\ //g' docker/files/config/nginx.conf.template
    rm -f docker/files/config/nginx.conf.template.bak
    ```

6. Start project

    ```
    docker-compose up
    ```

7. Visit your site on [https://example.com.test:8001/](example.com.test:8001/)


### Running elixir/otp locally

1. Copy configuration

    ```
    cp docker/config/elixir.example.env docker/config/elixir.env
    ```

2. Include this ip on your hosts-file

    ```
    127.0.0.1 example.com.test
    ```

3. Add root cert: `mkcert -install` (if not already available)

4. Generate ssl cert:
    ```
    mkcert --cert-file docker/files/certs/cert.pem --key-file docker/files/certs/cert-key.pem example.com.test
    ```

5. Enable SSL in Nginx
    ```
    sed -i.bak 's/\#mkcert\ //g' docker/files/config/nginx.conf.template
    rm -f docker/files/config/nginx.conf.template.bak
    ```

6. Disable elixir docker image

    ```
    cp docker-compose.override.example.yml docker-compose.override.example.yml
    ```

7. Start project

    ```
    docker-compose up -d
    ```

8. Start phoenix
    ```
    cd src
    mv local.tool-versions .tool-versions
    asdf install
    source env.local.sh
    mix deps.get
    mix phx.server
    ```

9. Visit your site on [https://example.com.test:8001/](example.com.test:8001/)


## Deployment

### Deploying manually

#### Requirements

- Python 3.8 and pip
- Virtualenv
- Mac OS or Linux ([Windows does not currently work](http://docs.ansible.com/ansible/latest/intro_windows.html#windows-how-does-it-work))

#### How to

1. Open deployment folder: `cd deploy`
2. Setup and activate virtualenv: `virtualenv venv && venv/bin/activate`
3. Install ansible: `pip install -r requirements.txt`
4. Install ansistrano: `ansible-galaxy install -r requirements.yml`

#### Deploy application

- Stage: `ansible-playbook deploy.yml -i stages/stage`
- Prod: `ansible-playbook deploy.yml -i stages/prod`


## Style Guide

We use the build in elixir formatter:

```
docker-compose exec elixir mix format
```

## FAQ

<details>

### How do I remove the scaffolded app?

```
./scripts/cleanup_scaffold.sh
```

### How do I run the test suite locally?

```
docker-compose run --rm elixir test
```

</details>


## Learn more

* Official website: http://www.phoenixframework.org/
* Guides: http://phoenixframework.org/docs/overview
* Docs: https://hexdocs.pm/phoenix
* Mailing list: http://groups.google.com/group/phoenix-talk
* Source: https://github.com/phoenixframework/phoenix


## Contributing

Want to contribute? Awesome. Just send a pull request.


## License

Phoenix Boilerplate is released under the [MIT License](http://www.opensource.org/licenses/MIT).
