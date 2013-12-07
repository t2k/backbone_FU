# modular template loading
define (require) ->
    layout: require "text!apps/upload/show/templates/layout.htm"
    title: require "text!apps/upload/show/templates/title.htm"
    fileupload: require "text!apps/upload/show/templates/fileupload.htm"
    fuitem: require "text!apps/upload/show/templates/fuitem.htm"
    fuempty: require "text!apps/upload/show/templates/fuempty.htm"