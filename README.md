# IOU - "I Owe You" - remember the money you owe to friends

this little web app helps you keep track of money
you lent friends or that they lent you.

technically, it is a rails app with some react added.

it needs environment variables to run:

export DEVISE_SECRET_KEY=super-super-secret-im-so-super-super-secret
export JWT_SECRET_KEY=another-incredible-secret-secret
export SECRET_KEY_BASE=diffrente-super-super-secret-im-so-super-super-secret

## Using docker-compose for development
(if you don't have postgres installed)

Make sure to have docker and docker-compose installed.

```
cp config/dockerized_database.yml config/database.yml
docker-compose up -d # start development, test postgres instances
docker-compose down -v # stop postgres and remove volumes
bundle exec rails db:migrate
rails s
```

## Images Used under cc:

https://www.flickr.com/photos/zoliblog/3198088960
