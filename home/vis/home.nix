{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "vis";
  home.homeDirectory = "/home/vis";

  # Packages that should be installed to the user profile.

  home.packages = with pkgs;
    [
      alejandra
      brave
      cmake
      qimgv
      gammastep
      gdb
      jujutsu
      librewolf
      lldb
      lua-language-server
      nautilus
      nil
      proton-vpn
      tree-sitter
      vesktop
      wireguard-tools
      yazi
      zellij
    ]
    ++ [
      inputs.pwndbg.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  home.sessionVariables = {
    TERMINAL = "kitty";
  };

  #Enabling zsh and ohmyzsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "fzf"];
      theme = "simple";
    };
    shellAliases = {
      niu = "sudo nixos-rebuild switch --flake ~/NixOS#vis";
      hoe = "home-manager switch --flake ~/NixOS#vis";
    };
  };

  #Enable niri with dms
  imports = [
    inputs.niri.homeModules.config
    inputs.dms.homeModules.niri
    inputs.dms.homeModules.dank-material-shell
  ];

  programs.niri.config = null;
  programs.dank-material-shell.enable = true;
  programs.dank-material-shell.quickshell.package = pkgs.quickshell;
  programs.dank-material-shell.niri.includes.enable = false;

  #Enabling bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = {
      add_newline = false;

      # TWO LINES
      format = ''
        $directory$git_branch$git_status$nix_shell$cmd_duration
        $character
      '';

      # DIRECTORY
      directory = {
        style = "purple";
        truncation_length = 0;
        truncate_to_repo = false;
        truncation_symbol = "  ";
      };

      # Time
      cmd_duration = {
        min_time = 2000;
      };

      # GIT STATUS
      git_status = {
        style = "bold red";
        format = "\\[$all_status$ahead_behind\\]($style)  ";

        staged = "S:$count ";
        modified = "M:$count ";
        untracked = "U:$count ";
        deleted = "D:$count ";
        renamed = "R:$count ";
        conflicted = "C:$count ";
        stashed = "T:$count ";
      };

      # PROMPT CHARACTER
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      # Additional symbols
      git_branch.symbol = "";
      # nix_shell.symbol  = " ";
      nix_shell = {
        format = "[$symbol]($style) ";
      };

      cmd_duration.disabled = false;
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = false;
  };

  services.ssh-agent.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
