# Octo Events

## Installation

Ruby: ruby-3.1.2
Rails: Rails 7.0.4

Requirements:

- Docker version 20.10.18
- docker-compose version 1.29.2

### Development

1. Build the Docker image: `docker-compose build`
2. Setup the DB: `docker-compose run octo_events rails db:setup`
3. Run the the web server: `docker-compose up`
