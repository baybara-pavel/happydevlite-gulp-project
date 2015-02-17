# 'use strict'

errorCoffee = false
# var $ = require('gulp-load-plugins')();
browserify = require 'browserify'
coffee = require 'gulp-coffee'
connect = require 'gulp-connect'
csso = require 'gulp-csso'
del = require 'del'
gulp = require 'gulp'
gutil = require 'gulp-util'
imagemin = require 'gulp-imagemin'
jade = require 'gulp-jade'
opn = require 'opn'
plumber = require 'gulp-plumber'
pngquant = require 'imagemin-pngquant'
prefixer = require 'gulp-autoprefixer'
rjs = require 'gulp-requirejs'
sass = require 'gulp-sass'
size = require 'gulp-size'
source = require 'vinyl-source-stream'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
watch = require 'gulp-watch'

path = 
  build:
    html: 'build/'
    js: 'build/scripts/'
    css: 'build/styles/'
    img: 'build/images/'
    fonts: 'build/fonts/'
  src:
    jade: 'src/templates/pages/*.jade'
    coffee: 'src/assets/scripts/*.coffee'
    style: 'src/assets/styles/main.scss'
    img: 'src/assets/images/**/*.*'
    fonts: 'src/assets/fonts/**/*.*'
    tmp: 'tmp/'
  watch:
    jade: 'src/templates/**/*.jade'
    coffee: 'src/assets/scripts/**/*.coffee'
    style: 'src/assets/styles/**/*.scss'
    img: 'src/assets/images/**/*.*'
    fonts: 'src/assets/fonts/**/*.*'
  clean: './build'

server = 
  host: 'localhost'
  port: '9000'

gulp.task 'webserver', ->
  connect.server
    host: server.host
    port: server.port
    livereload: true

gulp.task 'openbrowser', ->
  opn 'http://' + server.host + ':' + server.port + '/build'

gulp.task 'jade:build', ->
  gulp.src path.src.jade
  .pipe do plumber
  .pipe do jade
  .pipe gulp.dest path.build.html
  .pipe do connect.reload

gulp.task 'coffee:build', ->
    errorCoffee = false
    gulp.src path.src.coffee
    .pipe do coffee
    .on 'error', (err) ->
      gutil.log(gutil.colors.red(err.name)+ " in plugin '" + gutil.colors.cyan(err.plugin) + "'\n"+ err)
      errorCoffee = true
      this.emit('end');
    .pipe gulp.dest path.src.tmp

gulp.task 'js:build', ['coffee:build'], ->
  if !errorCoffee
    rjs
      baseUrl: path.src.tmp
      name: '../bower_components/almond/almond'
      include: ['main']
      insertReguire: ['main']
      out: 'all.js'
      wrap: on
    # browserify path.src.tmp + 'main.js', {debug: true}
    # .bundle
    # .pipe source 'bundle.js'
    .pipe gulp.dest path.build.js
    .pipe do connect.reload

    del path.src.tmp

gulp.task 'style:build', ->
  gulp.src path.src.style
  .pipe do plumber
  .pipe do sourcemaps.init
    .pipe do sass
    .pipe do prefixer
    .pipe do csso
  .pipe do sourcemaps.write
  .pipe gulp.dest path.build.css
  .pipe do connect.reload

gulp.task 'image:build', ->
  gulp.src path.src.img
  .pipe do plumber
  .pipe imagemin
    progressive: true
    svgoPlugins: [ { removeViewBox: false } ]
    use: [ pngquant() ]
    interlaced: true
  .pipe gulp.dest path.build.img
  .pipe do connect.reload

gulp.task 'fonts:build', ->
  gulp.src path.src.fonts
  .pipe do plumber
  .pipe gulp.dest path.build.fonts

gulp.task 'build', [
  'jade:build'
  'js:build'
  'style:build'
  'fonts:build'
  'image:build'
]

gulp.task 'watch', ->
  gulp.watch path.watch.jade, ['jade:build']
  gulp.watch path.watch.style, ['style:build']
  gulp.watch path.watch.coffee, ['js:build']
  gulp.watch path.watch.img, ['image:build']
  gulp.watch path.watch.fonts, ['fonts:build']

gulp.task 'default', [
  'build'
  'webserver'
  'watch'
  'openbrowser'
]