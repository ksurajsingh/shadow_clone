#!/usr/bin/env bash
# == Warlord's Arch Installer - v0.2 == #

# Live

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
RED="$(tput setaf 1)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

printf '\033c'
echo -e "Welcome To  ${SKY_BLUE}Warlord's${RESET} ${RED}Arch Installer${RESET} ${YELLOW}[v0.2]${RESET}\n\n"
sleep 3

# Increase parallel downloads from 5 to 15
echo -e "\n${INFO} Increasing ${WARNING}parallel downloads${RESET} in pacman . . ."
sleep 1
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads =15/" /etc/pacman.conf
echo -e "\n${OK} DONE"
sleep 1

# Download the latest keyring
printf '\033c'
echo -e "\n${INFO} Downloading latest ${WARNING}arch-keyring${RESET} \n"
sleep 1
pacman --noconfirm -Sy archlinux-keyring
loadkeys us
echo -e "\n${OK} DONE"
sleep 1

# Sync Time and Date
printf '\033c'
echo -e "\n${INFO} Setting up ${WARNING}Network Time Protocol${RESET}"
timedatectl set-ntp true
echo -e "\n${OK} DONE"
sleep 3

# Partitions
printf '\033c'
echo -e "\n\n${YELLOW}MAKE PARTITIONS${RESET}\n"
lsblk

echo -e "\n${NOTE} Make \n${BLUE}1.EFI${RESET}\n${BLUE}2.ROOT${RESET}\n${BLUE}3.STORAGE${RESET}\n paritions\n\n${GREEN}[OPTIONAL] : SWAP${RESET}"
echo -e "\n${NOTE} Enter the drive: "
read drive
cfdisk $drive

# Format root partition
echo -e "\n${NOTE} Enter the ${YELLOW}ROOT${RESET} parition: "
read root
mkfs.ext4 $root
echo -e "${OK} root formatted"
sleep 3

# Format EFI parition
echo -e "\n${NOTE} Enter the ${YELLOW}EFI${RESET} partition: "
read efi
mkfs.vfat -F 32 $efi
echo -e "${OK} efi formatted"
echo -e "${INFO} Peronal storage will be setup after installing ${WARNING}btrfs${RESET} inside the acutal fs [ chroot ]"

# Mount SWAP // if it is created
## TODO - fix this in 'User Intervention version'
### This point shows some [OK] logs from pacman concurrency
read -p "Did you create a SWAP parition? [y/n]: " swapc
if [[ $swapc = y ]] ; then
  echo "Enter Swap partition: "
  read swap
  mkswap $swap
  swapon $swap
  echo -e "${OK} Swapped on $swap"
  sleep 3
fi

# Mount partitions
mount $root /mnt
mkdir -p /mnt/boot
mount $efi /mnt/boot
echo -e "${OK} Mounted ${MAGENTA}ROOT${RESET} and ${MAGENTA}EFI${RESET}"
sleep 3

# Base Install [ESSENTIALS]
printf '\033c'
echo -e "${INFO} Installing ${WARNING}Base${RESET}"
sleep 3
pacstrap -K /mnt base base-devel linux-lts linux-zen linux-firmware networkmanager efibootmgr grub btrfs-progs ntfs-3g wget gvfs foremost dosfstools kitty bluez reflector git grub testdisk expac reflector

echo -e "${OK}${SKY_BLUE} Base Arch Installed${RESET}"
sleep 3

# generating fstab
printf '\033c'
echo -e "${INFO} generating ${WARNING}fstab${RESET} . . ."
sleep 3
genfstab -U /mnt > /mnt/etc/fstab
echo -e "${OK} ${WARNING}fstab${RESET} setup complete."
echo -e "${ERROR} check fstab now${RESET}"
sleep 3
cat /mnt/etc/fstab
sleep 3

echo -e "${INFO} ${WARNING}chrooting${RESET} into the actual system"
sleep 3
sed '1,/^# Root$/d' "$(basename "$0")" > /mnt/shadow_clone_root_section.sh
chmod +x /mnt/shadow_clone_root_section.sh
arch-chroot /mnt ./shadow_clone_root_section.sh
exit

# Root
#!/usr/bin/env bash
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
RED="$(tput setaf 1)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

printf '\033c'
echo -e "\n${INFO} Inside the chroot [ actual root directory ]"

