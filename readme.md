# V0.1 - WORKS
This script is inspired by bugswriter and JaKooLit.  
The dwm used is a fork of bugswriter's dwm package and   
hyprland used is JaKooLit's Arch-Hyprland [ which is the most perfectly maintained hyprland repo I have come across ]  
. . .   
. .   
.   

# Very Important 

- [ ] I need to make my dotfiles private ASAP . need to add login features in this script in order to clone my files [ better ]
 - [ ] option to select dot-files [ select the default - which is  going to be mine ]
- [ ] Try to reduce usage of AUR as much as possible. 
- [ ] Give options if the user wants AUR and the applications via AUR 
- [ ] check if there are alternatives

## Testing 

- [ ] check pacman logs to verify all the downloaded packges.


## TODO  
- [ ] fix this page
- [ ] try and test omarchy
- [ ] try and test prasoon rangan and others
- [ ] try and test no-script installation
- [ ] clean global variable declaration
- [ ] grace quit
    - [ ] script failure
    - [ ] on command
- [ ] Express run ( no sleep )
- [ ] Minimal setup ( skip misc packages )
- [ ] Add a disclaimer - 
      1. at your own risk
      2. check packages file for the packges requiores [ 🤔 if you could use the packages.md for actuall files that are going to be downlaoded . ]
      3. add that you use JaKooLit and lukesmith/bugswriter's DWM.
      4. You configure the boot loader [ test that and make for that ] . 
      5. access the personal space on the hard disk . and that I won't be responsible for any loss that happesn but you can surely notify / talk to me about it. [ give a place for them to talk]
- [ ] Make Sure there are no personal files
- [ ] once FS are mounted we have to press enter , fix that
- [ ] multiple username entries - one is on "building user environment"
- [ ] Ja's script also has extra spice to pacman.conf - remove one.
- [ ] pyenv plugin setup and export those envs in zsh.
- [ ] dot files isn't cloning `shadow_clone` and `nvim` and `hypr`
- [ ] Add options so users can pick if they want `tailscale` and `syncthing` setup. DO these for other packages as well.
- [ ] careful copying of files/dirs from `dot-files` to main `~/.config`
- [ ] `xorg-server` package.
- [ ] `.xauthority` not found.
- [ ] add `.xinitrc` to dwm packages.
- [ ] `xwallpaper`,`xss-lock`,`lm_sensors`, `picom` and `numlockx` didn't get installed. 
- [ ] try `pipx install pyprland` .
- [ ] `/etc/locale.gen` needs fix since `local-gen` also reads the comment - hence let the comment be above or below the actual UTF config.
- [ ] after showing fstab in nvim - somewhere in the script it enter ```cto``` that should be replaced with ```cat``` or whatever appropriate 
- [ ] when you tell about `file.sh` - also mention that ``````pendrive can now be removed``````
- [ ] making sure the before running `file.sh` you are connected to internet - maybe give a prompt .
- [ ] redirect the output of the script so that - you could read the logs later.
- [ ] mention all the points where `user interaction` is required - for ex: entering username . entering passwords . setting up partitions , among others . [ or maybe just automate this ].
- [ ] setup usage like `curl..chmod +x...` 
- [ ] fix script stuckking after mounting btrfs subv [ script demands here - enter or any other key ]
- [ ] fix ssh / GPG setup
- [ ] chekc how ani-cli does font colors - they have very few lines of code
- [ ] replace barrier with lan-mouse
- [ ] Caution
    - [ ] complete storage
    - [ ] storage on selected packages
    - [ ] to turn of secure boot
    - [ ] to set boot mode to UEFI ( check if this is mandatory )
    - [ ] install sources AUR / official repository
- [ ] change subv mount points in fstab while in nvim.
- [ ] change `perms` and `owners` of mounted points of those subv.
- [ ] give option for default and custom subvs.
- [ ] laptop keybindings and pc keybindings could be different for hyprland dots and dwm - make sure to pull those . with option.
- [ ] scripts have gone with root permission in both `/bin` and `$HOME`
- [ ] add AI support to nvim
- [ ] after the moun point if created make sure there are no files in that or being installed in that . [ completely wipe `archinstall` from the script ].
- [ ] exp-make sure DWM is installed from dots itself.
    - [ ] looks like dwm and st fails installation
- [ ] exp-hyprland is installed from my dots
    - [ ] .zshrc gets overridden by linuxBeginnings/kool's dots
- [ ] setup of storage based on user choices  - if its for pool of vms- then setup virsh pool on it
    - [ ] though your partition might be in the fstab - it might be possible that libvirtd starts before that, 
    and might therefore break - check if a `RequriesMountsFor=/your/parition` is required in its systemctl edit libvirtd
- [ ] add caveats to not enter any key or ```enter``` it self at any part of the script since that might disorganise you stdin to the future requests for stdin. And the whole thing gets unpredictable. [ fix this ]
- [ ] Alert user for syncthing backup  
- [ ] Implement checks  
- [ ] what is user messes up entering passwords to setting up drives  
- [ ] alert user on few events - give an option to make it silent [ default would be it producing some sound ]
- [ ] replace  
  barrier - > lan-mouse  [test in both hyprland and dwm]
  hoppscotch  
- [ ] debloat ANSI script  
- [ ] TTA 
    - [ ] Optimize TTA by time  
        - [ ] EXPRESS  
        - [ ] INSTANT  
    - [ ] Optimize TTA by command  
- [ ] Choices  
    - [ ] kernel download  
    - [ ] kernel compile  
    - [ ] kernel selection  
    - [ ] TTA [express/instant/stanadard]
    - [ ] dot-files selections
- [ ] tmux setup

1.Automation - there are parts in between the script where user intervention is required   
2.Generalisation - Right now it is only personalised to fit my needs [ may fir yours ]   
3.Begineer friendly - I haven't made a guide nor comments that would help a begineer.   
4.Verification - Since this is a linear scripts I have to make sure that one module of the script is successful to process for the successive module   

# Automation 
- [ ] 0 user intervention  
- [ ] 0 user interactoin  
