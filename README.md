DaulPavid Archlinux Configuration
================================

<div align="left">
  <a href="https://github.com/ellerbrock/open-source-badge/">
    <img alt="OpenSource" src="https://badges.frapsoft.com/os/v1/open-source.svg?v=103" />
  </a>

  <a href="https://opensource.org/licenses/mit-license.php">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
</div>

These are various configuration files for my Arch installation.
I try to build systems that allow for PCI passthrough for my VMs,
and so this configuration is a basic example of that. Keep in mind that
this is specific to my hardware.

See: [PCI passthrough via OVMF](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF)

Relevant Hardware
-----------------

Hardware purposely purchased so that PCI passthrough would work:

    MSI GTX 1080
    MSI B150M Pro-VD
    Intel Core i7 6700K

Performance Tuning
------------------

For HDD and network performance, use VirtIO wherever possible and install
the drivers on the guest.

In `virt-manager`, set HDD storage format to *raw*,
cache mode to *none*, and IO mode to *native*.
