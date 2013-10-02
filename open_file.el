;;-*- coding:utf8;mode:lisp -*-
(defun find-file-utf8 ()
  (interactive)
  (let ((coding-system-for-read 'utf-8-unix)
        (coding-system-for-write 'utf-8-unix))
    (call-interactively 'find-file)))

(defun find-file-eucjp ()
  (interactive)
  (let ((coding-system-for-read 'euc-jp)
        (coding-system-for-write 'euc-jp))
    (call-interactively 'find-file)))

(defun find-file-sjis ()
  (interactive)
  (let ((coding-system-for-read 'sjis-unix)
        (coding-system-for-write 'sjis-unix))
    (call-interactively 'find-file)))

(defun find-file-jis ()
  (interactive)
  (let ((coding-system-for-read 'iso-2022-jp)
        (coding-system-for-write 'iso-2022-jp))
   (call-interactively 'find-file)))

(defun set-process-euc nil
  (interactive)
  (set-buffer-process-coding-system 'euc-jp 'euc-jp)
  (message "set process-code in euc-jp ... done"))

(global-set-key "\C-xau" 'find-file-utf8)
;;(global-set-key "\C-xag" 'find-file-gb)
;;(global-set-key "\C-xab" 'find-file-big5)
;;(global-set-key "\C-xak" 'find-file-kr)
(global-set-key "\C-xae" 'find-file-eucjp)
(global-set-key "\C-xas" 'find-file-sjis)
(global-set-key "\C-xaj" 'find-file-jis)
(global-set-key "\C-xap" 'set-process-euc)