# build initramfs
printf '\033c'
echo -e "\n${INFO} Building ${WARNING}initramfs${RESET} . . ."
sleep 3
mkinitcpio -P
printf '\033c'
echo -e "\n${OK} Done"
sleep 3

# setting up grub
echo -e "\n${INFO} Setting up ${WARNING}GRUB${RESET}"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo -e "\n${OK} GRUB setup complete"
sleep 3

# set password for root
printf '\033c'
echo -e "\n${WARN} Enter root password: "
passwd

# add a user
printf '\033c'
echo -e "\n${INFO} Creating ${WARNING}new user${RESET}"
echo "Enter user: "
read user
useradd -mG wheel,storage,audio,video,power,kvm,input -s /bin/sh $user

# set password for the user
echo "Enter password "
passwd $user

echo "${OK} User created"
echo "${GREEN} Setting up user${RESET}"
sleep 5

# grant sudo
echo -e "${INFO} Building ${WARNING}user environment${RESET}"
echo "%wheel ALL=(ALL:ALL) ALL # added from Warlord's ArchInstall script" >> /etc/sudoers
echo -e "${INFO} Granted wheel on sudoers file"
sleep 3

# setting timezone + system clock
echo -e "\n${INFO} Setting ${WARNING}timezone${RESET} and ${WARNING}system clock${RESET}"
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo -e "\n${OK} Done"
sleep 3

# network manager enabled
systemctl enable NetworkManager
systemctl start NetworkManager
echo -e "\n${INFO} Network Manager enabled"
sleep 3

# setting locale
echo -e "${INFO} Setting ${WARNING}locale${RESET}"
sleep 3
sed -i 's/^# *en_US\.UTF-8 UTF-8/en_US.UTF-8 UTF-8\n# added from Warlord'"'"'s shadow_clone script/' /etc/locale.gen
locale-gen
echo -e "LANG=en_US.UTF-8\n# added from Warlord's shadow_clone script" > /etc/locale.conf
echo -e "\n${OK} Done"
sleep 3

# setting keyboard layout
echo -e "\n${INFO} Setting keyboard layout"
echo "KEYMAP=us" > /etc/vconsole.conf
echo -e "\n${OK} Done"
sleep 2

# 5 to 15 concurrency downloads
echo -e "\n${INFO} Increasing ${WARNING}parallel downloads${RESET} in pacman AND setting up mirrors . . ."
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
reflector --country "india" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
echo -e "\n${OK} DONE"
sleep 3

# setting up Host
printf '\033c'
echo -e "\n${INFO} Setting up Host"
echo -e "Enter Hostname: "
read hostname
echo $hostname > /etc/hostname

echo "127.0.0.1       localhost # added from Warlord's ArchInstall script" >> /etc/hosts
echo "::1             localhost # added from Warlord's ArchInstall script" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname # added from Warlord's ArchInstall script" >> /etc/hosts
echo -e "\n${OK} Done"

# Format storage partition
printf '\033c'
sleep 1
read -p 'Have you created storage paritions?[y/n]:' btrfsch
if [[ btrfsch = y ]]; then
  echo -e "\n${INFO} Setting up ${WARNING}personal storage${RESET}"
  echo -e "Enter the ${YELLOW}storage${RESET} parition: "
  read storage
  mkfs.btrfs -f $storage
  echo -e "\n${OK} $storage format as ${WARNING}btrfs${RESET} fs complete."
  sleep 3

  # setting up BTRFS
  echo -e "\n${INFO} Creating ${WARNING}mount point${RESET} and ${ORANGE}subvolumes${RESET}"
  mkdir -p /mnt/KSS
  mount -t btrfs $storage /mnt/KSS
  btrfs subv create /mnt/KSS/Media
  btrfs subv create /mnt/KSS/Documents
  btrfs subv create /mnt/KSS/Learnings
  btrfs subv create /mnt/KSS/backUps
  mkdir -p /mnt/KSS/.btrfssnapshots/
  mount $storage /mnt/KSS/Media
  mount $storage /mnt/KSS/Documents
  mount $storage /mnt/KSS/backUps
  mount $storage /mnt/KSS/Learnings
  echo -e "\n${OK} Mounted"
  lsblk
else
  echo -e 'Skipping creation of storage Patitions !!'
fi
sleep 5

