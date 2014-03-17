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

    copy:
      main:
        files: [
          {expand: true, cwd: 'coffee/client/', src: ['**/*.htm'], dest: 'build/js/'},
        ]


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.registerTask 'default', ['coffee','copy']