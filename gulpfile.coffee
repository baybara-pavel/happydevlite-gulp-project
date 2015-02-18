'use strict'

# var $ = require 'gulp-load-plugins'
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
sass = require 'gulp-sass'
size = require 'gulp-size'
source = require 'vinyl-source-stream'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
watch = require 'gulp-watch'
cssImport = require 'gulp-cssimport'
uncss = require 'gulp-uncss'

path = 
  build:
    html: 'build/'
    js: 'build/scripts/'
    css: 'build/styles/'
    img: 'build/images/'
    fonts: 'build/fonts/'
    cogs: 'build/cogs/'
  src:
    jade: 'src/templates/pages/*.jade'
    coffee: './src/assets/scripts/main.coffee'
    style:
      main:'./src/assets/styles/main.sass'
      folder: './src/assets/styles/'
    img: 'src/assets/images/**/*.*'
    fonts: 'src/assets/fonts/**/*.*'
    cogs: 'src/assets/cogs/**/*.*'
    tmp:
      folder: 'tmp/'
      script: 'tmp/main.js'
  watch:
    jade: 'src/templates/**/*.jade'
    coffee: 'src/assets/scripts/**/*.coffee'
    style: 'src/assets/styles/**/*.sass'
    img: 'src/assets/images/**/*.*'
    fonts: 'src/assets/fonts/**/*.*'
  clean: './build/'

server = 
  host: 'localhost'
  port: '9000'

gulp.task 'clean', ->
  del path.clean

gulp.task 'webserver', ->
  connect.server
    host: server.host
    port: server.port
    livereload: true

gulp.task 'openbrowser', ->
  opn 'http://' + server.host + ':' + server.port + '/build'

gulp.task 'jade:build', ->
  gulp.src path.src.jade
  .pipe plumber()
  .pipe jade()
  .pipe gulp.dest path.build.html
  .pipe connect.reload()

gulp.task 'coffee:build', ->
    errorCoffee = false
    gulp.src path.src.coffee
    .pipe coffee()
    .on 'error', (err) ->
      gutil.log(gutil.colors.red(err.name)+ " in plugin '" + gutil.colors.cyan(err.plugin) + "'\n"+ err)
      errorCoffee = true
      this.emit 'end'
    .pipe gulp.dest path.src.tmp.folder

gulp.task 'js:build', ->
  browserify
    bundleOptions: 
      debug: true
    entries: path.src.coffee
    extensions: ['.coffee','.js']
  .transform 'coffeeify'
  .bundle()
  .on 'error', (err) ->
      gutil.log "#{gutil.colors.red(err.name)} in plugin #{gutil.colors.cyan(err.plugin)} \n #{err}"
      errorCoffee = true
      this.emit 'end' 
  .pipe source 'all.js'
  .pipe gulp.dest path.build.js
  .pipe connect.reload()

gulp.task 'style:build', ->
  gulp.src path.src.style.main
  .pipe plumber()
    .pipe sass
      indentedSyntax: true
      sourceComments: 'map'
      includePaths : [path.src.style.folder]
    .pipe plumber()
    .pipe cssImport()
    .pipe prefixer()
    .pipe uncss
      html: ["#{path.build.html}index.html"]
    # .pipe csso()
  .pipe gulp.dest path.build.css
  .pipe gulp.dest path.build.css
  .pipe connect.reload()

gulp.task 'image:build', ->
  gulp.src path.src.img
  .pipe plumber()
  .pipe imagemin
    progressive: true
    svgoPlugins: [ { removeViewBox: false } ]
    use: [ pngquant() ]
    interlaced: true
  .pipe gulp.dest path.build.img
  .pipe connect.reload()

gulp.task 'fonts:build', ->
  gulp.src path.src.fonts
  .pipe plumber()
  .pipe gulp.dest path.build.fonts

gulp.task 'cogs:build', ->
  gulp.src path.src.cogs
  .pipe plumber()
  .pipe gulp.dest path.build.cogs

gulp.task 'build', [
  'clean'
  'jade:build'
  'js:build'
  'style:build'
  'fonts:build'
  'cogs:build'
  'image:build'
]

gulp.task 'watch', ->
  gulp.watch path.watch.jade, ['jade:build']
  gulp.watch path.watch.style, ['style:build']
  gulp.watch path.watch.coffee, ['js:build']
  gulp.watch path.watch.img, ['image:build']
  gulp.watch path.watch.fonts, ['fonts:build']
  gulp.watch path.watch.fonts, ['cogs:build']

gulp.task 'default', [
  'build'
  'webserver'
  'watch'
  'openbrowser'
]