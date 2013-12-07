# modular template loading
define (require) ->
    layout: require "text!components/fu/show/templates/layout.htm"
    title: require "text!components/fu/show/templates/title.htm"
    fileupload: require "text!components/fu/show/templates/fileupload.htm"
    fuitem: require "text!components/fu/show/templates/fuitem.htm"
    fuempty: require "text!components/fu/show/templates/fuempty.htm"