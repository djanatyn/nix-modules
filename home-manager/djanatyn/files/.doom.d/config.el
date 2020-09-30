(after! org
  (setq org-agenda-files
        '("~/repos/org")))

(after! term
  (setq multi-term-program "/bin/bash"))

(setq doom-line-numbers-style 'relative)

;; theming
;; (require 'leuven-theme)
(setq doom-theme 'doom-one)

;; use terminus font
;; (setq doom-font "xft:-xos4-Terminess Powerline-normal-normal-normal-*-16-*-*-*-c-80-iso10646-1")

;; transparent background
(doom/set-frame-opacity 90)

;; symon
(require 'symon)
(symon-mode)

;; ormolu
(set-formatter! 'ormolu "ormolu" :modes '(haskell-mode))

;; dante
(setq dante-methods '(stack snack nix))

;; fix ssh inside tmux
(defun fix-ssh ()
  (interactive)
  (setenv "SSH_AUTH_SOCK" (string-trim (shell-command-to-string "gpgconf --list-dirs agent-ssh-socket"))))
(fix-ssh)

;; elfeed
(setq rmh-elfeed-org-files (list "~/.feeds.org"))

;; pinentry
(setenv "INSIDE_EMACS" (format "%s,comint" emacs-version))
(pinentry-start)

;; email
(setq +notmuch-sync-backend 'mbsync)

;; irc
(after! circe
  (set-irc-server! "chat.freenode.net"
    `(:tls t
      :port 6697
      :nick "djanatyn"
      :sasl-username ,(+pass-get-user "irc/freenode.net")
      :sasl-password (lambda (&rest _),(+pass-get-secret "irc/freenode.net"))
      :channels ("#jbopre" "#emacs"))))