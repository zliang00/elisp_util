;; ●方法その１
;;
;; 以下を .emacs に書きます。
;; C-x C-f と C-x C-s が SJIS DOS 用に上書きされます。
;; この方法が一番ご希望に沿っていると思います。

(defadvice find-file (around coding-system activate compile)
           "read file in sjis-dos"
           (let ((coding-system-for-read 'sjis-dos))
             ad-do-it))
(ad-activate 'find-file)

(defadvice save-buffer (around coding-system activate compile)
           "save file in sjis-dos"
           (let ((coding-system-for-write 'sjis-dos))
             ad-do-it))
(ad-activate 'save-buffer)

;; ●方法その２
;;
;; 元の関数の動作が残せるので、
;; 私はこちらを使っています。
;; 以下を .emacs に書きます。
;; C-x a s で SJIS DOS でファイルを開きます。

(defun find-file-sjis nil
  "read/write file in sjis-dos"
  (interactive)
  (let ((coding-system-for-read 'sjis-dos)
        (coding-system-for-write 'sjis-dos))
    (call-interactively 'find-file)))
(global-set-key "¥C-xas" 'find-file-sjis)

;; 保存時はいちいち C-x RET f で文字コード指定をします。

;; ●方法その３
;;
;; ファイルの先頭に書いてもよければ、以下を書いてしまいます。
;; 一度 SJIS DOS にしてしまえば後は楽です。
;;
;; -*- coding:sjis-dos -*-
;;
