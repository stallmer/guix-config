(use-modules (gnu home)
             (gnu services)
	     (gnu packages)
             (guix gexp)
	     (gnu packages games)
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
					   "foot"
					   "waybar"
					   "grimshot"

					   ;; Compatibility with older Xorg apps
					   "xorg-server-xwayland"

					   ;; Flapak and XD utilities
					   "flatpak"
					   "xdg-utils"
					   ;;"xdg-desktop-portal"
					   "xdg-desktop-portal-gtk"
					   "xdg-desktop-portal-wlr"
					   "xdg-dbus-proxy"
					   "shared-mime-info"
					   "glib:bin"
					   "wl-clipboard"
					   "fuzzel"

					   ;; CLI Programs
					   "fish"
                                           "neovim"
					   "emacs"
                                           "tealdeer"
					   "jq"
					   "pipewire"
					   "wireplumber"
					   "brightnessctl"
					   "stow"
					   "fzf"
					   
					   ;; GUI Tools
					   "firefox"

					   ;; Fonts and symbols
					   "jetbrains-mono-nerd-font"
					   "papirus-icon-theme"
					   "breeze-icons"
					   "gnome-themes-extra"
					   "font-google-noto-emoji"
					   "font-google-noto"
					   "font-jetbrains-mono"
					   "adwaita-icon-theme"
					   "emacs-all-the-icons"
					   "emacs-all-the-icons-dired"
					   "font-awesome"
					   "hicolor-icon-theme"

					   ;; Audio and video playback
					   "yt-dlp"
					   "mpv"
					   "mpv-mpris"
					   "playerctl"
					   "pavucontrol"
					   "lm-sensors"
					   "blueman"
					   "bluez"
					   "gstreamer"
					   "gst-plugins-base"
					   "gst-plugins-good"
					   "gst-plugins-bad"
					   "gst-plugins-ugly"
					   "gst-libav"
					   "libva"
					   "libva-utils"

					   ;; File syncing
					   "syncthing"
					   "syncthing-gtk"

					   ;; Misc utilities
					   "zip"
					   "unzip"
					   "trash-cli"
					   "mako"
					   "feh"

					   ;; GNOME Extensions
					   "gnome-shell-extension-appindicator"
					   "gnome-shell-extension-dash-to-dock"
					   "gnome-shell-extension-blur-my-shell"
					   "murrine"
					   "sassc"
					   "gnome-tweaks"
					   )))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list 
     (service home-pipewire-service-type)
     (service home-dbus-service-type)
     ;; (udev-rules-service 'steam-devices steam-devices-udev-rules)
     (service home-syncthing-service-type)
     (service home-bash-service-type
	      (home-bash-configuration
		;; Add custom shell scripts to PATH
	       (environment-variables '(("PATH" . "$HOME/.local/bin:$PATH")

					;; Ensure flatpaks are visible
					("XDG_DATA_DIRS" . "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share")

					;; Set Wayland-specific environment variables
					("XDG_CURRENT_DESKTOP" . "gnome")
					("XDG_SESSION_TYPE" . "wayland")
					("MOZ_ENABLE_WAYLAND" . "1")))
	       (aliases '())
	       (bashrc (list (local-file "/home/stephen/.bashrc" "bashrc")))
	       (bash-profile
		`(,(local-file "/home/stephen/.bash_profile"
			       "bash_profile")
		  ;; ,(plain-file "bash-sway-login"
		  ;; 	       (string-append
		  ;; 		"if [ -z \"$WAYLAND_DISPLAY\" ] && [ \"$XDG_VTNR\" -eq 1 ]; then\n"
		  ;; 		"  exec sway\n"
		  ;; 		"fi\n"))
		  ))))
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
