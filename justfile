default: nix home

nix:
	nixos-rebuild switch --flake . 
nix-debug:
	nixos-rebuild switch --flake . --show-trace --option eval-cache false
home:
	home-manager switch --flake . 
home-debug:
	home-manager switch --flake . --show-trace --option eval-cache false
clean:
	nix-collect-garbage -d
