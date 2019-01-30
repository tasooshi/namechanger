# namechanger

## About

Installs itself as a systemd service and changes name of the host randomly on each boot. Or manually, when requested. Works with:

* Backbox
* BlackArch
* Debian 8/9
* Kali
* Parrot
* Ubuntu 16.04/18.04/18.10

See [targets](https://github.com/tasooshi/namechanger/tree/master/targets) for more precise information on versions and examples.

## Installation

Clone the repository and:

    make install

## Usage

Reboot or...

    root@Jan:~# namechanger && hostname
    HUI-PAI-GUO-JI-GONG-SI-CHUAN-MEI-YOU-XIAN-GONG-SI-D18EVI
    root@Jan:~# namechanger && hostname
    GRES-GUTSULIAK-0DRUMM
    root@Jan:~# namechanger && hostname
    ANDERSSON-NORDIN-AB-JK1AZX

## Notes

* Keep in mind that several network services keep track of your host name. Changing name of your box on the fly without putting down your network interfaces and changing MAC addresses doesn't make much sense.
* Don't forget to update pip.

## Structure

Defaults for Kali Linux:

    /
    ├── etc
    │   └── default
    │       └── namechanger
    ├── usr
    │   ├── lib
    │   │   └── systemd
    │   │       └── system
    │   │           └── namechanger.service
    │   └── local
    │       └── bin
    │           └── namechanger
    └── var
        └── log


## Customization

If you'd like to change defaults, edit `/etc/default/namechanger` and adjust `NAMECHANGER_HOSTNAMEGEN_ARGS` variable according to your needs. Refer to [hostnamegen](https://github.com/tasooshi/hostnamegen) for examples.

## Legal

* License: BSD-3-Clause (http://opensource.org/licenses/BSD-3-Clause)

## Contact

In case you feel the need to get in touch:

* tasooshi@pm.me
* [GPG](https://tasooshi.github.io/6C3E62B2.asc)
