# Fake S3 on Docker

This is a simple Docker container for running [fake-s3](https://github.com/jubos/fake-s3). Use it as a sandbox when developing/testing apps reliant on S3.

## Usage

The simplest way to run is to just use the Docker Hub image.

```
docker run -p 4567:4567 --rm --name fake-s3-inst verespej/fake-s3
```

If you want to run from source or wish to customize the image for your needs, do the following instead.

```
git clone https://github.com/verespej/fake-s3-docker.git
cd fake-s3-docker
docker build -t fake-s3 .
docker run -p 4567:4567 --rm --name fake-s3-inst fake-s3
```

You can now access the s3 sandbox via whatever IP address Docker is using (on my machine, it defaults to 192.168.99.100) and the port specified in the `docker run` command (`4567` in the examples above). The above examples tell Docker to destroy the container after you stop running it by specifying the `--rm` option. If you want data to persist between runs, remove the `--rm` option.

Now, you'll need to configure your aws client(s) to point to this docker container instance as the **endpoint url**. There's a ton of documentation on endpoints [here](http://docs.aws.amazon.com/general/latest/gr/rande.html) and AWS clients typically determine them automatically. We'll override this behavior since we want to point to our sandbox. Use the following guidelines for doing this.

* [AWS CLI](http://docs.aws.amazon.com/cli/latest/reference/)
* [Javascript](http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/Endpoint.html)
* Every client should have this - see the documentation for whichever AWS client you use

If you're running a service you want to connect to the sandbox from another Docker container, you can link them. As an example, you can run an [aws-cli-docker](https://github.com/verespej/aws-cli-docker) container as follows (follow the instructions in that repo's README before doing the following).

```
docker run --rm -it -v /<full path>/aws-cli-docker/configs:/root/.aws --link fake-s3-inst:fake-s3 aws-cli
```

When we start the container above, using the `--link` option allows us to access the fake-s3-inst container using the alias *fake-s3*.

Once the container has started, you can run commands described in the [S3 CLI documentation](http://docs.aws.amazon.com/cli/latest/reference/s3/index.html#cli-aws-s3) against the sandbox. The following lists buckets.

```
aws --endpoint-url http://fake-s3:4567 s3 ls
```

