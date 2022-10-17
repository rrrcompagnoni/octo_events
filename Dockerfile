FROM ruby:alpine3.16

LABEL Name=octo_events Version=0.0.1

RUN apk add build-base git tzdata postgresql-dev postgresql-client libxslt-dev libxml2-dev imagemagick

EXPOSE 3000

WORKDIR /home/octo_events

COPY . .

RUN bundle

CMD ["sh", "-c", "rails s -b 0.0.0.0"]
