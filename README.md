# Octo Events

## Installation

Ruby: ruby-3.1.2

Rails: Rails 7.0.4

Requirements:

- Docker version 20.10.18
- docker-compose version 1.29.2

### Development

1. Configure the env vars: `cp .env.example .env`
2. Build the Docker image: `docker-compose build`
3. Generate the ISSUES_EVENTS_WEBHOOK_SECRET: `docker-compose run octo_events ruby -rsecurerandom -e 'puts SecureRandom.hex(20)'` and copy the value to the .env file.
4. Setup the DB: `docker-compose run octo_events rails db:setup`
5. Run the the web server: `docker-compose up`

You may want to run the tests: `docker-compose run octo_events rspec`

Note: You must set the same secret on GitHub webhooks secret config.
