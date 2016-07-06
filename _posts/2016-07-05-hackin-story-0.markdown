---
layout: post
title: "Hackin' story #0 /Making kernel/"
image: /downloads/icons/hackin.png
tags: [linux, kernel, ubuntu]
author: abcdw
---

Few days ago I wanted to get some knowledge about [linux][] and started to write simple loadable kernel module. I hoped it's pretty simple to make it work, but [Ubuntu][ubuntucom] isn't so user-friendly as everyone says and loading unsigned LKM, patching and rebuilding kernel is a problem. I thought about installing my favorite [Gentoo][] or trying new for me [Arch][], where it will be easy, but decided to accept challenge and to solve problems in-place.

# What are you talking about?

This series of stories will be about [linux kernel][linux] and it's hacking. At least I hope so :smiley:. It's not about some distribution, window manager, command interpreter or something like that. It's about [C][], [kernel][linux], patching and mailing, but sometimes it might be a little distro-specific.


In this post my experience in the building a custom kernel for ubuntu 16.04 without fakeroot and other crap will be shared, also the reason will be highlighted. There is some related articles, which can be useful for you:

* [KernelBuild][] on kernelnewbies
* [Kernel Configuration][kernel-gentoo] on gentoo wiki
* [Kernel Handbook][kernel-handbook] on debian.org

# What the reason?

Few days ago I started to write kernel module, after I finished and built it I realized that this module can't be loaded into current kernel, because ubuntu default config contains [CONFIG_MODULE_SIG][], which prevents loading of unsigned modules. I had two options: sign my module (and add key to kernel) or build kernel without [CONFIG_MODULE_SIG][]. Both options requires rebuilding kernel and the second have been chosen as simpler. For some distros like [Gentoo][] it's very natural to build kernel (part of installation and update process), but for some it's not so. 

# How to build it?

After some research I found several wiki-pages and most actual is [BuildYourOwnKernel][]. To simplify building process for you most useful commands was carefully selected and placed below.

## Obtain linux-sources and bulding dependencies

It's many possible ways to get source code: via git, as tarball or package, but most convenient in my opinion is to get it via package manager. 

~~~bash
mkdir -p ~/usr/src/ && cd ~/usr/src
apt source linux-image-$(uname -r)
sudo apt build-dep linux-image-$(uname -r)
~~~

## Create .config

When you already have source code and building tools, it's important to create build configuration from current running kernel config and enable or disable necessary options like [CONFIG_MODULE_SIG][].

~~~bash
zcat /proc/config.gz > .config || cat /boot/config-$(uname -r)* > .config
make menuconfig
~~~

> __Tip__: If you use newer version of sources than your current kernel, after creation of `.config` you will need to do `make oldconfig` and manually answer questions about new options.

## Make it -jN && install it

General way to build and install kernel and modules with `make && sudo make modules_install install` described in [KernelBuild][] guide, but we will go the other way. We will build `.deb` package and install it.

~~~bash
make -j5 bindeb-pkg
sudo dpkg -i ../linux-image-* ../linux-headers-*
~~~

> __Tip__: -jN is optional parameter, which can be used to increase performance, personally I use N equal to `nproc`(number of cores) + 1.

After that, the image will be placed in `/boot` directory and grub config will be updated with path to fresh kernel. You can `reboot` your system and enjoy.

# What next?

You built and booted your own kernel, isn't that enough?
Someday I'll tell how to write, build and test simple loadable kernel module, but not today. Happy hacking.

[ubuntucom]:           http://www.ubuntu.com/
[gentoo]:              https://gentoo.org/
[arch]:                https://www.archlinux.org/
[linux]:               https://www.kernel.org/
[c]:                   https://en.wikipedia.org/wiki/C_(programming_language)
[kernelbuild]:         http://kernelnewbies.org/KernelBuild

[kernel-handbook]:     http://kernel-handbook.alioth.debian.org/ch-common-tasks.html#s-common-getting
[kernel-gentoo]:       https://wiki.gentoo.org/wiki/Kernel/Configuration
[BuildYourOwnKernel]:  https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel
[CONFIG_MODULE_SIG]:   https://wiki.gentoo.org/wiki/Signed_kernel_module_support
