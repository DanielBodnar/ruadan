module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    clean: ['./builtAssets', './public/build']

    develop:
      server:
        file: 'server.js'
        nodeArgs: ['--debug']

    coffee:
      compile:
        files: [{
          expand: true,
          cwd: './app/assets/js'
          src: ['**/*.coffee']
          dest: 'builtAssets/js'
          ext: '.js'
        }]

    copy:
      main:
        files:[
#          { expand: true, src: ['./bower_components/**/*.js'], dest: './buildAssets', filter: 'isFile'}
          { expand: false, src: ['./app/assets/js/vendor/**/*.js'], dest: './buildAssets', filter: 'isFile'}
        ]


    watch:
      scripts:
        files: ['app/**/*', 'config/**/*']
        tasks: ['build', 'develop']
        options:
          debounceDelay: 250
          nospawn: true

    requirejs:
      compile:
        options: require('./config/requirejs')

  grunt.loadNpmTasks 'grunt-requirejs'

  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-requirejs"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-develop"
  grunt.loadNpmTasks "grunt-contrib-copy"

  grunt.registerTask "build", ['clean', 'coffee', 'copy', 'requirejs']
  grunt.registerTask "default", ['build', 'develop', 'watch']


