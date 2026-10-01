{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    nixfmt
    discord
    thunderbird
    gimp
    obsidian
    godot
    keymapp
    parsec-bin
    vlc
    bat
    snapshot
    qbittorrent
    zed-editor
    (inputs.nix-jetbrains-plugins.lib.buildIdeWithPlugins pkgs jetbrains.idea [
      "IdeaVIM"
      "al.aoli.intellijdirenv"
    ])
    file
    aseprite
    glow
    prismlauncher
  ];

  cady = {
    firefox.enable = true;
    console = {
      defaults = true;
      starship = {
        enable = true;
        direnv = true;
      };
      useNvf = true;
    };
    home = {
      defaults = true;
      userDirsOverride = true;
    };
  };
  services.easyeffects.enable = true;

  programs.vscodium.enable = true;
  xdg.configFile."VSCodium/User/settings.json".source = lib.mkForce (
    inputs.self + /config/codium/settings.json
  );
  xdg.configFile."baloofilerc".text = ''
    [General]
    dbVersion=2
    exclude filters=*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found
    exclude filters version=9
    exclude folders[$e]=$HOME/evals/,$HOME/evals2/
  '';

  home = {
    username = "maia";
    homeDirectory = "/home/maia";
    stateVersion = "25.05";
  };
}
