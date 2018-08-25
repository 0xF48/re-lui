css = require './Style.less'
cn = require 'classnames'
{h,Component} = require 'preact'


class Bar extends Component
	constructor: (props)->
		super(props)
	getChildContext: ->
		__i_bar: true
	render: (props,state)->
		my_props = 
			className: cn(props.vert && css['bar-vert'],css['bar'],props.big && css['bar-big'],props.className)
		bar_props = Object.assign {},props,my_props

		h 'div',bar_props,props.children

module.exports = Bar