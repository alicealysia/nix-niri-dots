{ pkgs, ... }:
let
  env = import ./.env.nix;
in
{
  programs.git = {
    userName = env.USERNAME;
    userEmail = env.EMAIL;
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
    };
  };
}