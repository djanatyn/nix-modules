;; doom modules
;; ============
(after! doom
  (setq display-line-numbers-type 'relative)
  (doom/set-frame-opacity 90)
  (setq doom-theme 'doom-outrun-electric)
  (setq doom-font (font-spec :family "Hack" :size 12)))

(after! org
  (setq org-agenda-files '("~/org-roam/" "~/org-roam/daily/")))

(after! term
  (setq multi-term-program "/run/current-system/sw/bin/bash"))

(after! notmuch
  (setq +notmuch-sync-backend 'mbsync))

(after! haskell
  (set-formatter! 'ormolu "ormolu" :modes '(haskell-mode)))

(after! format
  (setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode  ; elisp's mechanisms are good enough
            sql-mode         ; sqlformat is currently broken
            tex-mode         ; latexindent is broken
            latex-mode
            nix-mode)))

(after! magit
  (magit-delta-mode +1))

;; individual packages
;; ===================
(use-package! symon
  :init (symon-mode))

(use-package! elfeed
  :init (setq rmh-elfeed-org-files (list "~/.feeds.org")))

(use-package! pinentry
  :init (setenv "INSIDE_EMACS" (format "%s,comint" emacs-version))
  :config (pinentry-start))

(use-package! wakatime-mode
  :config (global-wakatime-mode))

(use-package! org-roam
  :config (setq org-roam-directory "~/org-roam"))

(use-package! delve-minor-mode
  :config (add-hook 'org-mode-hook #'delve-minor-mode-maybe-activate))

(use-package! silicon)

;; set ssh agent socket to gpg agent
(defun gpg-ssh ()
  (interactive)
  (setenv "SSH_AUTH_SOCK" (string-trim (shell-command-to-string "gpgconf --list-dirs agent-ssh-socket"))))
