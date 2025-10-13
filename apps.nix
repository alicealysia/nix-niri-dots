{pkgs, ...}: {
  #if you need to add apps at the system level, do so here
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    nautilus
    hyprpicker
    wl-clipboard
    wayland-utils
    libsecret
    cage
    gamescope
    xwayland-satellite-unstable
    lunarvim
    wget
    nixd
    git
    nodejs
    spice-vdagent
    nerd-fonts.noto
    nerd-fonts.lilex
    nerd-fonts.ubuntu
    firefox
    fishPlugins.tide
    wezterm
    vscodium
    home-manager
    quickshell
  ];
}
