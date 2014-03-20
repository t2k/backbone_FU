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
        src: ['build/js']
          
    copy:
      build:
        files: [
          (expand: true, cwd: 'coffee/client/', src: ['**/*.htm'], dest: 'build/js/')
        ]
        
    autoprefixer:
      build:
        expand:true
        cwd:'build/css'
        src:['**/*.css']
        dest: 'build/css'

    watch:
      coffee_server:
        files: 'coffee/server/**/*.coffee'
        tasks: ['coffee:compile_server']

      coffee_client:
        files: 'coffee/client/**/*.coffee'
        tasks: ['coffee:compile_client']

      mustache_client:
        files: 'coffee/client/**/*.htm'
        tasks: ['copy:build]



  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-contrib-coffee'  
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['copy', 'coffee', 'watch']