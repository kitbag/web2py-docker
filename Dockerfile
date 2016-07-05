FROM ubuntu:latest

ENV INSTALL_DIR /home/www-data/
ENV W2P_DIR $INSTALL_DIR/web2py
ENV PW web2pyadmin

# Get dependancies
RUN apt-get update && \
    apt-get install build-essential curl libbz2-dev libc6-dev libfreetype6 libfreetype6-dev libgdbm-dev libjpeg62-dev libjpeg8 libncursesw5-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libz-dev nginx-full python-dev python-pip python-pygraphviz sudo supervisor unzip uwsgi -y && \
    apt-get autoremove && \
    apt-get autoclean && \
    mkdir /etc/nginx/conf.d/web2py && \
    mkdir /etc/nginx/cert

# NGINX Configs (in repo)
COPY web2py /etc/nginx/sites-available/web2py

# NGINX Keys (HEADS UP! -> assumption is these are produced and dropped post-cloning)
COPY web2py.key /etc/nginx/ssl/web2py.key
COPY web2py.crt /etc/nginx/ssl/web2py.crt
COPY dhparam.pem /etc/nginx/ssl/dhparam.pem

# Python dependancies
RUN pip install setuptools --no-use-wheel --upgrade pip && \
    pip install uwsgi stepic Pillow requests

# NGINX Setup
RUN ln -s /etc/nginx/sites-available/web2py /etc/nginx/sites-enabled/web2py && \
    rm /etc/nginx/sites-enabled/default && \
    chmod 400 /etc/nginx/ssl/web2py.key

# Emperor Configs (in repo)
COPY web2py.ini /etc/uwsgi/web2py.ini
COPY uwsgi-emperor.conf /etc/init/uwsgi-emperor.conf

# Supervisor Configs (in repo)
COPY supervisord.conf /etc/supervisor/conf.d/

# Install web2py
RUN mkdir $INSTALL_DIR && \
    cd $INSTALL_DIR && \
    curl -O http://www.web2py.com/examples/static/web2py_src.zip && \
    unzip web2py_src.zip && \
    rm web2py_src.zip && \
    mv web2py/handlers/wsgihandler.py web2py/wsgihandler.py && \
    chown -R www-data:www-data web2py && \
    cd $W2P_DIR && \
    sudo -u www-data python -c "from gluon.main import save_password; save_password('$PW',80)" && \
    sudo -u www-data python -c "from gluon.main import save_password; save_password('$PW',443)"

# Remove packaged apps (expectation is you have your own)
RUN cd $W2P_DIR/applications && \
    rm -R examples && \
    rm -R welcome

# Add the admin app as the default route
COPY routes.py $W2P_DIR/

EXPOSE 80 443 8000

WORKDIR $W2P_DIR

CMD ["/usr/bin/supervisord"]