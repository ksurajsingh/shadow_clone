# V0.1 - WORKS
This script is inspired by bugswriter and JaKooLit.  
The dwm used is a fork of bugswriter's dwm package and   
hyprland used is JaKooLit's Arch-Hyprland [ which is the most perfectly maintained hyprland repo I have come across ]  
. . .   
. .   
.   

## Testing 

- [ ] check pacman logs to verify all the downloaded packges.


## TODO  
- [ ] fix this page
- [ ] pyenv plugin setup and export those envs in zsh.
- [ ] dot files isn't cloning `shadow_clone` and `nvim` and `hypr`
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
- [ ] change subv mount points in fstab while in nvim.
- [ ] change `perms` and `owners` of mounted points of those subv.
- [ ] give option for default and custom subvs.
- [ ] laptop keybindings and pc keybindings could be different for hyprland dots and dwm - make sure to pull those . with option.
- [ ] after the moun point if created make sure there are no files in that or being installed in that . [ completely wipe `archinstall` from the script ].
- [ ] make sure DWM is installed from dots itself.
- [ ] add caveats to not enter any key or ```enter``` it self at any part of the script since that might disorganise you stdin to the future requests for stdin. And the whole thing gets unpredictable. [ fix this ]
- [ ] Alert user for syncthing backup  
- [ ] Implement checks  
1.Automation - there are parts in between the script where user intervention is required   
2.Generalisation - Right now it is only personalised to fit my needs [ may fir yours ]   
3.Begineer friendly - I haven't made a guide nor comments that would help a begineer.   
4.Verification - Since this is a linear scripts I have to make sure that one module of the script is successful to process for the successive module   
