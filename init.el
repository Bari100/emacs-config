;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 180)
(defvar efs/default-variable-font-size 180)

;; Make frame transparency overridable
(defvar efs/frame-transparency '(90 . 90))

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

(setq confirm-kill-emacs 'y-or-n-p)

(define-prefix-command 'custom-prefix)
(global-set-key (kbd "C-;") 'custom-prefix)

(dolist (binding '(("v" . my/vterm-open-in-project-root)
                   ("b" . (lambda () (interactive) (switch-to-buffer nil)))
		   ("+" . (lambda () (interactive) (call-interactively #'dired-create-empty-file)))))
  (define-key custom-prefix (kbd (car binding)) (cdr binding)))

(use-package evil
  :config
  ;; Don't enter normal mode in these buffer types
  (evil-set-initial-state 'xref--xref-buffer-mode 'emacs)
  (evil-set-initial-state 'vterm-mode 'emacs))

(defvar evil-enabled-state nil)
(defun toggle-evil-mode ()
  (interactive)
  (setq evil-enabled-state (not evil-enabled-state))
  (if evil-enabled-state
      (progn
        (message "Enabling Evil mode..")
        (evil-mode t))
    (message "Disabling Evil mode...")
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer (evil-local-mode -1)))
    (evil-mode -1)))

;;(add-hook 'vterm-mode-hook #'(lambda () (evil-local-mode -1)))
;;(with-eval-after-load 'evil
;;  (evil-set-initial-state 'xref--xref-buffer-mode 'emacs))

;;(global-unset-key (kbd "C-z"))
;;(setq evil-toggle-key "")
;;(define-key evil-motion-state-map (kbd "C-z") 'toggle-evil-mode)
;;(define-key evil-emacs-state-map (kbd "C-z") 'toggle-evil-mode)
;;(global-set-key "\C-z" 'toggle-evil-mode)

(use-package modalka)

;;  (modalka-define-kbd "W" "M-w")
;;  (modalka-define-kbd "W" "M-w")
;;  (modalka-define-kbd "Y" "M-y")
(modalka-define-kbd "a" "C-a")
(modalka-define-kbd "h" "C-b")
(modalka-define-kbd "j" "C-n")
(modalka-define-kbd "k" "C-p")
(modalka-define-kbd "l" "C-f")
(modalka-define-kbd "d" "C-d")
(modalka-define-kbd "/" "C-/")
(modalka-define-kbd "b" "C-b")
(modalka-define-kbd "e" "C-e")
(modalka-define-kbd "f" "C-f")
(modalka-define-kbd "g" "C-g")
(modalka-define-kbd "n" "C-n")
(modalka-define-kbd "p" "C-p")
(modalka-define-kbd "w" "C-w")
(modalka-define-kbd "y" "C-y")
(modalka-define-kbd "v" "C-v")
(modalka-define-kbd "SPC" "C-SPC")
(define-key modalka-mode-map "x" ctl-x-map)
(define-key ctl-x-map (kbd "s") #'save-buffer) ;; seems like this is redaundant
(define-key modalka-mode-map (kbd "i")
  (lambda ()
    (interactive)
    (modalka-global-mode -1)))

(global-set-key (kbd "M-[")
  (lambda ()
    (interactive)
    (modalka-global-mode 1)))

(define-key modalka-mode-map (kbd "; v")
  (lambda ()
    (interactive)
    (my/vterm-open-in-project-root)))

(define-key modalka-mode-map (kbd "; b")
  (lambda ()
    (interactive)
    (switch-to-buffer nil)))

(setq-default cursor-type 'hollow)

(use-package multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'set-rectangular-region-anchor)

(electric-indent-mode -1)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

;; scrolling line by line
(setq scroll-conservatively 101)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell nil)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha efs/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,efs/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		vterm-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook
		nov-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;;  (set-face-attribute 'default nil :font "Aporetic Sans Mono" :height efs/default-font-size)
      (set-face-attribute 'default nil :font "Iosevka" :height efs/default-font-size)
  ;;  (set-face-attribute 'default nil :font "JetBrains Mono" :height efs/default-font-size)

      ;; Set the fixed pitch face
      ;;(set-face-attribute 'fixed-pitch nil :font "Aporetic Sans Mono" :height efs/default-font-size)
  (set-face-attribute 'fixed-pitch nil :font "Iosevka" :height efs/default-font-size)
;;  (set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :height efs/default-font-size)

      ;; Set the variable pitch face
      ;;(set-face-attribute 'variable-pitch nil :font "Aporetic Sans Mono" :height efs/default-variable-font-size :weight 'regular)
    (set-face-attribute 'variable-pitch nil :font "Iosevka" :height efs/default-variable-font-size :weight 'regular)

(use-package command-log-mode
  :commands command-log-mode)

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(use-package all-the-icons)

;;(use-package doom-modeline
;;  :init (doom-modeline-mode 1)
;;  :custom ((doom-modeline-height 15)))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package ivy
    :diminish
    :bind (("C-s" . swiper)
           :map ivy-minibuffer-map
           ("TAB" . ivy-alt-done)
           ("C-l" . ivy-alt-done)
           ("C-j" . ivy-next-line)
           ("C-k" . ivy-previous-line)
           :map ivy-switch-buffer-map
           ("C-k" . ivy-previous-line)
           ("C-l" . ivy-done)
           ("C-d" . ivy-switch-buffer-kill)
           :map ivy-reverse-i-search-map
           ("C-k" . ivy-previous-line)
           ("C-d" . ivy-reverse-i-search-kill))
    :config
    (ivy-mode 1))

;;  (use-package ivy-rich
;;    :after ivy
;;    :init
;;    (ivy-rich-mode 1))

(use-package ivy-prescient
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Uncomment the following line to have sorting remembered across sessions!
  ;(prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
 ;; :custom
 ;; (counsel-describe-function-function #'helpful-callable)
 ;; (counsel-describe-variable-function #'helpful-variable)
  :bind
;;  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
;;  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra
  :defer t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

;; (efs/leader-keys
;;   "ts" '(hydra-text-scale/body :which-key "scale text"))

;;  (lsp-headerline-breadcrumb-mode -1)
;;  (setq lsp-headerline-breadcrumb-mode nil)
;;  (setq lsp-ui-sideline-enable nil)
;;        (defun efs/lsp-mode-setup ()
;;        ;;    (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
;;          (lsp-headerline-breadcrumb-mode -1))
;;
;;          (use-package lsp-mode
;;            :commands (lsp lsp-deferred)
;;            :hook (lsp-mode . efs/lsp-mode-setup)
;;            :init
;;            (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
;;            :custom
;;            (lsp-diagnostics-provider :flycheck)
;;            (lsp-modeline-diagnostics-enable nil)
;;            (lsp-headerline-breadcrumb-mode -1)
;;            :config
;;            (lsp-enable-which-key-integration t))
;;      ;; load lsp automatically for all programming languages
;;      (add-hook 'prog-mode-hook 'lsp-deferred)
;;  (lsp-headerline-breadcrumb-mode -1)

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;;(use-package flycheck
;;  :ensure t
;;  :init (global-flycheck-mode)
;;  :config
;;  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)
  :commands dap-debug
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed

  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
    :keymaps 'lsp-mode-map
    :prefix lsp-keymap-prefix
    "d" '(dap-hydra t :wk "debugger")))

(use-package go-mode)
;;  (autoload 'go-mode "go-mode" nil t)
;;  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
;;  (add-hook 'go-mode-hook 'lsp-deferred)

;;  (use-package typescript-mode
;;  ;;  :mode "\\.ts\\'"
;;  ;;  :hook (typescript-mode . lsp-deferred)
;;    :config
;;    (setq typescript-indent-level 2))
;;
;;(setq css-indent-offset 2)
  (use-package typescript-mode
    :after tree-sitter
  ;;  :mode "\\.ts\\'"
  ;;  :hook (typescript-mode . lsp-deferred)
    :config
    (define-derived-mode typescriptreact-mode typescript-mode
    "TypeScript TSX")
    (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))
    (add-to-list 'tree-sitter-major-mode-language-alist '(typescriptreact-mode . tsx))
    (setq typescript-indent-level 2))

(setq css-indent-offset 2)

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Aporetic Sans Mono" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :pin org
  :commands (org-capture org-agenda)
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-link-frame-setup
        '((vm . vm-visit-folder-other-frame)
         (vm-imap . vm-visit-imap-folder-other-frame)
         (gnus . org-gnus-no-new-news)
         ;; using find-file instead of the default find-file-other-window
         ;; to open a file in the same window when following a link
         (file . find-file)
         (wl . wl-other-frame))
        )


  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
        '("~/org/agenda/Personal.org" "~/Dropbox/org/common.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
        '(("Archive.org" :maxlevel . 1)
          ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
        '((:startgroup)
                                        ; Put mutually exclusive tags here
          (:endgroup)
          ("@errand" . ?E)
          ("@home" . ?H)
          ("@work" . ?W)
          ("agenda" . ?a)
          ("planning" . ?p)
          ("publish" . ?P)
          ("batch" . ?b)
          ("note" . ?n)
          ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-deadline-warning-days 7)))
            (todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))
            (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

          ("n" "Next Tasks"
           ((todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))))

          ("W" "Work Tasks" tags-todo "+work-email")

          ;; Low-effort next actions
          ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
           ((org-agenda-overriding-header "Low Effort Tasks")
            (org-agenda-max-todos 20)
            (org-agenda-files org-agenda-files)))

          ("w" "Workflow Status"
           ((todo "WAIT"
                  ((org-agenda-overriding-header "Waiting on External")
                   (org-agenda-files org-agenda-files)))
            (todo "REVIEW"
                  ((org-agenda-overriding-header "In Review")
                   (org-agenda-files org-agenda-files)))
            (todo "PLAN"
                  ((org-agenda-overriding-header "In Planning")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "BACKLOG"
                  ((org-agenda-overriding-header "Project Backlog")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "READY"
                  ((org-agenda-overriding-header "Ready for Work")
                   (org-agenda-files org-agenda-files)))
            (todo "ACTIVE"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "COMPLETED"
                  ((org-agenda-overriding-header "Completed Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "CANC"
                  ((org-agenda-overriding-header "Cancelled Projects")
                   (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
        `(("t" "Tasks / Projects")
          ("tt" "Task" entry (file+olp "~/Projects/Code/emacs-from-scratch/OrgFiles/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

          ("j" "Journal Entries")
          ("jj" "Journal" entry
           (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
          ("jm" "Meeting" entry
           (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

          ("w" "Workflows")
          ("we" "Checking Email" entry (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

          ("m" "Metrics Capture")
          ("mw" "Weight" table-line (file+headline "~/Projects/Code/emacs-from-scratch/OrgFiles/Metrics.org" "Weight")
           "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
              (lambda () (interactive) (org-capture nil "jj")))

  (efs/org-font-setup))

;; org roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/org/roam/"))
  (org-roam-capture-templates
   '(("d" "default" plain
      "\n\n%?\n\n* Resources\n\n"
      :if-new (file+head
               "%<%Y%m%d%H%M%S>-${slug}.org"
               "#+title: ${title}\n#+date: %U\n#+filetags:")
      :unnarrowed t)))
  :bind (("C-c n l" . org-roam-buffer-toggle)
       ("C-c n f" . org-roam-node-find)
       ("C-c n g" . org-roam-graph)
       ("C-c n i" . org-roam-node-insert)
       ("C-c n c" . org-roam-capture)
       ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-enable))

 ;; adding possibility to search org roam notes by tag
 (setq org-roam-node-display-template
        (concat "${title:*} "
                (propertize "${tags:10}" 'face 'org-tag)))


(use-package org-roam-ui)

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package ob-go)
(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (go . t)
     (sql . t)
     (shell . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("go" . "src go"))
  (add-to-list 'org-structure-template-alist '("ts" . "src typescript")))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(use-package uniline)

(use-package hammy)

(use-package pdf-tools)

(use-package nov)

(use-package gt :ensure t)
(setq gt-langs '(en ru))
(setq gt-default-translator (gt-translator :engines (gt-bing-engine)))

(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  ;;:bind (("M-$" . jinx-correct)
  ;;       ("C-M-$" . jinx-languages)
	 )
(setq jinx-languages "en")

;; --- Eglot + ts-ls (typescript-language-server) ---
  ;; Requires: npm i -g typescript-language-server typescript
;;  (use-package eglot
;;    :ensure t
;;    :hook ((typescript-ts-mode tsx-ts-mode js-ts-mode js-mode) . eglot-ensure)
;;    :config
;;    ;; Tell Eglot to use ts-ls for these modes
;;    (add-to-list 'eglot-server-programs
;;                 '((typescript-ts-mode tsx-ts-mode js-ts-mode js-mode)
;;                   . ("typescript-language-server" "--stdio")))
;;
;;    ;; Prefer project-local node_modules/.bin if present (tsserver, ts-ls)
;;    (defun my/eglot-node-path ()
;;      (when-let* ((root (or (project-root (project-current nil))
;;                            (locate-dominating-file default-directory "package.json")))
;;                  (bin  (expand-file-name "node_modules/.bin" root)))
;;        (when (file-exists-p bin)
;;          (make-local-variable 'exec-path)
;;          (add-to-list 'exec-path bin)
;;          (setenv "PATH" (concat bin path-separator (getenv "PATH"))))))
;;    (add-hook 'eglot-managed-mode-hook #'my/eglot-node-path))
;;
;;(setq eglot-stay-out-of '(flymake))
;;
;;(add-hook 'eglot-managed-mode-hook
;;          (lambda ()
;;            (flymake-mode -1)
;;            (flycheck-mode 1)))

  ;; Optional: auto-format with the server on save (uncomment if wanted)
  ;; (add-hook 'eglot-managed-mode-hook
  ;;           (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil t)))


(use-package eglot
  ;; :straight nil
  :custom
  (eglot-autoshutdown t)
  :hook
  (eglot-managed-mode . me/flymake-eslint-enable-maybe)
  (typescript-ts-base-mode . eglot-ensure)
  :init
  (put 'eglot-server-programs 'safe-local-variable 'listp)
  :config
  ;; (add-to-list 'eglot-stay-out-of 'eldoc-documentation-strategy)
  ;; (put 'eglot-error 'flymake-overlay-control nil)
  ;; (put 'eglot-warning 'flymake-overlay-control nil)
  (setq eglot-confirm-server-initiated-edits nil)
  (advice-add 'eglot--apply-workspace-edit :after #'me/project-save)
  (advice-add 'project-kill-buffers :before #'me/eglot-shutdown-project)
  :preface
  (defun me/eglot-shutdown-project ()
    "Kill the LSP server for the current project if it exists."
    (when-let ((server (eglot-current-server)))
      (ignore-errors (eglot-shutdown server)))))

(cl-defmethod project-root ((project (head marker-file)))
  (cdr project))

(defun project-try-marker (dir)
  "Find DIR's project root by searching for a `.project.el' file.

If this file exists, it marks the project root.  For convenient
compatibility with Projectile, `.projectile' is also considered
a project root marker."
  (let ((root (or (locate-dominating-file dir ".project.el")
                  (locate-dominating-file dir ".projectile")
                  (locate-dominating-file dir "go.mod"))))
    (when root (cons 'marker-file root))))

(add-hook 'project-find-functions #'project-try-marker)

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge 
  :after magit)

(use-package diff-hl)
(global-diff-hl-mode)

(use-package git-timemachine)

;; (use-package evil-nerd-commenter
;;   :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package restclient)

;;  (use-package flymake-eslint
  ;;    :ensure t
  ;;    :hook ((js-ts-mode tsx-ts-mode typescript-ts-mode) . flymake-eslint-enable))
  ;;
  ;;

  ;;; --- Flymake + ESLint (stdin/json), no project edits required ---
  ;;; -*- lexical-binding: t; -*-
  ;;; Flymake + ESLint via stdin/json (shows eslint + prettier/prettier)
  ;;; -*- lexical-binding: t; -*-
  ;;; -*- lexical-binding: t; -*-
  ;;; -*- lexical-binding: t; -*-
(use-package flymake-eslint
  :preface
  (defun me/flymake-eslint-enable-maybe ()
    "Enable `flymake-eslint' based on the project configuration.
Search for the project ESLint configuration to determine whether the buffer
should be checked."
    (when-let* ((root (locate-dominating-file (buffer-file-name) "package.json"))
                (rc (locate-file ".eslintrc" (list root) '(".js" ".json"))))
      (make-local-variable 'exec-path)
      (push (file-name-concat root "node_modules" ".bin") exec-path)
      (flymake-eslint-enable))))

  (use-package flymake
  ;; :straight nil
  :custom
  (flymake-fringe-indicator-position nil))


(defun my/eslint-fix-buffer ()
  "Run eslint --fix on the current file and reload buffer."
  (interactive)
  (when (and buffer-file-name
             (file-exists-p buffer-file-name))
    (shell-command (format "npx eslint %s --fix"
                           (shell-quote-argument buffer-file-name)))
    (revert-buffer :ignore-auto :noconfirm)))

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(defun my/vterm-open-in-project-root ()
  "Open vterm in the root of the current project."
  (interactive)
  (let ((default-directory
         (if-let ((project (project-current)))
             (project-root project)
           default-directory)))
    (vterm)))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
  (setq explicit-powershell.exe-args '()))

(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  ;; (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  ;; (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  ;; (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'powerline))

(winner-mode 1)

(setq help-window-select t)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  ;; fixing "Listing directory failed but ‘access-file’ worked"
  ;; bug
  (when (eq system-type 'darwin)
      (setq insert-directory-program "/opt/homebrew/bin/gls")))
  ;; (evil-collection-define-key 'normal 'dired-mode-map
    ;; "h" 'dired-single-up-directory
    ;; "l" 'dired-single-buffer))

;; (use-package dired-single
  ;; :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :commands (dired dired-jump)
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

;; (use-package dired-hide-dotfiles
;;   :hook (dired-mode . dired-hide-dotfiles-mode)
;;   :config
;;   (evil-collection-define-key 'normal 'dired-mode-map
;;     "H" 'dired-hide-dotfiles-mode))

(use-package leetcode)

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))

(setq mac-option-modifier 'super
        mac-command-modifier 'meta)

;;(use-package jira
;;  :config
;;  (setq jira-base-url "") ;; Jira instance URL
;;  (setq jira-username "") ;; Jira username (usually, an email)
;;  ;; API token for Jira
;;  ;; See https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
;;  (setq jira-token "")
;;  ;;(setq jira-token-is-personal-access-token nil)
;;  (setq jira-api-version 3)) ;; Version 2 is also allowed
;;  ;; (Optional) API token for JIRA TEMPO plugin
;;  ;; See https://apidocs.tempo.io/
;;  ;;(setq jira-tempo-token "foobar123123"))