# setup scripts
printf '\033c'
sleep 1
echo -e "${INFO} Downloading ${WARNING}scripts${RESET} . . ."
sleep 3
myGithub=https://github.com/ksurajsingh/
homeDir=/home/$user/
cd ${homeDir}
git clone "${myGithub}scripts"
cp -r ${homeDir}scripts/* /bin/
cp -r /bin/cpu/* /bin/ 2>/dev/null
rm -rf /bin/cpu
cp ${homeDir}scripts/cpu/* /bin/ 2>/dev/null
echo -e "${OK} ${WARNING}Scripts${RESET} updated."
chown $user:$user ${homeDir}scripts 2>/dev/null || true
sleep 3

# X11
printf '\033c'
echo -e "${INFO} Setting up ${WARNING}X11${RESET} . . ."
sleep 3
sudo pacman -Syu --noconfirm xorg xorg-server xorg-xinit xorg-xsetroot xclip xcompmgr xdotool xwallpaper xorg-xrandr picom xsel dunst numlockx
printf '\033c'
echo -e "${OK} ${WARNING}X11${RESET} setup complete"
sleep 1

# download DWMs
printf '\033c'
echo -e "${INFO} Downloading ${WARNING}DWM${RESET} . . ."
sleep 3
dwm_dir=/home/$user/dwm
mkdir -p $dwm_dir
cd $dwm_dir
dwm_packages=(dwm st dwmblocks dmenu)
myGithub=https://github.com/ksurajsingh/

for repo in "${dwm_packages[@]}"; do
  git clone "$myGithub$repo"
done

echo -e "${OK} ${WARNING}DWM${RESET} successfully downloaded"
sleep 3

# installing DWM
printf '\033c'
echo -e "${INFO} Installing ${WARNING}DWM${RESET}"
sleep 3
cd $dwm_dir
cd dwm && make clean install &&
cd ../st && make clean install &&
cd ../dmenu && make clean install &&
cd ../dwmblocks && make clean install
echo -e "${OK} ${WARNING}DWM${RESET} installation done"
sleep 3

# Base setup complete - setting up final script for user
printf '\033c'
echo -e "${OK} ${WARNING}Base user ${RESET} setup done."
sleep 3

# setup myDots
printf '\033c'
echo -e "${INFO} Downloading ${WARNING}Dots${RESET}"
sleep 3
cd /home/$user
git clone "${myGithub}dot-files"
mkdir /home/$user/.config
cd /home/$user/.config/
cp -r hypr hypr.personal.bak 2>/dev/null
cd /home/$user/dot-files/
cp -r . "/home/$user/.config/"
echo -e "Is this for Desktop? [y/n]: "
read deskch

mkdir -p "/home/$user/.local/state/syncthing/"
if [[ "$deskch" = "y" ]]; then
  cp -r syncthing/pc/* "/home/$user/.local/state/syncthing/." 2>/dev/null
  echo -e "${OK} ${WARNING}PC${RESET} config updated"
  sleep 3
else
  cp -r syncthing/laptop/* "/home/$user/.local/state/syncthing/." 2>/dev/null
  echo -e "${OK} ${WARNING}Laptop${RESET} config updated"
  sleep 3
fi
echo -e "${OK} Syncthing Setup Complete."
cp .zshrc .vimrc .xinitrc "/home/$user/"
echo -e "${OK} zshrc vimrc restored."
sleep 3
echo -e "${OK} dots updated"
chown $user:$user -R /home/$user
sleep 3
cd /home/$user/.config/
rm -rf nvim
git clone "${myGithub}nvim"

Extras=/home/$user/extras.sh
echo -e "${OK} Reboot your machine and run $Extras as $user without sudo privleges to finish setup !"
sed '1,/^# Extras$/d' /shadow_clone_root_section.sh > $Extras
chmod +x $Extras
chown $user:$user $Extras

# Cleanup
read -p 'Do you want to clean up this script now?[y/n]: ' cleanup
if [[ $cleanup = y ]] ; then
  echo -e 'The Extras script would still be present at /home/$user'
  rm /shadow_clone_root_section.sh 
  echo -e 'Cleaned UP !'
else
  echo -e 'Not cleaning up'
fi
exit

# Extras
#!/usr/bin/env bash
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
RED="$(tput setaf 1)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

printf '\033c'
echo -e "${INFO} ${WARNING}Extras${RESET} for the ${ORANGE}user${RESET} ${MAGENTA}[FINISHING TOUCH]${RESET}"
myGithub=https://github.com/ksurajsingh/

extras() {

  # setting up AUR
  cd $HOME
  printf '\033c'
  echo -e "${INFO} setting ${WARNING}YAY${RESET} ${MAGENTA}aur${RESET}"
  sleep 3
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -fsri
  echo -e "${OK} ${WARNING}YAY${RESET} ${MAGENTA}aur${RESET} setup complete."
  sleep 3

  # setting up Hyprland
  printf '\033c'
  cd $HOME
  echo -e "${INFO} Installing ${WARNING}Hyprland${RESET} in 10 seconds \n 
           Please fill prompts \n 
           ${RED}DO NOT REBOOT${RESET} even on prompt"
  sleep 7
  printf '\033c'
  echo -e "${INFO} Cloning ${WARNING}Jakoolit${RESET}'s Arch-Hyprland . . ."
  sleep 3
  git clone https://github.com/Jakoolit/arch-hyprland
  cd arch-hyprland
  echo -e "${OK} Cloned."
  sleep 3
  for ((i=0;i<10;i++)); do
    echo "${RED}ENTER PROMPT${RESET}"
  done
  sleep 1
  echo -e "${INFO} Installing now. . ."
  sleep 3
  ./install.sh
  echo -e "${OK} ${WARNING}Hyprland${RESET} Installation Complete."
  sleep 5

  # Setting up Hyprland dots
  cd $HOME/.config/hypr/UserScripts/
  sed -i "s/INTERVAL=.*/INTERVAL=7200/" WallpaperAutoChange.sh
  sed -i "s/wallDIR=.*/wallDIR=\/mnt\/KSS\/Media\/wallpapers\//" WallpaperRandom.sh WallpaperSelect.sh ../UserConfigs/Startup_Apps.conf
  echo -e "${OK} ${WARNING}Wall dir${RESET} + ${WARNING}Interval${RESET} updated."
  sleep 3

  cd $HOME/.config/hypr/scripts/
  sed -i "s/^dir=.*/dir=\/mnt\/KSS\/backUps\/poco\/dcim\/screenshots\//" ScreenShot.sh
  echo -e "${OK} ${WARNING}Screenshot dir${RESET} updated."
  sleep 3

  cd $HOME/.config/hypr/UserScripts/
  sed -i "s/^city=.*/city=bengaluru/" Weather.sh
  echo -e "${OK} ${WARNING}City${RESET} added to ${MAGENTA}Weather.sh"
  sleep 3

  # Dev Tools
  printf '\033c'
  echo -e "${INFO} Setting up ${WARNING}Dev Tools${RESET} . . ."
  sleep 3
  sudo pacman -S --noconfirm rsync syncthing tailscale scrcpy scrot aria2 zip gzip tar tmux tree neovim vim git-lfs arch-install-scripts gcc npm imagemagick inxi jq mosh openbsd-netcat qemu-full zram-generator zsh ripgrep unzip 7zip pandoc-cli pyenv vde2 virt-manager virt-viewer tigervnc umockdev w3m sed feh ffmpeg mariadb postgresql
  printf '\033c'
  echo -e "${OK} ${WARNING}Dev Tools${RESET} setup complete"
  sleep 1

  # Security Tools
  printf '\033c'
  echo -e "${INFO} Setting up ${WARNING}Security tools${RESET} . . ."
  sleep 3
  sudo pacman -S --noconfirm nginx nmap nmon tlp ufw whois wipe metasploit
  printf '\033c'
  echo -e "${OK} ${WARNING}Security Tools${RESET} setup complete."
  sleep 1

  # Libraries
  printf '\033c'
  echo -e "${INFO} Setting up ${WARNING}Libraries${RESET} . . ."
  sleep 3
  sudo pacman -S --noconfirm calcurse openssh libxft libxinerama openssl python-pipx
  pipx install pyprland
  printf '\033c'
  echo -e "${OK} ${WARNING}Libraries${RESET} setup complete."
  sleep 1

  # Sys Monitor
  printf '\033c'
  echo -e "${INFO} Setting up ${WARNING}System Monitoring${RESET} . . ."
  sleep 3
  sudo pacman -S --noconfirm at duf dust cpupower hwinfo nvtop htop btop atop powertop smartmontools radeontop
  printf '\033c'
  echo -e "${OK} ${WARNING}System Monitoring${RESET} setup Complete."
  sleep 1

  # Applications
  printf '\033c'
  echo -e "${INFO} Setting up ${WARNING}Applications${RESET} . . ."
  sleep 3
  sudo pacman -S --noconfirm ranger slurp viu bc fzf gnome-calculator gnome-disk-utility mpv blueman nautilus thunar nemo eog cheese gimp asciiquarium sxiv zathura qutebrowser firefox kdenlive obs-studio telegram-desktop discord
  printf '\033c'
  echo -e "${OK} ${WARNING}Applications${RESET} setup complete."
  sleep 1

  # Miscellaneous
  printf '\033c'
  echo -e "${INFO} Setting up ${WARNING}Miscellaneous${RESET} . . ."
  sleep 3
  sudo pacman -S --noconfirm sl cava fastfetch cowsay figlet lolcat uwufetch pamixer pavucontrol
  printf '\033c'
  echo -e "${OK} ${WARNING}Miscellaneous${RESET} setup complete."
  sleep 1

  # Fonts
  printf '\033c'
  echo -e "${INFO} Setting up ${WARNING}Fonts${RESET} . . ."
  sleep 3
  sudo pacman -S --noconfirm ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-fira-code noto-fonts noto-fonts-emoji ttf-droid ttf-font-awesome
  printf '\033c'
  echo -e "${OK} ${WARNING}Fonts${RESET} setup complete."
  sleep 1

  # Downloading AUR packages
  printf '\033c'
  echo -e "${INFO} Downloading ${MAGENTA}aur${RESET} ${WARNING}packages${RESET}"
  sleep 3
  sleep 1
  yay -S --noconfirm tty-clock wtf cbonsai neofetch pfetch secure-delete hollywood ani-cli magnus auto-cpufreq speedometer barrier vimv steghide materia-gtk-theme pywal transmission-gtk transmission-qt google-chrome onlyoffice-bin upscayl-bin android-studio python-pywal wallset
  echo -e "${OK} ${MAGENTA}aur${RESET} ${WARNING}packages${RESET} BUILT."
  sleep 3

  # setting up tailscale and syncthing
  printf '\033c'
  echo -e "${INFO} Setting up ${WARNING}Tailscale${RESET}. . ."
  sleep 3
  sudo systemctl enable tailscaled
  sudo systemctl start tailscaled
  sudo tailscale up
  sleep 1
  sudo tailscale up --ssh
  echo -e "${OK} Tailscale Setup Complete."
  sleep 3
  echo -e "${INFO} Setting up ${WARNING}Syncthing${RESET}. . ."
  sleep 3
  systemctl --user enable --now syncthing
  echo -e "${OK} ${WARNING}Syncthing${RESET} started ${GREEN}[ will copy config.xml from dots ]${RESET}"
  sleep 3

  # libvirt
  sudo usermod -aG libvirt $USER
  sudo systemctl enable --now libvirtd
  echo -e "${OK} added $USER to libvirt"
  sleep 10


  # Clean up
  echo -e "${NOTE} clean scripts? [y/n]: "
  read cleanch
  if [[ "$cleanch" = "y" ]];then
    rm $HOME/extras.sh 2>/dev/null
    echo -e "Deleted and extras.sh"
    sleep 3
  else
    echo -e "Not cleaning up"
    sleep 5
  fi
}

# Prompt to run Extras
printf '\033c'
echo -e "${INFO} Run ${WARNING}Extras${RESET} (X11, Dev/Security/Libs/Monitor/Apps/Misc/Fonts + DWM + AUR + Hyprland + dotfiles + nvim)?"
echo -ne "[y/N]: "
read -r ex
if [[ "$ex" =~ ^[Yy]$ ]]; then
  extras
fi

# BYE !
printf '\033c'
echo -ne "${RED} DO NOT FORGET TO SETUP THE SSH AND GPG\nConnect your HARD_DISK and copy all the data${RESET}"
sleep 7
echo -e "\n${SKY_BLUE} ARCH INSTALL SUCCESSFULL ${RESET}"
sleep 3
echo -ne "${RED}Welcome to Warlord's Arch Install${RESET}"
sleep 5
printf '\033c'

read -p 'Do you want to reboot now?[y/n]: ' rebootch
if [[ $rebootch = y ]]; then
  reboot
fi
