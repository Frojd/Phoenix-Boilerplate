# Phoenix with docker lab

## Clean install

1. Copy configuration

    ```
    cp docker/config/web.example.env docker/config/web.env
    ```

2. Open `docker/config/web.env` and change `SCAFFOLD_APP_NAME` to the otp name you want for your app
3. Run: docker-compose up
4. Done. Visit [localhost:4000](http://localhost:4000)


# Tests

- `docker-compose run --rm web test`
