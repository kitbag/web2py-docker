# web2py Docker Bootstrap [web2py-docker]
Installs a fresh web2py instance running behind NGINX with only the admin app installed and running. This should get you started with an almost production quality setup of [web2py behind NGINX](http://web2py.com/books/default/chapter/29/13/deployment-recipes#Nginx). There are some setup things you will have to consider before building this, mainly any small changes to your configs and you will need to add your own keys.

# Generating Keys

# Other Considerations
Consider putting this on a user-defined network and not on the bridge. This should be the best way to link web2py to other containers. These would be used mainly for optimization, and there are some easy to run containers provided that can be quickly set up and run. For example:
- [Postgresql](http://web2py.com/books/default/chapter/29/13/deployment-recipes#Postgresql) - Use for [your database]().
```
docker run --name postgres -e POSTGRES_PASSWORD=<your password> -d --net <your network> --net-alias postgres postgres
```

There may be some configuration changes, so either build using this image or `docker exec -it` in and change them manually.

- [Redis](https://hub.docker.com/r/library/redis/) - [Caching and sessions](http://web2py.com/books/default/chapter/29/13/deployment-recipes#Caching-with-Redis)
```
docker run --name redis -d --net <your network> --net-alias redis redis
```
