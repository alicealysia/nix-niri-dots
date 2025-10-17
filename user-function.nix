user-list : {

  users = builtins.listToAttrs (builtins.map (username : {
    name = "${username}";
    value = {
      isNormalUser = true;
      name = "${username}";
      extraGroups = ["wheel" "networkmanagers"];
      home = "/home/${username}";
    };
  }) user-list);

  homes = builtins.listToAttrs (builtins.map (
    username : {
      name = "${username}";
      value = (builtins.getFlake "./users/${username}").${username}.homeConfigurations.default;
    }
  ) user-list);

  startup-scripts = builtins.concatMap (username : ''
    if [ ! -f ./users/${username}/flake.nix ]; then
      cp -r ./example-user ./users/${username}
    fi
    '') user-list;

  activation-scripts = builtins.concatMap (username : ''
    chown -r ${username}:${username} ./users/${username}
    '') user-list;
}
