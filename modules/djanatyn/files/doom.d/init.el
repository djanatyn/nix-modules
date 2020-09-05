(doom!
 :checkers spell

 :feature (syntax-checker +childframe) workspaces

 :completion (company +auto) (helm +fuzzy)

 :ui doom doom-dashboard doom-quit modeline ophints fill-column hl-todo
 nav-flash (popup +all +defaults) pretty-code vc-gutter vi-tilde-fringe
 window-select treemacs hydra zen minimap

 :editor snippets (evil +everywhere) file-templates (format +onsave)
 multiple-cursors parinfer rotate-text

 :emacs dired electric hideshow vc

 :term eshell term

 :tools lookup eval ansible docker editorconfig gist make magit password-store
 tmux upload

 :lang data emacs-lisp (haskell +dante) latex markdown nix perl
 (org +attach +babel +capture +export +present)
 python (sh +zsh)

 :email notmuch

 :app (rss +org) irc

 :config (default +bindings +snippets +evil-commands))
