module.exports = function (grunt) {
  grunt.initConfig({
    aws: grunt.file.readJSON('aws-keys.json'),
    concat: {
      'dist/css/style.css': ['bower_components/font-awesome/css/font-awesome.css', 'css/reset.css', 'css/style.css']
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
    aws_s3: {
      options: {
        accessKeyId: '<%= aws.AWSAccessKeyId %>',
        secretAccessKey: '<%= aws.AWSSecretKey %>',
        region: 'sa-east-1'
      },
      prod: {
        options: {
          bucket: 'regissoares.com',
          differential: false
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
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-aws-s3');

  grunt.registerTask('default', ['concat', 'copy']);
  grunt.registerTask('build', ['concat', 'cssmin', 'copy']);
  grunt.registerTask('publish', ['build', 'aws_s3']);
};
