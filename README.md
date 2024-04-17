# drawdb-io
Free, simple, and intuitive online database design tool and SQL generator.

Local testing `Dockerfile`

~~~
FROM node:20-alpine 

RUN apk --no-cache add git jq curl
~~~

Run Docker

~~~
//Building containers
docker build -t drawdb .

//Enter the container command line
docker run -it --name=drawdb --rm -v ~/drawdb-io:/tmp/drawdb-io -e GITHUB_USER=zzqqw -e GITHUB_TOKEN=  drawdb:latest sh

//Run command in container
cd /tmp/drawdb-io
sh release-page.sh
~~~

