;; doom modules
;; ============
(after! doom
  (setq display-line-numbers-type 'relative)
  (doom/set-frame-opacity 90)
  (setq doom-theme 'doom-one))

(after! org
  (setq org-agenda-files
        '("~/repos/org")))

(after! term
  (setq multi-term-program "/bin/bash"))

(after! notmuch
  (setq +notmuch-sync-backend 'mbsync))

(after! haskell
  (set-formatter! 'ormolu "ormolu" :modes '(haskell-mode)))

;; individual packages
;; ===================
(use-package! symon
  :init (symon-mode))

(use-package! dante
  :init (setq dante-methods '(stack snack nix)))

(use-package! elfeed
  :init (setq rmh-elfeed-org-files (list "~/.feeds.org")))

(use-package! pinentry
  :init (setenv "INSIDE_EMACS" (format "%s,comint" emacs-version))
  :config (pinentry-start))

(use-package! wakatime-mode
  :config (global-wakatime-mode))

;; set ssh agent socket to gpg agent
(defun gpg-ssh ()
  (interactive)
  (setenv "SSH_AUTH_SOCK" (string-trim (shell-command-to-string "gpgconf --list-dirs agent-ssh-socket"))))
