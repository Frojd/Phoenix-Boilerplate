# Phoenix Boilerplate

This is a Phoenix/Elixir boilerplate that includes a auto-setup, docker support and deploy scripts.


## Features

- Elixir 1.6
- Phoenix 1.3
- Auto scaffolding (with `phx.new`)


## Clean install

1. Copy configuration

    ```
    cp docker/config/web.example.env docker/config/web.env
    ```

2. Open `docker/config/web.env` and change `SCAFFOLD_APP_NAME=` to the otp name you want for your app
3. Run: docker-compose up
4. Done. Visit [localhost:4000](http://localhost:4000)


# Tests

- `docker-compose run --rm web test`


## Contributing

Want to contribute? Awesome. Just send a pull request.


## License

Phoenix Boilerplate is released under the [MIT License](http://www.opensource.org/licenses/MIT).
