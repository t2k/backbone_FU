# modular template loading
define (require) ->
    layout:     require "text!apps/upload/show/templates/layout.htm"
    title:      require "text!apps/upload/show/templates/title.htm"
    options:    require "text!apps/upload/show/templates/options.htm"