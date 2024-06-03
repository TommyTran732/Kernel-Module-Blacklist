# Kernel Module Blacklist

This is my attempt at making a common kernel module blacklist that can be used across different systems.
The goal is to be as strict as possible with this blacklist while not breaking common functionality and applications.

The idea here is that we collect the list of kernel modules available and the list of kernel modules actively used on production systems. Unused kernel modules will be added to the blacklist. For a bit of convienience and reliability, we will also not blacklist the modules listed `kmod-whitelist-start` and `kmod-whitelist-all`.

## Required data

If you want to send me your data, at minimum you will need the following:

- The available kernel module on your system. This can be obtained with:

```bash
ls -R /lib/modules/"$(uname -r)"/kernel/{drivers,fs,net,sound} | grep "\.ko" | sed 's/.ko.xz//g' > blacklist.txt
```

- The kernel modules being used on your system. This can be obtained with:

```bash
lsmod | awk '{ print $1 }' > necessary.txt
```

- Your hardware type (What laptop model is it? Which cloud provider hosts this vps? etc).

- The output of `cat /proc/version`.

Additionally, the output of `lshw`, information on your workload, etc will be greatly appreciated, but they are not necessary.

## Supported hardwware/Workload

Reasonably new and common hard hardware/workloads will be added to the `sample-data` directory and used to generate a kernel module blacklist. Vulnerable kernel modules and technologies such as Thunderbolt will always remain on the blacklisted.

Niche systems will be added to the `sample-data-not-used` directory. Old systems in `sample-data` will also be moved to `sample-data-not-used` when they become irrelevant. Systems in this directory will not be used to generate the kernel module blacklist, however their information remain available for the public. You can still generate your own blacklist.

## Generating your own blacklist

- Follow the instructions above get the list of availble and necessary kernel modules on each of your system.
- Put your data in the appropriate directories in `sample-data`.
- Adjust whitelist list in `kmod-whitelist-start` and `kmod-whitelist-all`. Kernel modules with a name starting with a string inside `kmod-whitelist-start` will be removed from the blacklist. Likewise, kernel modules with a name containing the a string inside `kmod-whitelist-all` will also be removed from the blacklist.
- Run `generate-kmod-blacklist-aggregate`. The generated blacklist will be put in `etc/modprobe.d`.

Alternatively, if you only want to generate a blacklist for 1 specific running system, you can use `generate-kmod-blacklist`. Note that this will not apply the whitelist in `kmod-whitelist-start` and `kmod-whitelist-all`.
