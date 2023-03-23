# docker-mkspiffs

```shell-session
$ docker run --rm ghcr.io/yk-lab/mkspiffs:main mkspiffs --version
```

For example:

```shell-session
$ docker run --rm -v ${PWD}/dist:/dist -v ${PWD}/data:/data -it ghcr.io/yk-lab/mkspiffs:main mkspiffs -c /data -b 4096 -p 256 -s 0x1E0000 /dist/spiffs.bin
```
