(global-set-key "\C-xp"    'other-window-prev)
(global-set-key "\C-c\C-t" 'toggle-debug)
(global-set-key "\C-c\C-p" 'current-place)
(global-set-key "\C-c\C-e" 'evaluation)
(global-set-key "\C-ck"    'erase)
(global-set-key "\C-cm"    'comment50)
(global-set-key "\C-c\C-b" 'kill-all-buffers)
(global-set-key "\C-x42"   'split-window-3-vertically)

(defun current-place nil
  "display the position of coursol"
  (interactive)
  (let* ((current-line (1+ (count-lines (point-min) (point))))
         (all-line (1+ (count-lines (point-min) (point-max))))
         ;;(all-column (screen-width))
         (all-column (frame-width))
         (page-current (/ current-line 59))
         (page-current-line (% current-line 59))
         (page-all (/ all-line 59))
         (page-all-line (% all-line 59)))
    (when (zerop page-current-line)
      (setq page-current (1- page-current))
      (setq page-current-line 59))
    (when (zerop page-all-line )
      (setq page-all (1- page-all))
      (setq page-all-line 59))
    (message
     (format "%s/%s column  %s/%s lines {(%s + %s/59 lines)  %s + %s/59 lines}"
             (current-column) all-column  current-line all-line
             page-current page-current-line
             page-all page-all-line))))

(defun other-window-prev nil (interactive) (other-window -1))

(defun evaluation nil "eval current buffer"
  (interactive) (eval-current-buffer) (message "evaluating...done"))

(defun erase nil "clean current buffer"
  (interactive) (erase-buffer) (message "erasing buffer...done"))

(defun delete-space-end nil
  "delete spaces and tabs in end of each lines at current buffer"
  (interactive)
  (let ((cp (current-column))
        (cl (count-lines (point-min) (point))))
    (goto-char (point-max))
    (loop (end-of-line)
          (delete-horizontal-space)
          (beginning-of-line)
          (when (= 1 (point)) (return))
          (previous-line 1))
    (goto-char cp)
    (goto-line (1+ cl))
    (message "delete space...done")))

(defun kill-all-buffers nil
  "kill all buffers except '*scratch*'"
  (interactive)
  (when (yes-or-no-p "kill all buffers ? ")
    (mapcar (function kill-buffer) (buffer-list))
    (delete-other-windows (selected-window))
    (message "all buffer killing...done")))

(defun substitute-string (cl-new cl-old cl-seq)
  (let (po (len (length cl-old)))
    (while (setq po (search cl-old cl-seq))
      (setq cl-seq
            (concat (substring cl-seq 0 po)
                    cl-new
                    (substring cl-seq (+ po len)))))
    cl-seq))

(defun make-comment-start-end nil
  "make start-string and end-string for comment-out"
  (let ((front (or (substitute-string "" " " comment-start) ""))
        (end (or (substitute-string "" " " comment-end) "")))
    (when (= 1 (length front)) (setq front (concat front front)))
    (when (string= end "") (setq end front))
    (list front end)))

(defun line1 nil "insert '=' to 50 column"
  (interactive)
  (let (front end len)
    ;;  (case major-mode
    ;;    (perl-mode (setq front"##") (setq end "##"))
    ;;    (c-mode (setq front "/*") (setq end "*/"))
    ;;    (html-mode (setq front "<!--") (setq end "-->"))
    ;;    (t (setq front ";;") (setq end "==")))
    (beginning-of-line)
    (setq front (make-comment-start-end))
    (setq end (cadr front))
    (setq front (car front))
    (setq len (- 52 (length front) (length end)))
    (insert front (make-string len ?=) end "\n")))

(defun line2 nil "insert '-' to 50 column"
  (interactive)
  (let (front end len)
    ;;    (case major-mode
    ;;      (perl-mode (setq front"##") (setq end "##"))
    ;;      (c-mode (setq front "/*") (setq end "*/"))
    ;;      (html-mode (setq front "<!--") (setq end "-->"))
    ;;      (t (setq front ";;") (setq end "--")))
    (beginning-of-line)
    (setq front (make-comment-start-end))
    (setq end (cadr front))
    (setq front (car front))
    (setq len (- 52 (length front) (length end)))
    (insert front (make-string len ?-) end "\n")
    )
  )

(defun line3 nil "insert date, name and '-' to 50 column"
  (interactive)
  (let (front end len namstr)
    ;;  (case major-mode
    ;;    (perl-mode (setq front"##") (setq end "##"))
    ;;    (c-mode (setq front "/*") (setq end "*/"))
    ;;    (html-mode (setq front "<!--") (setq end "-->"))
    ;;    (t (setq front ";;") (setq end "--")))
    (beginning-of-line)
    (setq front (make-comment-start-end))
    (setq end (cadr front))
    (setq front (car front))
    (setq namstr (name-str))
    (setq len (- 52 (length front) (length end) (length namstr) 3))
    (insert front (make-string len ?-) namstr "---" end "\n")
    ))

(defun split-window-3-vertically (&optional ARG SWKP)
  "split window into three equal parts vertically
   if ARG, set top window's height ARG, other 2 windows are equal parts.
   if SWKP, keep POINT after splitting."
  (interactive)
  ;;(unless ARG (setq ARG (/ (screen-height) 3)))
  (unless ARG (setq ARG (/ (frame-height) 3)))
  (when SWKP (setq SWKP (point)))
  (delete-other-windows)
  (split-window-vertically ARG)
  (other-window 1)
  (split-window-vertically)
  (other-window -1)
  (when SWKP (goto-char SWKP)))

(defun kotonari nil
  "if same string lines continue, delete same lines.
     (need sorting before this function)"
  (interactive)
  (let ((post "") (now "") start)
    (goto-char (point-min))
    (loop
     (setq now (buffer-substring (progn (beginning-of-line) (point))
                                 (progn (end-of-line) (point))))
     (if (string= now post)
         (progn (beginning-of-line)
                (kill-line 1))
       (progn
         (setq post now)
         (when (= 1 (forward-line 1))
           (return)))))
    (message "kotonari OK!!")))

(defun seikei-man nil
  (interactive)
  (goto-char 1) 
  (replace-regexp (format ".%s%s" (char-to-string 8) (char-to-string 8)) "")
  (goto-char 1) (replace-regexp (format "_%s" (char-to-string 8)) "")
  (goto-char 1) (replace-regexp (format ".%s" (char-to-string 8)) "")
  (goto-char 1) (replace-regexp (format "%s" (char-to-string 8)) "")
  (goto-char 1))

(defun zen2han nil
  (interactive)
  (let ((now (point)))
    (replace-string "��" "a" nil 0 (point-max))
    (replace-string "�`" "A" nil 0 (point-max))
    (replace-string "��" "b" nil 0 (point-max))
    (replace-string "�a" "B" nil 0 (point-max))
    (replace-string "��" "c" nil 0 (point-max))
    (replace-string "�b" "C" nil 0 (point-max))
    (replace-string "��" "d" nil 0 (point-max))
    (replace-string "�c" "D" nil 0 (point-max))
    (replace-string "��" "e" nil 0 (point-max))
    (replace-string "�d" "E" nil 0 (point-max))
    (replace-string "��" "f" nil 0 (point-max))
    (replace-string "�e" "F" nil 0 (point-max))
    (replace-string "��" "g" nil 0 (point-max))
    (replace-string "�f" "G" nil 0 (point-max))
    (replace-string "��" "h" nil 0 (point-max))
    (replace-string "�g" "H" nil 0 (point-max))
    (replace-string "��" "i" nil 0 (point-max))
    (replace-string "�h" "I" nil 0 (point-max))
    (replace-string "��" "j" nil 0 (point-max))
    (replace-string "�i" "J" nil 0 (point-max))
    (replace-string "��" "k" nil 0 (point-max))
    (replace-string "�j" "K" nil 0 (point-max))
    (replace-string "��" "l" nil 0 (point-max))
    (replace-string "�k" "L" nil 0 (point-max))
    (replace-string "��" "m" nil 0 (point-max))
    (replace-string "�l" "M" nil 0 (point-max))
    (replace-string "��" "n" nil 0 (point-max))
    (replace-string "�m" "N" nil 0 (point-max))
    (replace-string "��" "o" nil 0 (point-max))
    (replace-string "�n" "O" nil 0 (point-max))
    (replace-string "��" "p" nil 0 (point-max))
    (replace-string "�o" "P" nil 0 (point-max))
    (replace-string "��" "q" nil 0 (point-max))
    (replace-string "�p" "Q" nil 0 (point-max))
    (replace-string "��" "r" nil 0 (point-max))
    (replace-string "�q" "R" nil 0 (point-max))
    (replace-string "��" "s" nil 0 (point-max))
    (replace-string "�r" "S" nil 0 (point-max))
    (replace-string "��" "t" nil 0 (point-max))
    (replace-string "�s" "T" nil 0 (point-max))
    (replace-string "��" "u" nil 0 (point-max))
    (replace-string "�t" "U" nil 0 (point-max))
    (replace-string "��" "v" nil 0 (point-max))
    (replace-string "�u" "V" nil 0 (point-max))
    (replace-string "��" "w" nil 0 (point-max))
    (replace-string "�v" "W" nil 0 (point-max))
    (replace-string "��" "x" nil 0 (point-max))
    (replace-string "�w" "X" nil 0 (point-max))
    (replace-string "��" "y" nil 0 (point-max))
    (replace-string "�x" "Y" nil 0 (point-max))
    (replace-string "��" "z" nil 0 (point-max))
    (replace-string "�y" "Z" nil 0 (point-max))

    (replace-string "�P" "1" nil 0 (point-max))
    (replace-string "�Q" "2" nil 0 (point-max))
    (replace-string "�R" "3" nil 0 (point-max))
    (replace-string "�S" "4" nil 0 (point-max))
    (replace-string "�T" "5" nil 0 (point-max))
    (replace-string "�U" "6" nil 0 (point-max))
    (replace-string "�V" "7" nil 0 (point-max))
    (replace-string "�W" "8" nil 0 (point-max))
    (replace-string "�X" "9" nil 0 (point-max))
    (replace-string "�O" "0" nil 0 (point-max))
    (goto-char now)
    ))

(defun sort-lines-reverse (&optional BEG END)
  "sort lines from z to a"
  (interactive)
  (if (null BEG) (setq BEG (region-beginning)))
  (if (null END) (setq END (region-end)))
  (sort-lines 't BEG END))
