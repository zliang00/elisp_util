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
    (replace-string "ÇÅ" "a" nil 0 (point-max))
    (replace-string "Ç`" "A" nil 0 (point-max))
    (replace-string "ÇÇ" "b" nil 0 (point-max))
    (replace-string "Ça" "B" nil 0 (point-max))
    (replace-string "ÇÉ" "c" nil 0 (point-max))
    (replace-string "Çb" "C" nil 0 (point-max))
    (replace-string "ÇÑ" "d" nil 0 (point-max))
    (replace-string "Çc" "D" nil 0 (point-max))
    (replace-string "ÇÖ" "e" nil 0 (point-max))
    (replace-string "Çd" "E" nil 0 (point-max))
    (replace-string "ÇÜ" "f" nil 0 (point-max))
    (replace-string "Çe" "F" nil 0 (point-max))
    (replace-string "Çá" "g" nil 0 (point-max))
    (replace-string "Çf" "G" nil 0 (point-max))
    (replace-string "Çà" "h" nil 0 (point-max))
    (replace-string "Çg" "H" nil 0 (point-max))
    (replace-string "Çâ" "i" nil 0 (point-max))
    (replace-string "Çh" "I" nil 0 (point-max))
    (replace-string "Çä" "j" nil 0 (point-max))
    (replace-string "Çi" "J" nil 0 (point-max))
    (replace-string "Çã" "k" nil 0 (point-max))
    (replace-string "Çj" "K" nil 0 (point-max))
    (replace-string "Çå" "l" nil 0 (point-max))
    (replace-string "Çk" "L" nil 0 (point-max))
    (replace-string "Çç" "m" nil 0 (point-max))
    (replace-string "Çl" "M" nil 0 (point-max))
    (replace-string "Çé" "n" nil 0 (point-max))
    (replace-string "Çm" "N" nil 0 (point-max))
    (replace-string "Çè" "o" nil 0 (point-max))
    (replace-string "Çn" "O" nil 0 (point-max))
    (replace-string "Çê" "p" nil 0 (point-max))
    (replace-string "Ço" "P" nil 0 (point-max))
    (replace-string "Çë" "q" nil 0 (point-max))
    (replace-string "Çp" "Q" nil 0 (point-max))
    (replace-string "Çí" "r" nil 0 (point-max))
    (replace-string "Çq" "R" nil 0 (point-max))
    (replace-string "Çì" "s" nil 0 (point-max))
    (replace-string "Çr" "S" nil 0 (point-max))
    (replace-string "Çî" "t" nil 0 (point-max))
    (replace-string "Çs" "T" nil 0 (point-max))
    (replace-string "Çï" "u" nil 0 (point-max))
    (replace-string "Çt" "U" nil 0 (point-max))
    (replace-string "Çñ" "v" nil 0 (point-max))
    (replace-string "Çu" "V" nil 0 (point-max))
    (replace-string "Çó" "w" nil 0 (point-max))
    (replace-string "Çv" "W" nil 0 (point-max))
    (replace-string "Çò" "x" nil 0 (point-max))
    (replace-string "Çw" "X" nil 0 (point-max))
    (replace-string "Çô" "y" nil 0 (point-max))
    (replace-string "Çx" "Y" nil 0 (point-max))
    (replace-string "Çö" "z" nil 0 (point-max))
    (replace-string "Çy" "Z" nil 0 (point-max))

    (replace-string "ÇP" "1" nil 0 (point-max))
    (replace-string "ÇQ" "2" nil 0 (point-max))
    (replace-string "ÇR" "3" nil 0 (point-max))
    (replace-string "ÇS" "4" nil 0 (point-max))
    (replace-string "ÇT" "5" nil 0 (point-max))
    (replace-string "ÇU" "6" nil 0 (point-max))
    (replace-string "ÇV" "7" nil 0 (point-max))
    (replace-string "ÇW" "8" nil 0 (point-max))
    (replace-string "ÇX" "9" nil 0 (point-max))
    (replace-string "ÇO" "0" nil 0 (point-max))
    (goto-char now)
    ))

(defun sort-lines-reverse (&optional BEG END)
  "sort lines from z to a"
  (interactive)
  (if (null BEG) (setq BEG (region-beginning)))
  (if (null END) (setq END (region-end)))
  (sort-lines 't BEG END))
