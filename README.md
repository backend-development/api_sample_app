# IOU - "I Owe You" - remember the money you owe to friends

this little web app helps you keep track of money
you lent friends or that they lent you.

technically, it is a rails app with some react added.

## Based on:

- https://github.com/rails/webpacker/blob/master/docs/css.md
- https://ericlondon.com/2018/03/18/rails-5-api-and-react-frontend-jwt-token-authentication.html


## Using docker-compose for development

Make sure to have docker and docker-compose installed.

```
cp config/dockerized_database.yml config/database.yml
docker-compose up -d # start development, test postgres instances
docker-compose up -d # start development, test postgres instances
docker-compose down -v # stop postgres and remove volumes
bundle exec rails db:migrate
rails s
```

## Images Used under cc:

https://www.flickr.com/photos/zoliblog/3198088960
