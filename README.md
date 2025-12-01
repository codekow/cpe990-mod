# Rebuilding the CPE990 Firmware

```sh
docker build -t buildroot .

docker run -it --rm \
  --name buildroot \
  -v $(pwd):/build:z \
  buildroot
```
