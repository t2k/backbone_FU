# load base config before app
define [
 "globalize"
 "config/jquery/jquery"                 #custom jquery functions/plugins etc.
 "config/underscore/templatesettings"   #underscore template config
 "config/marionette/templatecache"      #marionette templatecache config
 "config/marionette/application"       #marionette application overrides
], ->