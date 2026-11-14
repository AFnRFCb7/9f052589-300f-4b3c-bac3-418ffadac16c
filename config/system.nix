{ config, pkgs, ... } :
    {
        boot.loader.grub.enable = true;
        boot.loader.grub.device = "/dev/xvda";
        fileSystems."/" = {
          device = "/dev/disk/by-uuid/f222513b-ded1-49fa-b591-20ce86a2fe7f";
          fsType = "ext4";
        };
        security.sudo.wheelNeedsPassword = false ;
        system.stateVersion = "24.11";
    }