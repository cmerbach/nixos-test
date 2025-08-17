{ config, pkgs, lib, ... }:
{

  options = {
    vscode.enable = lib.mkEnableOption "enable vacode";
  };

  config = lib.mkIf config.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        foam.foam-vscode
        github.vscode-pull-request-github
        gruntfuggly.todo-tree
        james-yu.latex-workshop
        johnpapa.vscode-peacock
        mhutchie.git-graph
        ms-azuretools.vscode-docker
        ms-kubernetes-tools.vscode-kubernetes-tools
        ms-python.python
        ms-vscode-remote.remote-containers
        ms-toolsai.jupyter
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        # {
        #   name = "arduino-maker-workshop";
        #   publisher = "TheLastOutpostWorkshop";
        #   version = "0.7.0";
        #   sha256 = "YTc4arwnv/vLRAkYJDI9L8j1oRbfLpTGe482n4oCVIY=";
        # }
        {
          name = "openscad";
          publisher = "Antyos";
          version = "1.3.2";
          sha256 = "1hEUBJW4QNq0ECO9Mwk4OCDxu4VQ+ZvMrj2rRna51Gc=";
        }
        {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.3.1";
          sha256 = "05oMDHvFM/dTXB6T3rcDK3EiNG2T0tBN9Au9b+Bk7rI=";
        }
        {
          name = "excalidraw-editor";
          publisher = "pomdtr";
          version = "3.7.4";
          sha256 = "hI+Qo8K+gLQuzKkaSq89D8vIxlYq9tMi31DgFiRzx0E=";
        }
        {
          name = "terraform";
          publisher = "HashiCorp";
          version = "2.30.2024042211";
          sha256 = "79ZrLf8Jzpxn6RUz+mPqf9R/V4RQmInJtQtjNX7j/nM=";
        }
        # {
        #   name = "vscode-pets";
        #   publisher = "tonybaloney";
        #   version = "1.25.1";
        #   sha256 = "as3e2LzKBSsiGs/UGIZ06XqbLh37irDUaCzslqITEJQ=";
        # }
        {
          name = "dashyeah";
          publisher = "bobmagicii";
          version = "1.0.3";
          sha256 = "qHdXwnTMoMgDZ+rEYtdn7uv1qCFixS+SRE6q3+6fEcQ=";
        }
        {
          name = "workspace-layout";
          publisher = "lostintangent";
          version = "0.0.7";
          sha256 = "G6EllTEhlS2HYg0dd7letFExVXhzuWZrSn1QdbxMAAU=";
        }
      ];
      # userSettings = {
      #   # ---( Settings )---
      #   "terminal.external.linuxExec" = "foot";
      #   "editor.rulers" = [33];
      #   "editor.tabSize" = 4;
      #   "terminal.integrated.scrollback" = 100000;
      #   "editor.detectIndentation" = true;
      #   "editor.insertSpaces" = true;
      #   "security.workspace.trust.untrustedFiles" = "open";
      #   "terminal.integrated.enableMultiLinePasteWarning" = false;
      #   # // "cSpell.language" = "en,de,de-DE";
      #   "editor.wordWrap" = "off";
      #   "editor.showFoldingControls" = "always";
      #   "editor.foldingStrategy" = "indentation";
      #   "window.titleBarStyle" = "custom";
      #   "workbench.colorTheme" = "Visual Studio Dark";
      #   "workbench.startupEditor" = "none";
      #   "workbench.colorCustomizations" = {
      #     "statusBar.noFolderBackground" = "#007acd";
      #   };
      #   # ---( Dashboard )---
      #   "dashyeah.title" = "Projects";
      #   "dashyeah.debug" = false;
      #   "dashyeah.folderSizing" = "col-12";
      #   "dashyeah.columnSizing" = "col-12 col-md-6";
      #   "dashyeah.showPaths" = true;
      #   "dashyeah.fontSize" = "font-size-normal";
      #   "dashyeah.rounded" = true;
      #   "dashyeah.openOnNewWindow" = false;
      #   "dashyeah.openInNewWindow" = false;
      #   "dashyeah.database" = [
      #     {
      #       "id" = "d54905d6-dcec-46b0-86f9-f7f3a2131d98";
      #       "name" = "nixos";
      #       "path" = "file:///home/user/nixos";
      #       "icon" = "codicon-terminal-bash";
      #       "accent" = "#006400";
      #     }
      #     {
      #       "id" = "01f1e516-0ed8-4855-ae42-ffa8c22ff70c";
      #       "name" = "Privat";
      #       "icon" = "codicon-folder";
      #       "accent" = "#00ffff";
      #       "open" = true;
      #       "projects" = [
      #         {
      #           "id" = "53ecbef8-7920-46d6-ab15-705f4930667b";
      #           "name" = "life";
      #           "path" = "file:///home/user/life";
      #           "icon" = "codicon-folder";
      #           "accent" = "#00ffff";
      #         }
      #         {
      #           "id" = "86bea5d4-0287-4490-a0fa-4d0ac2f1f2e3";
      #           "name" = "raspi";
      #           "path" = "file:///home/user/repos/raspi";
      #           "icon" = "codicon-folder";
      #           "accent" = "#A2C200";
      #         }
      #       ];
      #     }
      #     {
      #       "id" = "19f97d8e-214b-4a28-89ca-3d4c7dbc5e70";
      #       "name" = "ExB";
      #       "icon" = "codicon-folder";
      #       "accent" = "#8a2be2";
      #       "open" = true;
      #       "projects" = [
      #         {
      #           "id" = "8c60aef1-e040-4545-bb94-242ebe7e3fc4";
      #           "name" = "automation-pipeline";
      #           "path" = "file:///home/user/repos/automation-pipeline";
      #           "icon" = "codicon-folder";
      #           "accent" = "#0000ff";
      #         }
      #         {
      #           "id" = "ce2357d4-6686-4b75-86ff-8e8b43f4d4a0";
      #           "name" = "cwbng";
      #           "path" = "file:///home/user/repos/cwbng";
      #           "icon" = "codicon-folder";
      #           "accent" = "#9932cc";
      #         }
      #         {
      #           "id" = "d9fc620e-429d-4a1e-a93f-4e24a0f0aaab";
      #           "name" = "terraform-infrastructure";
      #           "path" = "file:///home/user/repos/terraform-infrastructure";
      #           "icon" = "codicon-folder";
      #           "accent" = "#a9a9a9";
      #         }
      #         {
      #           "id" = "2e1b51c5-86ec-41cc-8557-5f79daa9cc8b";
      #           "name" = "exb_gpu_worker";
      #           "path" = "file:///home/user/repos/exb_gpu_worker";
      #           "icon" = "codicon-folder";
      #           "accent" = "#37ff6b";
      #         }
      #         {
      #           "id" = "88cd8978-13f1-4f37-bb9c-8dcedd6713c9";
      #           "name" = "linuxmint-unattended";
      #           "path" = "file:///home/user/repos/linuxmint-unattended";
      #           "icon" = "codicon-folder";
      #           "accent" = "#228b22";
      #         }
      #       ];
      #     }
      #   ];
      #   # ---( LaTeX )---
      #   # // "latex-workshop.docker.image.latex": "software_texlive",
      #   # // "latex-workshop.docker.enabled": true,
      #   "latex-workshop.view.pdf.viewer" = "tab";
      #   "latex-workshop.latex.outDir" = "./tmp";
      #   "latex-workshop.latex.autoBuild.run" ="never";
      #   "latex-workshop.message.warning.show" = false;
      #   "latex-workshop.latex.tools" = [
      #     {
      #       "name" = "latexmk";
      #       "command" = "latexmk";
      #       "args" = [
      #         "-synctex=1"
      #         "-interaction=nonstopmode"
      #         "-shell-escape"
      #         "-file-line-error"
      #         "-pdflatex"
      #         "-aux-directory=./tmp"
      #         "-output-directory=./tmp"
      #         "%DOC%"
      #       ];
      #     }
      #     {
      #       "name" = "pdflatex";
      #       "command" = "pdflatex";
      #       "args" = [
      #         "-synctex=1"
      #         "-interaction=nonstopmode"
      #         "-shell-escape"
      #         "-file-line-error"
      #         "-aux-directory=./tmp"
      #         "-output-directory=./tmp"
      #         "%DOC%"
      #       ];
      #     }
      #     {
      #       "name" = "bibtex";
      #       "command" ="bibtex";
      #       "args" = [
      #         "%DOCFILE%"
      #       ];
      #     }
      #   ];
      #   # // "latex-workshop.latex.autoClean.run" = "onBuilt",
      #   # // "latex-workshop.latex.clean.fileTypes" = [
      #   # //   "*.post"
      #   # //   "*.acn"
      #   # //   "*.acr"
      #   # //   "*.alg"
      #   # //   "*.auto"
      #   # //   "*.aux"
      #   # //   "*.auxlock"
      #   # //   "*.bbl"
      #   # //   "*.bcf"
      #   # //   "*.blg"
      #   # //   "*.brf"
      #   # //   "*.dat"
      #   # //   "*.dep"
      #   # //   "*.div"
      #   # //   "*.dpth"
      #   # //   "*.fdb_latexmk"
      #   # //   "*.fls"
      #   # //   "*.glg"
      #   # //   "*.glo"
      #   # //   "*.gls"
      #   # //   "*gnuplottex-fig*"
      #   # //   "*.gnuploterrors"
      #   # //   "*.gz"
      #   # //   "*.idx"
      #   # //   "*.ind"
      #   # //   "*figure*.pdf"
      #   # //   "*.ist"
      #   # //   "*.lof"
      #   # //   "*.log"
      #   # //   "*.lor"
      #   # //   "*.lot"
      #   # //   "*.md5"
      #   # //   "*.nav"
      #   # //   "*.out"
      #   # //   "*.snm"
      #   # //   "*.toc"
      #   # //   "*.vrb"
      #   # //   "*.xml"
      #   # // ];
      #   # ---( Other )---
      #   "quicknotes.config.notesLocation" = "/home/user/.quick-notes";
      #   "todo-tree.highlights.defaultHighlight" = {
      #     "foreground" = "#1bb107aa";   
      #   };
      #   "todo-tree.general.tags" = [
      #     "BUG"
      #     "PROGRESS"
      #     "FIXME"
      #     "TODO"
      #   ];
      #   "todo-tree.highlights.customHighlight" = {
      #     "BUG" = {
      #       "icon" = "bug";
      #     };
      #     "PROGRESS" = {
      #       "icon" = "tools";
      #     };
      #     "FIXME" = {
      #       "icon" = "flame";
      #     };
      #       #  "icon" = "x"
      #       #  "icon" = "issue-draft"
      #       #  "icon": "issue-closed"
      #   };
      #   "excalidraw.theme" = "dark";
      #   # "scm.experimental.showHistoryGraph" = true;
      #   "remote.autoForwardPortsSource" = "hybrid";
      #   # ---( File Templates )---
      #   # https://containers.dev/implementors/json_reference/
      # };
      # keybindings = [
      #   # ctrl + ...
      #   {
      #     "key" = "ctrl+alt+a";
      #     "command" = "latex-workshop.build";
      #     "when" = "editorTextFocus && !latex-workshop:altkeymap";
      #   }
      #   {
      #     "key" = "ctrl+c";
      #     "command" = "workbench.action.terminal.copySelection";
      #     "when" = "terminalFocus && terminalTextSelected";
      #   }
      #   {
      #     "key" = "ctrl+alt+s";
      #     "command" = "latex-workshop.tab";
      #   }
      #   {
      #     "key" = "ctrl+v";
      #     "command" = "workbench.action.terminal.paste";
      #     "when" = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
      #   }
      #   # ctrl + alt
      #   {
      #     "key" = "ctrl+alt+down";
      #     "command" = "editor.unfoldAll";
      #     "when" = "editorTextFocus";
      #   }
      #   {
      #     "key" = "ctrl+alt+up";
      #     "command" = "editor.foldAll";
      #     "when" = "editorTextFocus";
      #   }
      #   {
      #     "key" = "ctrl+alt+e";
      #     "command" = "workbench.action.terminal.toggleTerminal";
      #   }
      #   {
      #     "key" = "ctrl+alt+f";
      #     "command" = "workbench.action.files.openFolder";
      #   }
      #   {
      #     "key" = "ctrl+alt+k";
      #     "command" = "editor.action.commentLine";
      #     "when" = "editorTextFocus && !editorReadonly";
      #   }
      #   {
      #     "key" = "ctrl+alt+q";
      #     "command" = "workbench.action.toggleEditorWidths";
      #   }
      #   {
      #     "key" ="ctrl+alt+w";
      #     "command" = "workbench.action.toggleMaximizedPanel";
      #   }
      #   {
      #     "key" = "ctrl+alt+z";
      #     "command" = "workbench.action.toggleZenMode";
      #   }
      #   # ctrl + shift + alt
      #   {
      #     "key" = "ctrl+shift+alt+q";
      #     "command" = "workbench.action.terminal.kill";
      #   }
      #   # remove
      #   {
      #     "key" = "ctrl+shift+c";
      #     "command" = "-workbench.action.terminal.copySelection";
      #     "when" = "terminalFocus && terminalHasBeenCreated && terminalTextSelected || terminalFocus && terminalProcessSupported && terminalTextSelected";
      #   }
      #   {
      #     "key" = "ctrl+shift+c";
      #     "command" = "-workbench.action.terminal.openNativeConsole";
      #     "when" = "!terminalFocus";
      #   }
      #   {
      #     "key" = "ctrl+v";
      #     "command" = "-markdown.extension.editing.paste";
      #     "when" = "editorHasSelection && editorTextFocus && editorLangId =~ /^markdown$|^rmd$|^quarto$/";
      #   }
      #   {
      #     "key" = "ctrl+shift+v";
      #     "command" = "-workbench.action.terminal.paste";
      #     "when" = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
      #   }
      #   {
      #     "key" = "ctrl+shift+b";
      #     "command" = "simpleBrowser.show";
      #     "args" = "http://localhost:8080";
      #     # "args" = {
      #     #   "url" = "http://localhost:8080";
      #     # };
      #   }
      # ];
    };
  };
}
