default: show update nix home
show:
        git diff -U0 2>&1
update:
        nix flake update
nix:
	sudo nixos-rebuild switch --flake . 
nix-debug:
	sudo nixos-rebuild switch --flake . --show-trace --option eval-cache false
home:
	home-manager switch --flake . 
home-debug:
	home-manager switch --flake . --show-trace --option eval-cache false
clean:
	sudo nix-collect-garbage -d
	nix-collect-garbage -d
