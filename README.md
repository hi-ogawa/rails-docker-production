# Rails on production with Docker

## Development

```
$ ./scripts/development/dkc up -d
$ ./scripts/development/dkc exec rails bash
$# bin/rake db:create db:migrate
$# bin/rails s -b 0.0.0.0
```

## Deployment (locally)

```
$ ./scripts/deployment/dkc.build run --rm build
$ ./scripts/deployment/dkc.build build dist
$ ./scripts/deployment/dkc.run up -d
$ ./scripts/deployment/dkc.run exec rails bash
$# bundle exec rake db:migrate
```

## TODOs

- use vagrant and imitate remote host
  - ssh with ansible or capistrano
    - capistrano should work (or with some patching)
- staging environment
- versioning and rollback deploy
  - add hash to production image
  - keep certain number of production images
- nginx/haproxy reverse proxy
  - serve static assets from nginx
- rolling update (zero downtime)
- mysql backup
- diagnose on production
  - rails console
  - logging
