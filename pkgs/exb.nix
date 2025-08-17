{ config, pkgs, lib, unstable, ... }:
{

  options = {
    work.enable = lib.mkEnableOption "enable exb/work module";
  };

  config = lib.mkIf config.work.enable {
    home.packages = with pkgs; [
      asdf # manage all your runtime versions with one tool
      apache-directory-studio # LDAP browser and directory client
      awscli2 # unified tool to manage your aws services
      bazel_7 # build tool that builds code quickly and reliably
      bazelisk # user-friendly launcher for bazel
      cdrkit # portable command-line cd/dvd recorder software, mostly compatible with cdrtools
      ctop # top-like interface for container metrics
      direnv # shell extension that manages your environment
      docker # build, share, and run container applications
      envsubst # environment variables substitution for go
      fzf # cli fuzzy finder written in Go
      gcc # gnu compiler collection and system c compiler
      gnumake # control the generation of non-source files from sources
      grafana # open source analytics & monitoring solution for every database
      helmfile # declarative spec for deploying Helm charts
      yamllint # linter for yaml files
      jq # lightweight and flexible cli json processor
      kubernetes-helm # package manager for kubernetes
      k9s # terminal UI to interact with your Kubernetes clusters
      kubectl # command line tool for communicating with a kubernetes cluster
      kubectx # tool to switch between contexts (clusters) on kubectl faster
      kustomize # customization of kubernetes YAML configurations
      lazygit # simple terminal ui for git commands
      minikube # local kubernetes cluster
      pick # fuzzy text selection utility
      poetry # python dependency and packaging management
      postgresql_17 # powerful, open source object-relational database system
      pre-commit # framework for managing and maintaining multi-language pre-commit hooks
        rustc # safe, concurrent, practical language
        ruff # extremely fast Python linter
        libgcc # GNU compiler collection
        tflint # terraform linter
      ripgrep # utility that combines the usability of the silver searcher with the raw speed of grep
      # rustdesk # remote access and remote control software
      skaffold
      syslinux # a lightweight bootloader
      terraform #  infrastructure as code tool
      texliveFull # latex
      vagrant # create and configure lightweight, reproducible, and portable development environments
    ] ++ (with unstable; [
      #
    ]);
  };
 
}
