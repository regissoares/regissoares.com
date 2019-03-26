module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-htmlmin"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-aws-s3"

  grunt.initConfig
    aws: grunt.file.readJSON "aws-keys.json"
    concat: "dist/css/style.css": ["bower_components/font-awesome/css/font-awesome.css", "bower_components/reset-css/reset.css", "css/style.css"]
    htmlmin:
      dist:
        options: collapseWhitespace: true
        files: "dist/index.html": "dist/index.html"
    cssmin: "dist/css/style.css": "dist/css/style.css"
    copy:
      dist:
        src: ["index.html", "robots.txt", "img/**/*"]
        dest: "dist/"
      fonts:
        files: [
          expand: true
          cwd: "bower_components/font-awesome/fonts/"
          src: ["**"]
          dest: "dist/fonts/"
        ]
    clean: ["dist"]
    watch:
      html:
        files: ["index.html"]
        tasks: ["copy:dist"]
      css:
        files: ["css/**/*"]
        tasks: ["concat"]
    connect:
      server:
        options:
          port: 3000
          base: "dist"
          keepalive: true
          debug: true
          livereload: true
          open: true
    aws_s3:
      publish:
        options:
          accessKeyId: "<%= aws.AWSAccessKeyId %>"
          secretAccessKey: "<%= aws.AWSSecretKey %>"
          region: "sa-east-1"
          bucket: "regissoares.com"
          differential: true
        files: [
          expand: true
          cwd: "dist/"
          src: ["**"]
          dest: "/"
        ]

  grunt.registerTask "build", ["clean", "copy", "concat"]
  grunt.registerTask "build:prod", ["build", "htmlmin", "cssmin"]
  grunt.registerTask "publish", ["build:prod", "aws_s3"]
  grunt.registerTask "default", ["build", "connect", "watch"]
