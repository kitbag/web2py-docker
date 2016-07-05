# web2py Docker Bootstrap [web2py-docker]
Installs a fresh web2py instance running behind NGINX with only the admin app installed and running. This should get you started with an almost production quality setup of [web2py behind NGINX](http://web2py.com/books/default/chapter/29/13/deployment-recipes#Nginx). There are some setup things you will have to consider before building this, mainly any small changes to your configs and you will need to add your own keys. Run with something like:
```
docker run --name web2py -d --net <your network> -p 80:80 -p 443:443 --net-alias web2py web2py:latest
```

# Generating Keys
This will generate a self-signed certificate and key, which should work for building (ensure to fill in the XX and adjust any settings).
```
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=XX" -keyout web2py.key -out web2py.crt
openssl dhparam 2048 -out dhparam.pem
```

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

Since you are possibly in production, you should disable admin. This is left in so you have a GUI in order to port your app in, make any changes and test them, then remove the admin app. This implies you have a development version running elsewhere, so any changes or updates will be a matter of pushing that app into a new Docker container in the same manner, where you build a new container (probably good for updating things anyways), run it, run the services, add the app, then test it.

# Reference
Because I couldn't possibly make this stuff up.
- NGINX
 - [Perfect SSL Score](https://michael.lustfield.net/nginx/getting-a-perfect-ssl-labs-score)
 - [Setting up HTTPS on NGINX](https://bjornjohansen.no/securing-nginx-ssl) - Follow the other links too
- [web2py, The Book](http://web2py.com/books/default/chapter/29) - Not sure how much more reference you really need
