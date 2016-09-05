module.exports = function (grunt) {
  grunt.initConfig({
    aws: grunt.file.readJSON('aws-keys.json'),
    concat: {
      'dist/css/style.css': ['bower_components/font-awesome/css/font-awesome.css', 'css/reset.css', 'css/style.css']
    },
    htmlmin: {
      dist: {
        options: {
          collapseWhitespace: true
        },
        files: {
          'dist/index.html': 'index.html'
        }
      }
    },
    cssmin: {
      'dist/css/style.css': 'dist/css/style.css'
    },
    copy: {
      main: {
        src: ['index.html', 'robots.txt'],
        dest: 'dist/'
      },
      fonts: {
        files: [
          {
            expand: true,
            cwd: 'bower_components/font-awesome/fonts/',
            src: ['**'],
            dest: 'dist/fonts/'
          }
        ]
      }
    },
    watch: {
      main: {
        files: ['index.html', 'robots.txt'],
        tasks: ['copy:main']
      },
      css: {
        files: ['css/**/*'],
        tasks: ['concat']
      }
    },
    connect: {
      server: {
        options: {
          port: 8000,
          base: 'dist',
          keepalive: true,
          debug: true,
          open: true
        }
      }
    },
    concurrent: {
      dev: {
        tasks: ['watch', 'connect'],
        options: {
          logConcurrentOutput: true
        }
      }
    },
    aws_s3: {
      options: {
        accessKeyId: '<%= aws.AWSAccessKeyId %>',
        secretAccessKey: '<%= aws.AWSSecretKey %>',
        region: 'sa-east-1'
      },
      prod: {
        options: {
          bucket: 'regissoares.com',
          differential: true
        },
        files: [
          {
            expand: true,
            cwd: 'dist/',
            src: ['**'],
            dest: '/'
          }
        ]
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-htmlmin');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-concurrent');
  grunt.loadNpmTasks('grunt-aws-s3');

  grunt.registerTask('build', ['concat', 'htmlmin', 'cssmin', 'copy']);
  grunt.registerTask('build:dev', ['concat', 'copy']);
  grunt.registerTask('publish', ['build', 'aws_s3']);
  grunt.registerTask('default', ['build:dev', 'concurrent:dev']);
};
