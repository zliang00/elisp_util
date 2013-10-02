;; Red Hat Linux default .emacs initialization file

;; Are we running XEmacs or Emacs?
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; Turn on font-lock mode for Emacs
(cond ((not running-xemacs)
       (global-font-lock-mode t)
))

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)
;; Enable wheelmouse support by default
(if (not running-xemacs)
    (require 'mwheel) ; Emacs
  (mwheel-install) ; XEmacs
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;     .emacs file
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq inhibit-startup-message t)                  ;
(setq vip-inhibit-startup-message t)              ;
(setq truncate-partial-width-windows t)           ;
(setq default-truncate-lines nil)                 ;
(setq auto-save-default t)                        ;

(setq delete-auto-save-files t)                   ;
(setq scroll-step 1)                              ;
(setq default-major-mode 'lisp-interaction-mode)  ;
(setq initial-major-mode 'lisp-interaction-mode)  ;
(setq visible-bell t)                             ;
(setq comment-column 50)                          ;
;;(set-comment-column 50)                         ;

;;(set-screen-height 42)
;;(set-screen-width 80)

;;; Load File
(require 'cl)                                     ; load CommonLisp like Lib
;;(require 'un-define)                            ; load Mule-UCS

;;; Key binding
(global-set-key "\e\e" 'eval-expression)          ;
(global-set-key "\C-xf" 'set-buffer-file-coding-system)
(global-set-key "\C-xal" 'goto-line)
(global-set-key "\C-x52" 'keyboard-quit)          ; ƒL[‘€ì‚ð–³Œø‚É‚·‚é
(defun set-buffer-eucjp nil
  (interactive)
  (set-buffer-process-coding-system 'euc-jp-unix 'euc-jp-unix)
  (message "set-buffer-coding-system euc-jp-unix done"))
(global-set-key "\C-xap" 'set-buffer-eucjp)

;;; Others
(put 'eval-expression 'disabled nil)
(put 'narrow-to-page 'disabled nil)               ;
(put 'narrow-to-region 'disabled nil)             ;
(put 'upcase-region 'disabled nil)                ;
(put 'downcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
;;(setq display-time-day-and-date t)              ;
;;(command-execute 'display-time)                 ;
(line-number-mode t)
(column-number-mode t)

;;(set-language-environment 'Chinese-GB)
;;(setq default-input-method "chinese-py-punct")
(set-language-environment 'Japanese)
(setq default-input-method "japanese")

(setq default-buffer-file-coding-system 'japanese-iso-8bit-unix)

(set-buffer-file-coding-system 'japanese-iso-8bit-unix)
;; ;;(set-buffer-file-coding-system 'euc-japan-unix)
(setq default-file-name-coding-system 'japanese-iso-8bit-unix)
(setq default-keyboard-coding-system 'japanese-iso-8bit-unix)
;; ;;(set-keyboard-coding-system 'euc-japan-unix)
;; ;;(set-keyboard-coding-system 'japanese-iso-8bit-with-esc)
(set-next-selection-coding-system 'euc-japan-unix)
(set-selection-coding-system 'euc-japan-unix)
(setq default-process-coding-system 'japanese-iso-8bit-unix)
(setq default-terminal-coding-system 'japanese-iso-8bit-unix)
;;(set-terminal-coding-system 'euc-japan-unix)

(when running-xemacs
  (set-background-color "white")
  (set-foreground-color "#004400")
  (set-cursor-color "#004400"))

;; .pl => perl-mode etc.
(setq auto-mode-alist
      (remove '("\\.pl\\'" . prolog-mode) auto-mode-alist))
(setq auto-mode-alist
      (append  '( ;;("\.rule$" . lisp-mode) ; rule -> lisp mode
                 ("\.txt$"  . text-mode) ; txt  -> text mode
                 ("\.pl$"   . perl-mode) ; pl perl pm -> perl mode
                 ("\.pm$"   . perl-mode) ;
                 ("\.perl$" . perl-mode) ;
                 ("\.cgi$"  . perl-mode) ; cgi -> perl mode
                 ("\.js$"   . c++-mode)  ; js  -> c++ mode
                 )
               auto-mode-alist))

(load-file (format "%s/%s" (getenv "HOME") "file-open.el"))
(load-file (format "%s/%s" (getenv "HOME") "emacs.el"))

(add-hook  'c-mode-common-hook
           #'(lambda ()
               (setq comment-column 50)
               (local-set-key "\C-c\C-b" 'kill-all-buffers)
               ))

;; EOF ;;
