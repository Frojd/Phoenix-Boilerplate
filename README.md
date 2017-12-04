# Phoenix with docker lab

## Clean install

1. Copy configuration

    ```
    cp docker/config/web.example.env docker/config/web.env
    cp docker/config/db.example.env docker/config/db.env
    ```

2. Run: docker-compose up
3. Done. Visit localhost:400


# Tests

- `docker-compose run --rm web test`
