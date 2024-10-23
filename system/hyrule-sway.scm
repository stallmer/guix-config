;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
	     (gnu services desktop)
	     (gnu services base)
	     (nongnu packages linux)
	     (nongnu system linux-initrd)
	     (btv tailscale))
(use-package-modules wm)
(use-service-modules cups desktop networking ssh xorg dbus freedesktop gstreamer)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "hyrule")

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
						  ))
		    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service tailscale-service-type)
		 (service bluetooth-service-type)
		 ;; (service gnome-desktop-service-type)
		 (service openssh-service-type)
		 (service cups-service-type)
		 (set-xorg-configuration
		  (xorg-configuration (keyboard-layout keyboard-layout))))
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
  ;; (services
  ;;  (append (list (service gnome-desktop-service-type)

  ;;                ;; To configure OpenSSH, pass an 'openssh-configuration'
  ;;                ;; record as a second argument to 'service' below.
  ;;                (service openssh-service-type)
  ;;                (service cups-service-type)
  ;;                (set-xorg-configuration
  ;;                 (xorg-configuration (keyboard-layout keyboard-layout))))

           ;; This is the default list of services we
           ;; are appending to.
           ;; %desktop-services))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "ba637044-d40a-4f7a-8d63-d2dfaebc49df")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "D3B8-F397"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "3df21d41-3824-4d47-97b1-43a546757c03"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
