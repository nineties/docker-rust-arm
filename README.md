# Docker image for cross compiling rust for raspberry pi

This docker images is created based on the following repository
https://hub.docker.com/r/yasuyuky/rust-arm/
and the following document.
https://github.com/Ogeon/rust-on-raspberry-pi

# Usage
Change directory to your project root and run following command.

```
docker run -it --rm -v ${PWD}:/source nineties/rust-arm
```

Then run `cargo build`.

# License
MIT
