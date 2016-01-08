FROM alpine:3.3
# MAINTAINER Peter T Bosse II <ptb@ioutime.com>

RUN \
  REQUIRED_APKS="g++ gcc gdbm-dev git libffi-dev libxml2-dev libxslt-dev linux-headers make musl-dev nodejs openssl-dev readline-dev sqlite-dev" \

  && RAILS_GEMS="rails sqlite3 sass-rails uglifier coffee-rails jquery-rails turbolinks jbuilder sdoc byebug spring tzinfo-data" \

  && MIDDLEMAN_GEMS="em-websocket middleman middleman-autoprefixer middleman-blog middleman-compass middleman-livereload middleman-minify-html middleman-robots mime-types slim" \

  && apk add --update-cache \
    $REQUIRED_APKS \

  && printf "%s\n" \
    "gem: --no-document" \
    >> "${HOME}/.gemrc" \

  && wget -P /tmp -q https://cache.ruby-lang.org/pub/ruby/stable-snapshot.tar.xz \
  && tar -xJf /tmp/stable-snapshot.tar.xz -C /tmp \

  && cd /tmp/stable-snapshot \
  && ./configure --disable-install-doc \
  && make \
  && make install \

  && gem update --system \
  && gem install \
    nokogiri -- --use-system-libraries \
  && gem install \
    web-console --version "~> 2" \
  && gem install \
    $RAILS_GEMS \
    $MIDDLEMAN_GEMS \
  && gem cleanup \

  && rm -rf /tmp/* /var/cache/apk/* /var/tmp/*
