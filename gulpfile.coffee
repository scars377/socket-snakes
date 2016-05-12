gulp = require 'gulp'
$ = require('gulp-load-plugins')()




###
██ ███    ███  █████   ██████  ███████ ███    ███ ██ ███    ██
██ ████  ████ ██   ██ ██       ██      ████  ████ ██ ████   ██
██ ██ ████ ██ ███████ ██   ███ █████   ██ ████ ██ ██ ██ ██  ██
██ ██  ██  ██ ██   ██ ██    ██ ██      ██  ██  ██ ██ ██  ██ ██
██ ██      ██ ██   ██  ██████  ███████ ██      ██ ██ ██   ████
###

gulp.task 'imagemin',->
	src = 'src/assets/img-src/**/*.*'
	tar = 'src/assets/img/'

	imageminPngquant = require 'imagemin-pngquant'
	imageminMozjpeg  = require 'imagemin-mozjpeg'

	gulp.src src
		.pipe $.changed tar
		.pipe $.size {
			title: 'image src'
			showFiles:true
		}
		.pipe $.if '*.png',imageminPngquant(quality:'65-80', speed:4)()
		.pipe $.if '*.jpg',imageminMozjpeg(quality: 80)()
		.pipe gulp.dest tar
		.pipe $.size {
			title: 'image tar'
		}


gulp.task 'm',['imagemin']








###
██████  ██████   ██████  ██████  ██    ██  ██████ ████████ ██  ██████  ███    ██
██   ██ ██   ██ ██    ██ ██   ██ ██    ██ ██         ██    ██ ██    ██ ████   ██
██████  ██████  ██    ██ ██   ██ ██    ██ ██         ██    ██ ██    ██ ██ ██  ██
██      ██   ██ ██    ██ ██   ██ ██    ██ ██         ██    ██ ██    ██ ██  ██ ██
██      ██   ██  ██████  ██████   ██████   ██████    ██    ██  ██████  ██   ████
###
gulp.task 'webpack-build',(cb)->
	require 'coffee-script/register'
	webpack = require 'webpack'
	webpackConfig = require './webpack.config.coffee'

	webpackConfig.plugins.push(
		new webpack.DefinePlugin('process.env':{'NODE_ENV': '"production"'})
		new webpack.optimize.DedupePlugin()
		new webpack.optimize.UglifyJsPlugin({compress:{warnings:false}})
	)

	webpack webpackConfig,(err, stats)->
		if err? then throw new Error(err.message)
		console.log stats.toString {
			colors: true
			chunkModules:false
		}
		cb()


gulp.task 'p', ['webpack-build'],->









###
██████  ███████ ██    ██ ███████ ██       ██████  ██████
██   ██ ██      ██    ██ ██      ██      ██    ██ ██   ██
██   ██ █████   ██    ██ █████   ██      ██    ██ ██████
██   ██ ██       ██  ██  ██      ██      ██    ██ ██
██████  ███████   ████   ███████ ███████  ██████  ██
###
gulp.task 'webpack-dev-server', (cb)->
	host = 'localhost'
	port = 3000

	require 'coffee-script/register'
	webpack = require 'webpack'
	webpackDevServer = require 'webpack-dev-server'
	webpackConfig = require './webpack.config.coffee'

	webpackConfig.devtool = 'cheap-module-eval-source-map'
	for name,entry of webpackConfig.entry
		entry.push "webpack-dev-server/client?http://#{host}:#{port}"

	# hot
	webpackConfig.devServer.hot = true
	webpackConfig.plugins = [new webpack.HotModuleReplacementPlugin()]
	for name,entry of webpackConfig.entry
		entry.push 'webpack/hot/dev-server'

	new webpackDevServer(
		webpack webpackConfig
		webpackConfig.devServer
	).listen port, host



gulp.task 'default',['webpack-dev-server']
