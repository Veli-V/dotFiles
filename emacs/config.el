;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Veli-V"
      user-mail-address "vaisanenjj@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "DejaVu Sans Mono" :size 11)
(setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 11 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font Mono" :size 15 :weight 'light))
;; (setq doom-big-font (font-spec :family "DejaVu Sans mono" :size 21)
(setq doom-big-font (font-spec :family "FiraCode Nerd Font Mono" :size 21 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "sans" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

;; Remove smart parantheses
(after! smartparens
  (setq smartparens-global-mode -1))


(use-package vulpea
  :ensure t
  ;; hook into org-roam-db-autosync-mode you wish to enable
  ;; persistence of meta values (see respective section in README to
  ;; find out what meta means)
  :hook ((org-roam-db-autosync-mode . vulpea-db-autosync-enable)))

(after! org
  (after! org-roam
    (setq org-roam-directory "~/roam")
    (setq org-agenda-files (quote ("~/roam")))
    (setq calendar-week-start-day 1)
    (setq org-todo-keywords
          '((fequence "TODO(t)" "MEET(m))" "|" "DONE(d!)" "DECLINED(e@)" "SKIPPED(s@)")))
  )
)

(defun my/org-roam-capture-inbox ()
  (interactive)
  (org-roam-capture- :node (org-roam-node-create)
                     :templates '(("i" "inbox" plain "* %?"
                                  :if-new (file+head "Inbox.org" "#+title: Inbox\n")))))
(map! :leader
      :desc "capture to inbox"
      "n i" #'my/org-roam-capture-inbox)
(map! :leader
      :desc "capture to inbox"
      "a" #'org-agenda)


(setq text-quoting-style "grave")
