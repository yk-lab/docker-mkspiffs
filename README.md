# docker-mkspiffs

```shell-session
# For ESP32
docker run --rm ghcr.io/yk-lab/mkspiffs:esp32-latest mkspiffs --version
# For ESP8266
docker run --rm ghcr.io/yk-lab/mkspiffs:esp8266-latest mkspiffs --version
```

For example:

```shell-session
$ docker run --rm -v ${PWD}/dist:/dist -v ${PWD}/data:/data -it ghcr.io/yk-lab/mkspiffs:esp32-latest mkspiffs -c /data -b 4096 -p 256 -s 0x1E0000 /dist/spiffs.bin
```
