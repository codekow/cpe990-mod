# Dump of notes

## Start `telnetd` from web console

http://192.168.255.100/Advanced_Console_Content.asp

```sh
  # telnetd -p 23
  run_telnetd
```

## Setup `dropbear` / `ssh`

```sh
cat << EOF > /etc/storage/started_script.sh
#!/bin/sh

start_telnet(){
  telnetd -p 23
}

start_ssh(){
  DROPBEAR_DIR=/etc/storage/dropbear
  [ -d "${DROPBEAR_DIR}" ] || mkdir -p ${DROPBEAR_DIR}

  [ -e ${DROPBEAR_DIR}/rsa_host_key ] || \
    dropbearkey -t rsa -f /etc/storage/dropbear/rsa_host_key

  /usr/sbin/dropbear -P /var/run/dropbear.1.pid -p 22 -K 300 -W 262144
}

# start_telnet
start_ssh
EOF

/etc/storage/started_script.sh
/sbin/mtd_storage.sh save

reboot
```

## Dump current firmware

```sh
ssh admin@[hostname/ip]
```

```sh
cat /proc/mtd > /tmp/mtd
cp /dev/mtd*ro /tmp
```

```sh
mkdir dump
scp -O admin@[hostname/ip]:/tmp/mtd* dump/
```

```sh
binwalk
```

```output
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
64            0x40            LZMA compressed data, properties: 0x5D, dictionary size: 33554432 bytes, uncompressed size: 3495744 bytes
1180496       0x120350        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 4384758 bytes, 740 inodes, blocksize: 131072 bytes, created: 2023-11-28 02:37:21
```

[Firmware Info Dump](firmware)

Extract squashfs

```sh
# extract squashfs from firmware
dd bs=1 skip=1180496 if=firmware/7621-1000M-21A_3.4.3.4-017.trx of=squashfs.dd

# compare to on device
dd bs=1 count=4384758 if=dump/mtd4ro of=device.dd

# compare hash
md5sum *.dd
file *.dd
```

```output
52cfa5a78f39ec6dd5243e494ac01325  device.dd
52cfa5a78f39ec6dd5243e494ac01325  squashfs.dd

device.dd:   Squashfs filesystem, little endian, version 4.0, xz compressed, 4384758 bytes, 740 inodes, blocksize: 131072 bytes, created: Tue Nov 28 02:37:21 2023
squashfs.dd: Squashfs filesystem, little endian, version 4.0, xz compressed, 4384758 bytes, 740 inodes, blocksize: 131072 bytes, created: Tue Nov 28 02:37:21 2023
```

Firmware Size

```sh
 196608 mtd0ro
  65536 mtd1ro
  65536 mtd2ro
1180496 mtd3ro
6618288 mtd4ro
 262144 mtd5ro
8060928 mtd6ro
8388608 mtd7ro
```

## Setup Buildroot

```sh
docker build -t buildroot .

docker run -it --rm \
  --name buildroot \
  -v $(pwd):/build:z \
  buildroot
```

```sh
cd buildroot 
make qemu_mips32r2el_malta_defconfig
make menuconfig
```

## Additional Info

- [OpenWrt - Similar Devices](https://downloads.openwrt.org/releases/23.05.5/targets/ramips/mt7621/)
- [OpenWrt Forum - 5G issues](https://forum.openwrt.org/t/solved-openwrt-on-mt7621-mt7615n-devices-with-5ghz-problems/107392)
