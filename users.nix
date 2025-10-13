{...}:{
  users.users.alice = {
    isNormalUser = true;
    name = "alice";
    extraGroups = ["wheel" "networkmanagers"];
    home = "/home/alice";
  };
}
