

(setq init-dir (expand-file-name (concat "~" init-file-user "/.emacs.d")))

(setq gc-cons-threshold most-positive-fixnum)
(setq gnutls-min-prime-bits 4096)
(setq comp-async-report-warnings-errors nil)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ("org" . "https://orgmode.org/elpa/")))

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(add-to-list 'package-archives
             '("gnu elpa" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives
             '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)


;;(setq package-enable-at startup nil)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(toggle-scroll-bar -1)
(add-to-list 'default-frame-alist '(undecorated . t))
(set-frame-parameter nil 'undecorated t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "") ;; Uh, I know what Scratch is for
(tool-bar-mode -1)               ;; Toolbars were only cool with XEmacs
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(column-number-mode)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)


;; ;; Removes *scratch* from buffer after the mode has been set.
;; (defun remove-scratch-buffer ()
;;   (if (get-buffer "*scratch*")
;;       (kill-buffer "*scratch*")))
;; (add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;; Removes *messages* from the buffer.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")
;;(kill-buffer "*Async-native-compile-log*")


(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq make-pointer-invisible t)


(setq large-file-warning-threshold nil)
(setq vc-follow-symlinks t)
(setq ad-redefinition-action 'accept)
(setq use-dialog-box nil)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
(windmove-default-keybindings)

(add-hook 'eshell-mode-hook (lambda ()
                                    (setq-local global-hl-line-mode
                                                nil)))
(add-hook 'term-mode-hook (lambda ()
                                    (setq-local global-hl-line-mode
                                                nil)))
(setq completion-ignore-case t)
;; (setq eshell-cmpl-ignore-case t)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-hl-line-mode t)
(global-visual-line-mode 1)

(setq-default word-wrap t)

(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)

(setq history-delete-duplicates t)

;;setq display-line-numbers-type 'relative
(dolist (mode '(prog-mode-hook
                text-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))


(setq confirm-kill-processes nil)

(fset 'yes-or-no-p 'y-or-n-p)


