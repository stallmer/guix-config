;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
	     (gnu services desktop)
	     (gnu services base)
	     (nongnu packages linux)
             (nongnu system linux-initrd)
	     (btv tailscale)
	     (ice-9 match))
(use-package-modules wm)
(use-service-modules cups networking ssh xorg)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware sof-firmware))
  (locale "en_US.utf8")
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "carbon")

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
  (packages (append (map specification->package '("openssh"
						  "vim"
						  "git"
						  "curl"
						  "wget"

						  "tailscale"
						  "intel-media-driver"
						  ))
		    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service tailscale-service-type)
		 (service bluetooth-service-type)
		 (service gnome-desktop-service-type))
	   (modify-services %desktop-services
			    ;; Get nonguix substitutes
			    (guix-service-type config =>
					       (guix-configuration
						(inherit config)
						(substitute-urls
						 (append (list "https://substitutes.nonguix.org")
							 %default-substitute-urls))
						(authorized-keys
						 (append (list (local-file "./nonguix-signing-key.pub"))
							 %default-authorized-guix-keys))))
			    (gdm-service-type config =>
					      (gdm-configuration (inherit config) (wayland? #t))))))

  ;; ;; Below is the list of system services.  To search for available
  ;; ;; services, run 'guix system search KEYWORD' in a terminal.
  ;; (services (modify-services (cons (service gnome-desktop-service-type)
  ;; 				   %desktop-services)
  ;;                            (guix-service-type config =>
  ;; 						(guix-configuration
  ;;                                                (inherit config)
  ;;                                                (substitute-urls
  ;;                                                 (append (list "https://substitutes.nonguix.org")
  ;;                                                         %default-substitute-urls))
  ;;                                                (authorized-keys
  ;;                                                 (append (list (local-file "./nonguix-signing-key.pub"))
  ;;                                                         %default-authorized-guix-keys))))))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "7c8e7eb5-6359-409f-9774-1c301fc31ba5")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "3D54-FC25"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "4970bb09-7db4-4f73-9b4c-892d106672c2"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
