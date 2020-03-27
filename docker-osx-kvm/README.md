# Docker OSX KVM

## Intro

**Note**: you have to have Apple® hardware which the operating system is free only for who has purchased your equipment.

This project does not encourage piracy but to be able to test, develop applications without having to install extra applications on our own Mac.

We are not responsible for misuse or legal issues for infringing patents or damages to third parties.

This project does not distribute any Apple® source code.


## Container Environment

|ENV NAME|default|description|
|:--|--:|:--|
|CORE|2|number of cores to use|
|MEMORY|3G|amount of memory (M = Megabyte, g = Gigabyte)|
|KEYBOARD|es|Keyboard layout|
|CLOVER|1|Add Clover iso (0: false, *: true)|
|INSTALLER|1|Add Installer iso (0: false, *: true)|

### Keyboard layouts
||||||||||||
|---|---|---|---|---|---|---|---|---|---|---|
| ar | de-ch | es | fo    | fr-ca | hu | ja | mk    | no | pt-br | sv |
| da | en-gb | et | fr    | fr-ch | is | lt | nl    | pl | ru    | th |
| de | en-us | fi | fr-be | hr    | it | lv | nl-be | pt | sl    | tr |

## Usage

### Run

Kernel is required with kvm support.

```bash
docker run -itd  --name macOS --device /dev/kvm:/dev/kvm -p 9922:22 \
-p 5900:8080 -v /path/to/iso/folder:/data lordbasex/docker-osx-kvm
```

### Create Password VNC

```
docker exec macOS cli changepassword mypassword
```

### Connect to Browser 
http://127.0.0.1:5900
