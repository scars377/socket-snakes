webpack = require 'webpack'
path = require 'path'



config =
	plugins: []
	context: path.resolve 'src' #absolute
	entry:
		app: ['app.coffee']

	output:
		path: path.resolve 'dist' #absolute
		filename: '[name].js' #must NOT be absolute






###
██    ██ ███████ ███    ██ ██████   ██████  ██████  ███████
██    ██ ██      ████   ██ ██   ██ ██    ██ ██   ██ ██
██    ██ █████   ██ ██  ██ ██   ██ ██    ██ ██████  ███████
 ██  ██  ██      ██  ██ ██ ██   ██ ██    ██ ██   ██      ██
  ████   ███████ ██   ████ ██████   ██████  ██   ██ ███████
###
externals =
#	package-name : Global Class
	'jquery'     : '$'
	'react'      : 'React'
	'react-dom'  : 'ReactDOM'

useCDN = true
if useCDN
	# remember to set cdn url in html
	config.externals = externals

else
	vendors = []
	provides = {}
	for k,v of externals
		vendors.push k
		provides[v] = k

	config.entry.vendors = vendors
	config.plugins.push(
		new webpack.optimize.CommonsChunkPlugin('vendors','assets/js/vendors.js')
		new webpack.ProvidePlugin(provides)
	)








###
██████  ███████ ██    ██ ███████ ███████ ██████  ██    ██ ███████ ██████
██   ██ ██      ██    ██ ██      ██      ██   ██ ██    ██ ██      ██   ██
██   ██ █████   ██    ██ ███████ █████   ██████  ██    ██ █████   ██████
██   ██ ██       ██  ██       ██ ██      ██   ██  ██  ██  ██      ██   ██
██████  ███████   ████   ███████ ███████ ██   ██   ████   ███████ ██   ██
###
config.devServer =
	stats:
		colors: true
		hash:         false # add the hash of the compilation
		version:      false # add webpack version information
		timings:      true  # add timing information
		assets:       true  # add assets information
		chunks:       false # add chunk information
		chunkModules: false # add built modules information to chunk information
		modules:      false # add built modules information
		cached:       false # add also information about cached (not built) modules
		reasons:      false # add information about the reasons why modules are included
		source:       false # add the source code of modules
		errorDetails: true  # add details to errors (like resolving log)
		chunkOrigins: false # add the origins of chunks and chunk merging info



###
██████  ███████ ███████  ██████  ██     ██    ██ ███████
██   ██ ██      ██      ██    ██ ██     ██    ██ ██
██████  █████   ███████ ██    ██ ██     ██    ██ █████
██   ██ ██           ██ ██    ██ ██      ██  ██  ██
██   ██ ███████ ███████  ██████  ███████  ████   ███████
###
config.resolve =
	root: [
		path.resolve 'src/assets'
		path.resolve 'src'
		path.resolve 'node_modules'
	]
	extensions: [
		''
		'.js'
		'.coffee'
	]





###
██       ██████   █████  ██████  ███████ ██████  ███████
██      ██    ██ ██   ██ ██   ██ ██      ██   ██ ██
██      ██    ██ ███████ ██   ██ █████   ██████  ███████
██      ██    ██ ██   ██ ██   ██ ██      ██   ██      ██
███████  ██████  ██   ██ ██████  ███████ ██   ██ ███████
###

config.resolveLoader =
	root: path.resolve 'node_modules'

config.module =
	loaders: [
		{
			test: /\.coffee$/
			loader: 'coffee'
			include: path.resolve 'src'
		}, {
			test: /\.scss$/
			loaders: [
				'file?name=[name].css'
				'postcss'
				'sass'
			]
			include: path.resolve 'src'
		},{
			test: /\.jade$/
			loader: 'file?name=[name].html!jade-html?pretty'
			include: path.resolve 'src'
		}, {
			# test: /\.(jpe?g|png|gif|svg)$/i
			loader: 'url?limit=10000&name=assets/img/[name].[ext]'
			include: path.resolve 'src/assets/img'
		}
	]


# https://github.com/ai/browserslist#queries
browsers = ['last 2 versions']
config.postcss = -> [
	require('autoprefixer') {browsers}
	require('doiuse') {browsers}
]


module.exports = config
