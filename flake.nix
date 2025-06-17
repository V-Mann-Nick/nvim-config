{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          lua-language-server
          stylua
          unzip
          (pkgs.writeShellApplication {
            name = "nvim-new";
            runtimeInputs = with pkgs; [neovim];
            text = ''
              export NVIM_APPNAME="nvim-new"
              exec nvim "$@"
            '';
          })
        ];
      };
    });
  };
}
