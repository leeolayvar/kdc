# 
# # Gruntfile
#
# Our gruntfile defines the tasks that we will use to build and test this
# project. Note that this project will most likely only define `build` and
# `test` tasks, and that they canalso be accessed via `npm build` and
# `npm test`.
# 




module.exports = (grunt) ->
  grunt.initConfig
    clean:
      'build': ['build']

    coffee:
      all:
        expand: true
        cwd: './'
        dest: 'build'
        ext: '.js'
        src: [
          'index.coffee'
          'lib/**/*.coffee'
          'runtime/**/*.coffee'
          'test/**/*.coffee'
        ]

    copy:
      bin:
        expand  : true
        cwd     : './'
        src     : 'bin/kdc.js'
        dest    : 'build'
        

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  grunt.registerTask 'build', ['clean', 'coffee', 'copy']
  grunt.registerTask 'test', []
  grunt.registerTask 'prepublish', ['build', 'test']

  grunt.registerTask 'default', ['prepublish']

