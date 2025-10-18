{
  users = {
    alice = {
      isNormalUser = true;
      name = "alice";
      extraGroups = ["wheel" "networkmanagers"];
      home = "/home/alice";
    };
    example = {
      isNormalUser = true;
      name = "example";
      home = "/home/example";
    };
  };
  homes = {
    example = (builtins.getFlake (builtins.toString ./user-homes/example-home)).homeConfigurations.default;
  };
}