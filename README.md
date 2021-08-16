# sonar-scanner-cli

This is a port of sonnar-scanner-cli to work with armv8 cpus.


# Build
This image uses `arm64v8/alpine` as a base image. With it we can emulate an armv8 cpu in Docker.



To build this docker image you need to have QEMU enabled in your system.

Then run the command:
```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes
```

Now you can build the Docker image as usual.