(setq scroll-conservatively 10000
      scroll-preserve-screen-position t)
   ;;store all backup and autosave files in the tmp dir
  (setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(set-frame-parameter nil 'alpha-background 99) ; For current frame

(setq transparency_level 0)
(defun my:change_transparency ()
  "Toggles transparency of Emacs between 3 settings (none, mild, moderate)."
  (interactive)
  (if (equal transparency_level 0)
	  (progn (set-frame-parameter nil 'alpha-background 70)

      (setq transparency_level 1))
	(if (equal transparency_level 1)
	  (progn (set-frame-parameter nil 'alpha-background 1)

		 (setq transparency_level 2))
	  (if (equal transparency_level 2)
	  (progn (set-frame-parameter nil 'alpha-background 99)

	   (setq transparency_level 0))
	 ))))


(define-key global-map (kbd "C-0") 'my:change_transparency)


(defun reload-init-file ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(global-set-key (kbd "C-1") 'reload-init-file)

(global-set-key (kbd "<C-up>") 'shrink-window)
(global-set-key (kbd "<C-down>") 'enlarge-window)
(global-set-key (kbd "<C-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-right>") 'enlarge-window-horizontally)

(defun my-vsplit-last-buffer ()
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer))

(defun my-hsplit-last-buffer ()
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer))

(bind-key "C-x 2" 'my-vsplit-last-buffer)
(bind-key "C-x 3" 'my-hsplit-last-buffer)
(put 'upcase-region 'disabled nil)

(use-package helm
  :bind (("M-x" . helm-M-x)
         ("M-<f4>" . helm-find-files)
         ([f10] . helm-buffers-list)
         ([S-f10] . helm-recentf)))


(use-package saveplace
  :defer 3
  :init
  (save-place-mode 1)
  :custom
  (save-place-ignore-files-regexp
   "\\(?:COMMIT_EDITMSG\\|hg-editor-[[:alnum:]]+\\.txt\\|elpa\\|svn-commit\\.tmp\\|bzr_log\\.[[:alnum:]]+\\)$")
  (save-place-file (concat user-emacs-directory ".my-saved-places"))
  (save-place-forget-unreadable-files t))


(use-package evil-nerd-commenter
:bind ("M-/" . evilnc-comment-or-uncomment-lines))

(setq blink-matching-paren nil)

(bind-keys :map isearch-mode-map
           ("<left>"  . isearch-repeat-backward)
           ("<right>" . isearch-repeat-forward)
           ("<up>"    . isearch-ring-retreat)
           ("<down>"  . isearch-ring-advance))

(when (display-graphic-p)
  (require 'all-the-icons))
;; or
(use-package all-the-icons
  :if (display-graphic-p))

(all-the-icons-wicon "tornado" :face 'all-the-icons-blue)

(progn ; `window'
  (defun my/kill-this-buffer ()
    "Kill current buffer.
Better version of `kill-this-buffer' whose docstring says it is
unreliable."
    (interactive)
    (kill-buffer (current-buffer))))

  (bind-key "C-x k" #'my/kill-this-buffer)

;; Set default font
(set-face-attribute 'default nil
                    ;;:family "Courier New"
					:font "JetBrains Mono"
					:height 120
                    :weight 'Bold
                    :width 'normal)

(set-face-attribute 'font-lock-comment-face nil
  :slant 'normal)
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; Sets the default theme to load!!!
  (load-theme 'doom-Iosvkem t))


(defun fast-scroll-up ()
  "Scroll up 5 lines."
  (interactive)
  (scroll-up 5))


(defun fast-scroll-down ()
  "Scroll up 2 lines."
  (interactive)
  (scroll-down 5))

(global-set-key (kbd "<M-S-up>") 'fast-scroll-down)
(global-set-key (kbd "<M-S-down>") 'fast-scroll-up)
(global-set-key (kbd "C-.") 'hide-mode-line-mode)

(use-package savehist
  :demand t
  :config
  (setq history-length 25)
  (savehist-mode 1))


;;multiple cursors
(use-package multiple-cursors)
(global-set-key (kbd "C-S-c") 'mc/edit-lines)
(define-key mc/keymap (kbd "<return>") nil)


(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)


(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 1)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-minor-modes nil)
  (doom-modeline-enable-word-count nil)
  (doom-modeline-buffer-encoding t)
  (doom-modeline-indent-info nil)
  (doom-modeline-checker-simple-format t)
  (doom-modeline-vcs-max-length 12)
  (doom-modeline-env-version t)
  (doom-modeline-irc-stylize 'identity)
  (doom-modeline-github-timer nil)
  (doom-modeline-gnus-timer nil))

(set-face-attribute 'mode-line nil
                    :background "#353644"
                    :foreground "white"
                    :box '(:line-width 1 :color "#353644")
                    :overline nil
                    :underline nil)

(set-face-attribute 'mode-line-inactive nil
                    :background "#565063"
                    :foreground "white"
                    :box '(:line-width 1 :color "#565063")
                    :overline nil
                    :underline nil)

(add-hook 'doom-modeline-mode 'keycast-mode-line-mode)

(use-package rainbow-mode)

(when (require 'rainbow-delimiters "rainbow-delimiters" t)
  (message "init.el: rainbow-delimiters")
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(when (require 'rainbow-identifiers "rainbow-identifiers" t)
  (message "init.el: rainbow-identifiers")
  (add-hook 'prog-mode-hook 'rainbow-identifiers-mode))


(use-package pdf-tools
  :defer t
  :commands (pdf-loader-install)
  :mode "\\.pdf\\'"
  :bind (:map pdf-view-mode-map
              ("j" . pdf-view-next-line-or-next-page)
              ("k" . pdf-view-previous-line-or-previous-page)
              ("C-=" . pdf-view-enlarge)
              ("C--" . pdf-view-shrink))
  :init (pdf-loader-install)
  :config (add-to-list 'revert-without-query ".pdf"))

(add-hook 'pdf-view-mode-hook #'(lambda () (interactive) (display-line-numbers-mode -1)))

(use-package pdf-view-restore
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode))


(use-package emojify
  :hook (after-init . global-emojify-mode))
;; Notmuch

(setq yas/triggers-in-field nil)
(setq yas-snippet-dirs '("~/.emacs.d/snippets/"))

(yas-global-mode 1)

;; (use-package company
;;     :ensure t
;;     :config
;;     (setq company-idle-delay 0)
;;     (setq company-minimum-prefix-length 3))
(global-company-mode)

(add-hook 'tuareg-mode-hook
          (lambda ()
            (interactive)
            (company-mode 0)))

(use-package ivy
  :diminish
  :init
  (use-package amx :defer t)
  (use-package counsel :diminish :config (counsel-mode 1))
  (use-package swiper :defer t)
  (ivy-mode 1)
  :bind
  (("C-s" . swiper-isearch)
   ("C-x C-a" . counsel-buffer-or-recentf)
   ("C-x C-g" . counsel-ibuffer)
   (:map ivy-minibuffer-map
         ("M-RET" . ivy-immediate-done))
   (:map counsel-find-file-map
         ("C-~" . counsel-goto-local-home)))
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-height 10)
  (ivy-on-del-error-function nil)
  (ivy-magic-slash-non-match-action 'ivy-magic-slash-non-match-create)
  (ivy-count-format "【%d/%d】")
  (ivy-wrap t)
  :config
  (defun counsel-goto-local-home ()
      "Go to the $HOME of the local machine."
      (interactive)
    (ivy--cd "~/")))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :ensure t
  :init (ivy-rich-mode 1) ;; this gets us descriptions in M-x.
  :custom
  (ivy-virtual-abbreviate 'full
   ivy-rich-switch-buffer-align-virtual-buffer t
   ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))


(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)

(setq dired-dwim-target t)

(defun my-dired-init ()
  (dired-hide-details-mode 1))

(add-hook 'dired-mode-hook 'my-dired-init)

(require 'dired )

(if (< emacs-major-version 28)
    (progn
      (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file) ; was dired-advertised-find-file
      (define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file ".."))) ; was dired-up-directory
      )
  (progn
    (setq dired-kill-when-opening-new-dired-buffer t)))


(defun xah-dired-show-all-subdirs ()
  (interactive)
  (dired default-directory "-lR"))

(defun my-dired-init ()
  (interactive)

  ;; (define-key dired-mode-map (kbd ",") #'dired-prev-dirline)
  ;; (define-key dired-mode-map (kbd ".") #'dired-next-dirline)

  (define-key dired-mode-map (kbd ".") #'dired-do-shell-command)
  (define-key dired-mode-map (kbd ",") #'dired-up-directory)
  (define-key dired-mode-map (kbd "9") #'dired-hide-details-mode)

  (define-key dired-mode-map (kbd "b") #'dired-do-byte-compile)

  (define-key dired-mode-map (kbd "`") #'dired-flag-backup-files)

  (define-key dired-mode-map (kbd "e") nil)
  (define-key dired-mode-map (kbd "e c") #'dired-do-copy)
  (define-key dired-mode-map (kbd "e d") #'dired-do-delete)
  (define-key dired-mode-map (kbd "e g") #'dired-mark-files-containing-regexp)
  (define-key dired-mode-map (kbd "e h") #'dired-hide-details-mode)
  (define-key dired-mode-map (kbd "e m") #'dired-mark-files-regexp)
  (define-key dired-mode-map (kbd "e n") #'dired-create-directory)
  (define-key dired-mode-map (kbd "e r") #'dired-do-rename)
  (define-key dired-mode-map (kbd "e u") #'dired-unmark-all-marks)
  ;;
  )

(progn
  (require 'dired )
  (add-hook 'dired-mode-hook #'my-dired-init))

(require 'dired-preview)

;; Default values for demo purposes
(setq dired-preview-delay 0.7)
(setq dired-preview-max-size (expt 2 20))
(setq dired-preview-ignored-extensions-regexp
      (concat "\\."
              "\\(mkv\\|webm\\|mp4\\|mp3\\|ogg\\|m4a"
              "\\|gz\\|zst\\|tar\\|xz\\|rar\\|zip"
              "\\|iso\\|epub\\|pdf\\)"))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode))

;; Enable `dired-preview-mode' in a given Dired buffer or do it
;; globally:
(dired-preview-global-mode 1)

(use-package dired-single)
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package color-rg
  :load-path (lambda () (expand-file-name "site-elisp/color-rg" user-emacs-directory))
  :if (executable-find "rg")
  :bind ("C-M-s" . color-rg-search-input))


(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :custom
  (recentf-auto-cleanup "05:00am")
  (recentf-max-saved-items 200)
  (recentf-exclude '((expand-file-name package-user-dir)
                     ".cache"
                     ".cask"
                     ".elfeed"
                     "bookmarks"
                     "cache"
                     "ido.*"
                     "persp-confs"
                     "recentf"
                     "undo-tree-hist"
                     "url"
                     "COMMIT_EDITMSG\\'")))


(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :diminish smartparens-mode
  :bind
  (:map smartparens-mode-map
        ("C-M-f" . sp-forward-sexp)
        ("C-M-b" . sp-backward-sexp)
        ("C-M-a" . sp-backward-down-sexp)
        ("C-M-e" . sp-up-sexp)
        ("C-M-w" . sp-copy-sexp)
        ("C-M-k" . sp-change-enclosing)
        ("M-k" . sp-kill-sexp)
        ("C-M-<backspace>" . sp-splice-sexp-killing-backward)
        ("C-S-<backspace>" . sp-splice-sexp-killing-around)
        ("C-]" . sp-select-next-thing-exchange))
  :custom
  (sp-escape-quotes-after-insert nil)
  :config
  ;; Stop pairing single quotes in elisp
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
  (sp-local-pair 'lisp-mode "'" nil :actions nil)
  (sp-local-pair 'slime-repl-mode "'" nil :actions nil)
  (sp-local-pair 'org-mode "[" nil :actions nil))


(setq-default indent-tabs-mode nil)
(setq-default indent-line-function 'insert-tab)
(setq-default tab-width 4)
;; (setq-default c-basic-offset 4)
(setq-default delete-pair-blink-delay 0)
(blink-cursor-mode -1)

(use-package cc-mode
  :ensure nil
  :bind (:map c-mode-base-map
         ("<f12>" . compile))
  :init
  (setq default-tab-width 4)
  (setq c-default-style "linux")
  (setq-default c-basic-offset 4))

(defun compile-set ()
  (interactive)
  (let* ((file-name (buffer-file-name))
         (is-windows (equal 'windows-nt system-type))
         (exec-suffix (if is-windows ".exe" ".out")))
    (when file-name
      (setq file-name (file-name-nondirectory file-name))
      (let ((out-file (concat (file-name-sans-extension file-name) exec-suffix)))
        (setq-local compile-command (format "gcc -std=c11 -g %s -o %s && ./%s" file-name out-file out-file))))))

(global-set-key (kbd "C-M-z") 'compile-set)

(setq compilation-finish-functions
      (lambda (buf str)
        (if (null (string-match ".*exited abnormally.*" str))
            ;;no errors, make the compilation window go away in a few seconds
            (progn
              (run-at-time
               "3 sec" nil 'delete-windows-on
               (get-buffer-create "*compilation*"))
              (message "No Compilation Errors!")))))


(use-package lsp-mode
  :defer t
  :commands lsp
  :custom
  (lsp-keymap-prefix "C-x l")
  (lsp-auto-guess-root nil)
  (lsp-prefer-flymake nil) ; Use flycheck instead of flymake
  (lsp-enable-file-watchers nil)
  (lsp-enable-folding nil)
  (read-process-output-max (* 1024 1024))
  (lsp-keep-workspace-alive nil)
  (lsp-eldoc-hook nil)
  :bind ((:map lsp-mode-map ("C-c C-f" . lsp-format-buffer)
         ("C-h ," . help-at-pt-buffer)
         (:map lsp-mode-map
               ("M-<return>" . lsp-execute-code-action))
         (:map c++-mode-map
               ("C-c x" . lsp-clangd-find-other-file))
         (:map c-mode-map
               ("C-c x" . lsp-clangd-find-other-file))
         ))

  :init
  ;; (setenv "LSP_USE_PLISTS" "1")
  ;; Increase the amount of data emacs reads from processes
  (setq read-process-output-max (* 3 1024 1024))
  (setq lsp-clients-clangd-args '("--header-insertion-decorators=0"
                                  "--clang-tidy"
                                  "--enable-config"))
  ;; Small speedups
  (setopt lsp-log-max 0)
  (setopt lsp-log-io nil)
  ;; General lsp-mode settings
  (setq lsp-completion-provider :none
        lsp-enable-snippet t
        lsp-enable-on-type-formatting nil
        lsp-enable-indentation nil
        lsp-diagnostics-provider :flymake
        lsp-keymap-prefix "C-x L"
        lsp-eldoc-render-all t)

  :hook ((java-mode python-mode go-mode rust-mode
          js-mode js2-mode typescript-mode web-mode
          c-mode c++-mode objc-mode) . lsp-deferred)
  :config
  (defun lsp-update-server ()
    "Update LSP server."
    (interactive)
    ;; Equals to `C-u M-x lsp-install-server'
    (lsp-install-server t)))


(use-package lsp-ui
  :after lsp-mode
  :diminish
  :commands lsp-ui-mode
  :custom-face
  (lsp-ui-doc-background ((t (:background nil))))
  (lsp-ui-doc-header ((t (:inherit (font-lock-string-face italic)))))
  :bind
  (:map lsp-ui-mode-map
        ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
        ([remap xref-find-references] . lsp-ui-peek-find-references)
        ("C-c u" . lsp-ui-imenu)
        ("M-i" . lsp-ui-doc-focus-frame))
  (:map lsp-mode-map
        ("M-n" . forward-paragraph)
        ("M-p" . backward-paragraph))
  :custom
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-border (face-foreground 'default))
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-code-actions nil)
  :config
  ;; Use lsp-ui-doc-webkit only in GUI
  (when (display-graphic-p)
    (setq lsp-ui-doc-use-webkit t))
  ;; WORKAROUND Hide mode-line of the lsp-ui-imenu buffer
  ;; https://github.com/emacs-lsp/lsp-ui/issues/243
  (defadvice lsp-ui-imenu (after hide-lsp-ui-imenu-mode-line activate)
    (setq mode-line-format nil))
  ;; `C-g'to close doc
  (advice-add #'keyboard-quit :before #'lsp-ui-doc-hide))


;;; Go
(use-package go-mode
  :ensure t
  :hook ((go-mode . lsp-deferred)
         (go-mode . company-mode))
  :bind (:map go-mode-map
              ("<f6>"  . gofmt)
              ("C-c 6" . gofmt))
  :config
  (require 'lsp-go)
  ;; https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
  (setq lsp-go-analyses
        '((fieldalignment . t)
          (nilness        . t)
          (unusedwrite    . t)
          (unusedparams   . t)))
  ;; GOPATH/bin
  (add-to-list 'exec-path "~/go/bin")
  ;; requires goimports to be installed
  (setq gofmt-command "goimports"))



(load (expand-file-name "~/quicklisp/slime-helper.el"))
(add-to-list 'exec-path "/usr/local/bin")

(setq inferior-lisp-program "sbcl")


;; Enable Rainbow Delimiters.
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'ielm-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-interaction-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'slime-repl-mode-hook 'rainbow-delimiters-mode)

;; Customize Rainbow Delimiters.
(require 'rainbow-delimiters)
(set-face-foreground 'rainbow-delimiters-depth-1-face "#c66")  ; red
(set-face-foreground 'rainbow-delimiters-depth-2-face "#6c6")  ; green
(set-face-foreground 'rainbow-delimiters-depth-3-face "#69f")  ; blue
(set-face-foreground 'rainbow-delimiters-depth-4-face "#cc6")  ; yellow
(set-face-foreground 'rainbow-delimiters-depth-5-face "#6cc")  ; cyan
(set-face-foreground 'rainbow-delimiters-depth-6-face "#c6c")  ; magenta
(set-face-foreground 'rainbow-delimiters-depth-7-face "#ccc")  ; light gray
(set-face-foreground 'rainbow-delimiters-depth-8-face "#999")  ; medium gray
(set-face-foreground 'rainbow-delimiters-depth-9-face "#666")  ; dark gray

(add-hook 'slime-repl-mode-hook 'smartparens-mode)


(defun my-slime-keybindings ()
  "For use in `slime-mode-hook' and 'slime-repl-mode-hook."
  (local-set-key (kbd "C-l") 'slime-repl-clear-buffer))

(add-hook 'slime-mode-hook      #'my-slime-keybindings)
(add-hook 'slime-repl-mode-hook #'my-slime-keybindings)


(require 'em-smart)
(use-package eshell
  :bind (
         ;; ("s-w" . project-eshell)
         ("C-M-<return>" . eshell-new)
         )
  ;; Save all buffers before running a command.
  :init
  (setq eshell-error-if-no-glob t)
  ;; (setq eshell-scroll-to-bottom-on-input 'all)

  ;; (setq eshell-smart-space-goes-to-end t)
  ;; (setq eshell-scroll-to-bottom-on-input nil)
  ;; (setq eshell-where-to-jump 'begin)
  ;; (setq eshell-smart-space-goes-to-end t)
  ;; (setq eshell-scroll-to-bottom-on-output nil)
  ;; (setq eshell-scroll-show-maximum-output nil)
  ;; (setq eshell-output-filter-functions nil)
  ;; (setq eshell-postoutput-scroll-to-bottom nil)
  (setq eshell-history-size 10000)
  (setq eshell-hist-ignoredups t)
  (setq eshell-save-history-on-exit t)
  (setq eshell-kill-on-exit t)
  (setq eshell-buffer-maximum-lines 10000)
  ;; (setq comint-scroll-show-maximum-output nil)
  ;; (setq eshell-scroll-show-maximum-output nil)
  (setq eshell-destroy-buffer-when-process-dies t)
  (setq eshell-prompt-regexp "^.* λ ")
  (setq eshell-prompt-function #'+eshell-default-prompt-fn)
  :config
  (setq eshell-command-aliases-list
	'(("q" "exit")
	  ("c" "clear-scrollback")
	  ("ll" "ls -la")
      ("ff" "find-file $1")
	  ("e" "find-file $1")
      ("d" "dired $1")
      ("less" "view-file $1")
      ("up" "eshell-up $1")
      ("pk" "eshell-up-peek $1")
      ("rof" "recentf-open-files")
      ("eb" "eval-buffer")))
  
  (setq eshell-banner-message "")
  ;; (setq eshell-visual-commands
  ;;       `(,@eshell-visual-commands "jless"))

  
(setq eshell-visual-commands (append '("screen" "htop" "ncftp" "elm" "el" "nano" "ssh" "vim" "nvim" "nethack" "dstat" "tail")))
  (setq eshell-visual-subcommands (append '("git" ("log" "diff" "show"))))
  )

;; (setq eshell-visual-commands (append '("screen" "htop" "ncftp" "elm" "el" "nano" "ssh" "nethack" "dstat" "tail")))
;;   (setq eshell-visual-subcommands (append '("git" ("log" "diff" "show"))))
;; (defun eshell-new ()
 ;;    "Open a new eshell buffer."
 ;;    (interactive)
 ;;    (let ((buf (eshell)))
 ;;      (switch-to-buffer (other-buffer buf))
 ;;      (switch-to-buffer-other-window buf)))


  ;; Load eshell packages.

  (defface +eshell-prompt-pwd '((t (:inherit font-lock-constant-face)))
    "TODO"
    :group 'eshell)
  (defun +eshell-default-prompt-fn ()
    "Generate the prompt string for eshell. Use for `eshell-prompt-function'."
    (require 'shrink-path)
    (concat (let ((pwd (eshell/pwd)))
              (propertize (if (equal pwd "~")
                              pwd
                            (abbreviate-file-name (shrink-path-file pwd)))
                          'face '+eshell-prompt-pwd))
            (propertize " λ" 'face (if (zerop eshell-last-command-status) 'success 'error))
            " "))

  (use-package eshell-syntax-highlighting
    :config
    ;; Enable in all Eshell buffers.
    (eshell-syntax-highlighting-global-mode 1))

  ;; Add z to eshell.
  ;; Jumps to most recently visited directories.
  (use-package eshell-z)
  
(use-package eshell-up
  :commands eshell-up eshell-up-peek)

(setenv "PAGER" "cat")
(use-package pcmpl-args)


;;;;; EAT (Emulate a terminal)
(use-package eat
  ;; :after eshell
  :custom
  (eat-term-name "xterm-256color")
  (eat-kill-buffer-on-exit t)
  ;; (keymap-global-set "f7" 'eat)
  ;; :hook (eshell-load . #'eat-eshell-visual-command-mode)
  :config
  ;; (evil-set-initial-state 'eat-mode 'emacs)
  (eat-eshell-mode 1)
  (eat-eshell-visual-command-mode)
  (setq eat-kill-buffer-on-exit t
        eat-enable-yank-to-terminal t
        eat-enable-directory-tracking t
        eat-enable-shell-command-history t
        eat-enable-shell-prompt-annotation t
        eat-term-scrollback-size nil))


(keymap-global-set "<f7>" 'eat)
;; (keymap-global-set "<f7>" 'eat)
(defun eshell-new ()
    "Open a new eshell buffer."
    (interactive)
    (let ((buf (eshell)))
      (switch-to-buffer (other-buffer buf))
      (switch-to-buffer-other-window buf)))

;; (add-hook 'emacs-startup-hook 'eshell)


;; (kill-buffer "*Messages*")

(use-package centaur-tabs
  :demand
  :init
  (setq centaur-tabs-enable-key-bindings t)
  :config
   (setq centaur-tabs-style "bar"
        centaur-tabs-height 32
        centaur-tabs-set-icons t
        ;; centaur-tabs-show-new-tab-button t
        ;; centaur-tabs-set-modified-marker t
        ;; centaur-tabs-show-navigation-buttons t
        ;; centaur-tabs-set-bar 'under
        centaur-tabs-show-count nil
        ;; x-underline-at-descent-line t
        centaur-tabs-left-edge-margin nil)
   (centaur-tabs-mode t)
  :hook
  (dired-mode . centaur-tabs-local-mode)
  (slime-repl-mode . centaur-tabs-local-mode)
  (eshell-mode . centaur-tabs-local-mode)
  :bind
  ("C-<iso-lefttab>" . centaur-tabs-backward)
  ("C-<tab>" . centaur-tabs-forward)
  ("C-M-]" . centaur-tabs--create-new-tab))



(use-package which-key
  :init
    (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
	  which-key-sort-order #'which-key-key-order-alpha
	  which-key-allow-imprecise-window-fit nil
	  which-key-sort-uppercase-first nil
	  which-key-add-column-padding 1
	  which-key-max-display-columns nil
	  which-key-min-display-lines 6
	  which-key-side-window-slot -10
	  which-key-side-window-max-height 0.25
	  which-key-idle-delay 0.8
	  which-key-max-description-length 25
	  which-key-allow-imprecise-window-fit nil
	  which-key-separator " → " ))


;;(setq byte-compile-warnings '((not cl-functions)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eldoc-documentation-functions nil t nil "Customized with use-package lsp-mode")
 '(eshell-output-filter-functions nil)
 '(package-selected-packages
   '(yasnippet magit hide-mode-line company-irony avy-embark-collect dired-preview nerd-icons-ivy-rich all-the-icons-ivy ivy helm rainbow-delimiters emojify all-the-icons pdf-view-restore pdf-tools doom-modeline doom-themes multiple-cursors multi-mode evil-nerd-commenter)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
