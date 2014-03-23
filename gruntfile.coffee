module.exports = (grunt) ->
  grunt.initConfig

    coffee:
      compile_client:
        expand: true,
        flatten: false,
        cwd: 'coffee/client',
        src: ['**/*.coffee'],
        dest: 'build/js',
        ext: '.js'

      compile_server:
        options:
          bare: true
        expand: true,
        flatten: false,
        cwd: 'coffee/server',
        src: ['**/*.coffee'],
        dest: 'lib/',
        ext: '.js'
        
    clean:
      build:
        src: ['build/js,build/css,build/fonts']
          
    copy:
      mustache_templates:
        files: [
          (expand: true, cwd: 'coffee/client/', src: ['**/*.htm'], dest: 'build/js/')
        ]
      bootstrap_fonts:
        files:[
          (expand:true,cwd:'build/bower_components/bootstrap/dist/',src: ['fonts/*'],dest:'build/')
        ]
        
    autoprefixer:
      build:
        expand:true
        cwd:'build/css'
        src:['**/*.css']
        dest: 'build/css'

    less:
      files:
        "build/css/bootstrap.css": "build/bower_components/bootstrap/less/bootstrap.less"
        "build/css/main.css":"coffee/less/main.less"

    watch:
      coffee_server:
        files: 'coffee/server/**/*.coffee'
        tasks: ['coffee:compile_server']

      coffee_client:
        files: 'coffee/client/**/*.coffee'
        tasks: ['coffee:compile_client']

      mustache_client:
        files: 'coffee/client/**/*.htm'
        tasks: ['copy']


  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-contrib-coffee'  
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask "default", ['clean', 'copy', 'autoprefixer', 'coffee', 'watch']