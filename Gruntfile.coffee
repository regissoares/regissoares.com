mozjpeg = require "imagemin-mozjpeg"

module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-htmlmin"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-imagemin"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-aws-s3"

  grunt.initConfig
    aws: grunt.file.readJSON "aws-keys.json"
    clean: ["dist"]
    copy:
      dist:
        src: ["index.html", "robots.txt"]
        dest: "dist/"
      fonts:
        files: [
          expand: true
          cwd: "bower_components/font-awesome/fonts/"
          src: ["**"]
          dest: "dist/fonts/"
        ]
    concat: "dist/css/style.css": ["bower_components/reset-css/reset.css", "bower_components/font-awesome/css/font-awesome.css", "css/style.css"]
    htmlmin:
      dist:
        options: collapseWhitespace: true
        files: "dist/index.html": "dist/index.html"
    cssmin: "dist/css/style.css": "dist/css/style.css"
    imagemin:
      dist:
        options:
          optimizationLevel: 3
          progressive: false
          use: [mozjpeg quality: 35]
        files: "dist/img/bg.jpg": "img/bg.jpg"
    watch:
      html:
        files: ["index.html"]
        tasks: ["copy:dist"]
      css:
        files: ["css/**/*"]
        tasks: ["concat"]
      options:
        livereload: true
        nospawn: true
    connect:
      server:
        options:
          port: 3000
          hostname: "localhost"
          base: "dist"
          debug: true
          livereload: true
          open: true
    aws_s3:
      publish:
        options:
          accessKeyId: "<%= aws.AWSAccessKeyId %>"
          secretAccessKey: "<%= aws.AWSSecretKey %>"
          region: "sa-east-1"
          bucket: "regissoares.com.br"
          differential: true
        files: [
          expand: true
          cwd: "dist/"
          src: ["**"]
          dest: "/"
        ]

  grunt.registerTask "build", ["clean", "copy", "concat", "imagemin"]
  grunt.registerTask "build:prod", ["build", "htmlmin", "cssmin"]
  grunt.registerTask "publish", ["build:prod", "aws_s3"]
  grunt.registerTask "default", ["build", "connect", "watch"]
