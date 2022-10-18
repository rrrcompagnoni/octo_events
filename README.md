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

## Configure a Webwook

- Follow GitHub instructions <https://docs.github.com/en/developers/webhooks-and-events/webhooks/creating-webhooks>.
- Set the Webhook URL on GitHub: `{TUNNEL_HOST}/issues/events`.
- Set the content type to `application/json`.
- Set the secret you have generated before.
- Select the individual events `issues` and `issue_comments`.
- Set active.
- Start creating a few issues :)

## Listing events

```sh
  curl --location -g --request GET 'http://localhost:3000/issues/{ISSUE_ID}/events?page[size]=1&page[number]=1' \
  --header 'Authorization: Basic eHh4Onh4eA=='
```

The page param is optional.
