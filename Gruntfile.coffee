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
          'bin/**/*.coffee'
          'lib/**/*.coffee'
          'runtime/**/*.coffee'
          'test/**/*.coffee'
        ]

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'build', ['clean', 'coffee']
  grunt.registerTask 'test', ['clean', 'coffee']

  grunt.registerTask 'default', ['build']
