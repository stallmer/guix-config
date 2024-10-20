;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
	     (gnu home services)
	     (gnu home services sound)
             (gnu home services shells)
	     (gnu home services desktop)
	     (gnu home services syncthing)
	     (gnu home services ssh))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
 (packages (specifications->packages (list "sway"
					   "swaybg"
					   "swayidle"
					   "swaylock"
					   "kitty"
					   "waybar"
					   "xdg-utils"
					   "xdg-desktop-portal-gtk"
					   "xdg-desktop-portal-wlr"
					   "wl-clipboard"
					   "fuzzel"

					   ;; CLI Tools
					   "fish"
                                           "neovim"
                                           "tealdeer"
					   "jq"
					   "pipewire"
					   "wireplumber"
					   "brightnessctl"
					   "stow"
					   
					   ;; GUI Tools
					   "firefox"
					   "syncthing"
					   "mpv"
					   "yt-dlp"
					   "flatpak"
					   "fzf"

					   ;; Fonts and symbols
					   "font-google-noto-emoji"
					   "font-google-noto"
					   "font-jetbrains-mono"
					   "hicolor-icon-theme"
					   )))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list 
     (service home-pipewire-service-type)
     (service home-dbus-service-type)
     (service home-syncthing-service-type)
     (service home-bash-service-type
	      (home-bash-configuration
		;; Add custom shell scripts to PATH
	       (environment-variables '(("PATH" . "$HOME/.local/bin:$PATH")))
	       (aliases '())
	       (bashrc (list (local-file "/home/stephen/.bashrc" "bashrc")))
	       (bash-profile (list (local-file
				    "/home/stephen/.bash_profile"
                                    "bash_profile")))))
     (service home-openssh-service-type
	      (home-openssh-configuration
	       (hosts
		(list (openssh-host (name "stallmer")
				    (host-name "104.200.24.74")
				    (user "stephen")
				    (port 2204))
		      (openssh-host (name "frigate")
				    (host-name "192.168.50.181")
				    (user "root"))
		      (openssh-host (name "plex")
				    (host-name "192.168.50.52")
				    (user "root"))
		      (openssh-host (name "gitea")
				    (host-name "192.168.50.32")
				    (user "git")
				    (port 2222))))))))
 )
