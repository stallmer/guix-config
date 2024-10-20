;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
             (gnu services desktop)
             (nongnu packages linux)
             (nongnu system linux-initrd)
	     (btv tailscale)
	     (ice-9 match))
(use-package-modules wm)
(use-service-modules cups networking ssh xorg)

(define etc-sudoers-config
  (plain-file "etc-sudoers-config"
	      "\
root    ALL=(ALL) ALL
%wheel  ALL=(ALL) ALL
%wheel  ALL=(ALL) NOPASSWD: /run/current/profile/bin/evremap
%wheel  ALL=(ALL) NOPASSWD: /run/current-system/profile/bin/loginctl
"))

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "lemur")
  (sudoers-file etc-sudoers-config)

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "stephen")
                  (comment "Stephen Daunheimer")
                  (group "users")
                  (home-directory "/home/stephen")
                  (supplementary-groups '("wheel"
					  "netdev"
					  "audio"
					  "video"
					  "input"
					  "lp")))
                %base-user-accounts))
  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (map specification->package '("vim"
						  "firefox"
						  "neovim"
						  "emacs"
						  "openssh"
						  "git"
						  "wget"
						  "curl"
						  "neovim"
						  "iptables"

						  ;;Sway
						  "sway"
						  "swaybg"
						  "swayidle"
						  "swaylock"
						  "kitty"
						  "waybar"
						  "tailscale"
						  "evremap"))
		    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service tailscale-service-type)
		 (service bluetooth-service-type))
	   (modify-services %desktop-services
			    (delete gdm-service-type)
			    ;; Get nonguix substitutes
			    (guix-service-type config =>
					       (guix-configuration
						(inherit config)
						(substitute-urls
						 (append (list "https://substitutes.nonguix.org")
							 %default-substitute-urls))
						(authorized-keys
						 (append (list (local-file "./nonguix-signing-key.pub"))
							 %default-authorized-guix-keys)))))))
   ;;(append (list (service gnome-desktop-service-type)
   ;;             (service cups-service-type)
   ;;              (set-xorg-configuration
   ;;               (xorg-configuration (keyboard-layout keyboard-layout))))))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "a68e3c22-69a5-42d9-b41d-1eccf4b076f5")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "3D07-1460"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "5be54081-e0f6-4f88-af89-6f5bbd180814"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
