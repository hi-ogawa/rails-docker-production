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

## Deployment (on vagrant VM)

- Prepare vagrant

```
$ VAGRANT_CWD=./scripts/deployment vagrant up
```

- Boostrap

```
$ ./scripts/deployment/bootstrap.sh
```

Then, visit http://192.168.33.10/high_scores.

- Update

```
$ ./scripts/deployment/deploy.sh
```

Here is a result of `time`:

```
$ time ./scripts/deployment/deploy.sh
...
real	2m6.243s
user	0m1.768s
sys	0m3.840s
```

## Open `rails console`

After `ssh ubuntu@<vagrant ip>`,

```
$ cd ~/app
$ docker-compose -f docker-compose.run.yml exec rails bin/rails c production
> HighScore.count
   (1.4ms)  SELECT COUNT(*) FROM `high_scores`
=> 1
```

## TODOs

- staging environment
- versioning and rollback deploy
  - add hash to production image
  - keep certain number of production images
- nginx/haproxy reverse proxy
  - serve static assets from nginx
- rolling update (zero downtime)
- mysql backup
- diagnose on production
  - logging
