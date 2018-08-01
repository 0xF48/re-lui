Color = require 'color'
{Component} = require 'preact'
css = require './Style.module.less'

class Style extends Component
	constructor: ->
		super()
		@white = Color('#fff')
		@black = Color('#000')
		@false = Color('#FC0020')
		@true = Color('#21FF48')
	componentWillMount: ->
		@setRef()
		@renderStyle(@props)

	getChildContext: =>
		
		__theme:
			primary: @primary
			secondary: @secondary
		
	setRef: ->
		@_head_el = document.head.querySelector('#lerp-style')
		if !@_head_el
			@_head_el = document.createElement('style')
			@_head_el.id = '#lerp-style'
			document.head.appendChild(@_head_el)		


	createPallet: (color,inv,color_factor,inv_factor)->
		color_factor = color_factor || 1
		inv_factor = inv_factor || 1

		c = {}
		c.color = [
			color.hex()
			color.mix(inv,0.2*color_factor).hex()
			color.mix(inv,0.4*color_factor).hex()
		]

		c.inv = [
			inv.mix(color,.02*inv_factor).hex()
			inv.mix(color,.04*inv_factor).hex()
			inv.mix(color,.08*inv_factor).hex()
		]

		return c


	lightenPallet: (color)=>
		c = @createPallet(color,@white,1,1.5)
		c.highlight = color.lighten(1).saturate(.85)
		c.true = color.lighten(1).mix(@true,0.7);
		c.false = color.lighten(1).mix(@false,0.7);
		return c


	darkenPallet: (color,inv)->
		c = @createPallet(color,@black,.5,4)
		c.highlight = color.darken(0.5).saturate(.85)
		c.true = color.darken(0.5).mix(@true,0.7);
		c.false = color.darken(0.5).mix(@false,0.7);
		return c


	renderStyle: (props)=>
		primary_c = Color(props.primary)
		secondary_c = Color(props.secondary)
		log primary_c
		if primary_c.isLight()
			@primary = @darkenPallet(primary_c)
		else
			@primary = @lightenPallet(primary_c)

		if secondary_c.isLight()
			@secondary = @darkenPallet(secondary_c)
		else
			@secondary = @lightenPallet(secondary_c)


		# str = "body{color:#{primary[0]};background:#{primary[5]};}"
		# str += ".#{css["secondary-b-highlight"]}{background:#{secondary.highlight};}"
		# str += ".#{css["secondary-b-error"]}{background:#{secondary.error};}"
		# str += ".#{css["secondary-c-highlight"]}{color:#{secondary.highlight};}"

		# for i in [0...6]
		# 	str += ".#{css["primary-c-"+i]}{color:#{primary[i]};}"
		# 	str += ".#{css["primary-b-"+i]}{background:#{primary[i]};}"
		# 	str += ".#{css["secondary-c-"+i]}{color:#{secondary[i]};}"
		# 	str += ".#{css["secondary-b-"+i]}{background:#{secondary[i]};}"

		# @_head_el.innerHTML = str
		
	componentWillUpdate: (props)->
		# log props.primary,@props.primary
		if @props.primary != props.primary || @props.secondary != props.secondary || @props.tertiary != props.tertiary
			@renderStyle(props)

	render: (props)->
		return props.children[0]

Style.defaultProps = 
	primary: '#18262a'
	secondary: 'whitesmoke'

module.exports = Style