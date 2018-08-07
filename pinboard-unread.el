;;; pinboard-unread.el --- View unread entries from pinboard.in
;; -*- lexical-binding: t; -*-

;; Adam Simpson <adam@adamsimpson.net>
;; Version: 0.0.1
;; Keywords: hackernews

;;; Commentary:
;; Add the pinboard.in private RSS feed to auth info under the machine name 'pinboard-rss'.

;;; Code:
(require 'url)
(require 'xml)

(defun pinboard-unread()
  "Browse pinboard unread items from Emacs."
  (interactive)
  (let* ((auth-info (auth-source-user-and-password "pinboard-rss"))
         (feed (encode-coding-string (cadr auth-info) 'utf-8)))
    (browse-url (get-text-property 0 'url
                                   (completing-read "Unread:" (with-current-buffer (url-retrieve-synchronously feed)
                                                                (mapcar (lambda(x) (list
                                                                               (propertize
                                                                                (decode-coding-string (car (cddr (car (xml-get-children x 'title)))) 'utf-8)
                                                                                'url
                                                                                (car (cddr (car (xml-get-children x 'link)))))))
                                                                        (xml-get-children (assq 'rdf:RDF (xml-parse-region url-http-end-of-headers)) 'item))))))))

(provide 'pinboard-unread)

;;; pinboard-unread.el ends here
