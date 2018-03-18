# Phoenix Boilerplate

This is a Phoenix/Elixir boilerplate that includes a auto-setup, docker support and deploy scripts.


## Features

- Elixir 1.6
- Phoenix 1.3
- Auto scaffolding (with `phx.new`)
- Automatic dependency management and db migrations through docker


## Clean install

1. Copy configuration

    ```
    cp docker/config/web.example.env docker/config/web.env
    ```

2. Open `docker/config/web.env` and change `SCAFFOLD_APP_NAME=` to the otp name you want for your app
3. Run: docker-compose up
4. Done. Visit [localhost:4000](http://localhost:4000)


## FAQ

<details>

### How do I remove the scaffolded app?

```
./scripts/cleanup_scaffold.sh
```

### How do I run the test suite locally?

```
docker-compose run --rm web test
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
