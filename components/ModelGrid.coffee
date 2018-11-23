Color = require 'color'
{render,h,Component} = require 'preact'
Slide = require 'preact-slide'
Input = require './Input.coffee'
AlertDot = require './AlertDot.coffee'
require 'normalize.css'
css = require './ModelGrid.less'
Bar = require './Bar.coffee'
MenuTab = require './MenuTab.coffee'
Menu = require './Menu.coffee'
{MultiGrid} = require 'react-virtualized/dist/commonjs/MultiGrid'
# {CellMeasurer,CellMeasurerCache} = require 'react-virtualized/dist/commonjs/CellMeasurer'
CHAR_W = 7.8
CELL_PAD = 10
class ModelGridMenu extends Component
	constructor: (props)->
		super(props)
		@state =
			menu_backdrop: false
			selected_layout_index: 0
			selected_filter_index: 0
	
	
	mapMenuStaticsButtons: (static_method,i)=>
		h MenuTab,
			key: i
			# className: css['model-grid-menu-tab-option']
			content: h Input,
				onClick: static_method.fn?.bind(undefined,static_method)
				type: 'button'
				# btn_type: 'flat'
				label: static_method.method_label
			@props.opts.statics.map @mapMenuMethodsButtons
	
	mapMenuMethodsButtons: (doc_method,i)=>
		h MenuTab,
			key: i
			vert: yes
			# className: css['model-grid-menu-tab-option']
			content: h Input,
				onClick: doc_method.fn?.bind(undefined,doc_method)
				type: 'button'
				# btn_type: 'flat'
				label: doc_method.method_label

	mapMenuFilterButtons: (filter,i)=>
		h MenuTab,
			key: i
			content: h Input,
				# onClick: @togglePinMenu.bind(@,'layout')
				onClick: @props.onSelectFilter.bind(null,filter)
				type: 'button'
				label: filter.label

	mapMenuLayoutButtons: (layout,i)=>
		h MenuTab,
			key: i
			# onClick: @togglePinMenu.bind(@,'layout')
			content: h Input,
				invalid:yes
				onClick: @props.onSelectLayout.bind(null,layout)
				focus: if layout == @props.opts.layouts[@props.selected_layout_index] then false else undefined
				btn_type: layout == @props.opts.layouts[@props.selected_layout_index] && 'primary'
				type: 'button'
				label: layout.label + ' / ' + String(layout.keys)
					
	
	togglePinMenu: (pin_menu_name)=>
		@setState
			pin_menu_name: if @state.pin_menu_name? then null else pin_menu_name 
			menu_backdrop: !@state.menu_backdrop
	
	getPinMenuBoolean: (pin_menu_name)->
		if @state.pin_menu_name == pin_menu_name then true else undefined

	render: (props,state)->
		opts = props.opts
		data = props.data
		if opts.parent_category
			list_label = h 'div',{},
				h 'span',{},opts.parent_category
				h 'span',{className: css['model-grid-slash']},'/'
				h 'span',{},opts.label
		else
			list_label = opts.label

		selected_layout = opts.layouts[@props.selected_layout_index]
		selected_filter = opts.filters[@props.selected_filter_index]
		h Slide,
			dim: 40
			vert : no
			className: css['menu-slide']
			h Menu,
				vert: no
				max_x: window.innerWidth-17
				max_y: window.innerHeight
				hover_reveal: yes
				big: true
				h MenuTab,
					vert: yes
					content: h Input,
						type: 'button'
						btn_type: 'flat'
						i: 'menu'
					opts.statics.map @mapMenuStaticsButtons
				h MenuTab,
					content: h Input,
						type: 'button'
						btn_type: 'flat'
						i: 'search'
				h MenuTab,
					content: h Input,
						type: 'button'
						name: 'methods'
						btn_type: 'flat'
						label: list_label

			h Menu,
				vert: no
				max_x: window.innerWidth-17
				max_y: window.innerHeight
				className: css['model-grid-list-menu-right']
				big: true
				enable_backdrop: yes
				show_backdrop: @state.menu_backdrop
				force_split_left: yes
				onClickBackdrop: @togglePinMenu.bind(@,null)
				hover_reveal: yes
				render_hidden: no
				h MenuTab,
					vert: yes
					onClick: @togglePinMenu.bind(@,'layouts')
					reveal: @getPinMenuBoolean('layouts')
					content: h Input,
						# className: css['model-grid-list-layout-button']
						type: 'button'
						btn_type: 'flat'
						i: 'view_week'
						label: selected_layout.label
					opts.layouts.map @mapMenuLayoutButtons
				h MenuTab,
					vert: yes
					onClick: @togglePinMenu.bind(@,'filters')
					reveal: @getPinMenuBoolean('filters')
					content: h Input,
						type: 'button'
						btn_type: 'flat'
						i: 'filter_list'
						label: selected_filter.label
					opts.filters.map @mapMenuFilterButtons



			# h Input,
			# 	type: 'input'
			# 	name: 'methods'
			# 	btn_type: 'flat'
			# 	i: 'settings'
			# 	label: h 'div',{}
			# 		h 'span',{},'layout'
			# 		h 'span',{},'/'
			# 		h 'span',{},''
			



class ModelGridList extends Component

	componentWillMount: ->
		# @buildCellCache()
	
	buildCellCache : =>
		@_cell_cache = new CellMeasurerCache
			minWidth: 55
			fixedHeight: true
			defaultWidth: 255
			# defaultWidth: 100,
  			
			# defaultHeight: 30
			# fixedWidth: no
	
	gridRef: (el)=>
		# log el
		@_grid = el
		window.grid = el
		# log @_grid
	
	slideRef: (el)=>
		@_grid_slide = el



	
	# onGridScroll: (opt)->
		# if opt.scrollTop == 0 && opt.scrollLeft == 0
		# 	face.enableAutoUpdate()
		# 	return
		# else
		# 	face.disableAutoUpdate()
		# if @state.show_search_options
		# 	@_search._input.blur()
		# 	@setState
		# 		show_search_options: false

		# if opt.scrollTop > opt.scrollHeight - 1000 && !@props.search.max_reached && !@props.is_loading[@props.search_model]
		# 	return face.searchCollection(@props.search.model,@props.search.query,@props.search.sort_value)
	checkCell: (g_opts)=>
		log g_opts


	columnWidth: (g_opts)=>
		opts = @props.opts
		key_name = opts.layouts[@props.selected_layout_index || 0]?.keys[g_opts.index] || opts.layouts[0].keys[g_opts.index]
		key = opts.keys[key_name]
		# log key_name
		# if key.col_width
		return key.col_width
		# else
		# 	return @_cell_cache.columnWidth(g_opts)


	# {index, isScrolling, key, parent, style}
	cellRenderer: (g_opts)=>
		opts = @props.opts
		data = @props.data
		is_key = g_opts.rowIndex == 0
		key_name = opts.layouts[@props.selected_layout_index || 0]?.keys[g_opts.columnIndex] || opts.layouts[0].keys[g_opts.columnIndex]
		key = opts.keys[key_name]
		
		
		
		g_opts.style.width = key.col_width
		g_opts.style.overflow = 'hidden'
		if key.center
			g_opts.style.textAlign = 'center'

		# else
		# 	g_opts.style.width = 'auto'
		# log g_opts.style.width
		
		g_opts.style.whiteSpace = 'nowrap'
		if g_opts.rowIndex % 2 == 0
			alt_cell = true
		# if g_opts.columnIndex % 2 != 0 && g_opts.rowIndex % 2 == 0
		# 	alt_cell = true
		# if g_opts.rowIndex % 2 != 0
		# 	alt_cell = true
		
		# if g_opts.columnIndex % 2 != 0
		# 	alt_cell = false
		# 	if g_opts.rowIndex % 2 != 0
		# 		alt_cell = true
		if !is_key
			value = data[g_opts.rowIndex-1][key_name]
		
		if alt_cell
			g_opts.style.background = @context.__theme.primary.inv[1]

		
	
		if !is_key && typeof value == 'string'
			v_w = value.length * CHAR_W + CELL_PAD*2
			max_l = Math.floor( (key.col_width- CELL_PAD*2) / CHAR_W)
			if v_w > key.col_width
				value = value.substring(0,max_l-2)+'..'


		# log is_key
		if is_key
			return h 'div',
				className: css['model-grid-cell']
				style: g_opts.style
				key: g_opts.key
				key.label
		
		
		return h 'div',
			className: css['model-grid-cell']
			style: g_opts.style
			key: g_opts.key
			value
	

	
	columnCount: ->
		return 5

	# componentDidMount: ->
	# 	@forceUpdate()

	getGridKey: (props)->
		layout = props.opts.layouts[props.selected_layout_index || 0] || props.opts.layouts[0]
		filter = props.opts.filters[props.selected_filter_index]?.label || null
		(filter || 'all') + '-' + (layout.label)


	componentDidUpdate: ->
		# log @_grid
		if @getGridKey(@props) != @state.grid_key
			@state.grid_key = @getGridKey(@props)
			@_grid.recomputeGridSize()

	render: (props)->
		layout = props.opts.layouts[props.selected_layout_index]
		filter = props.opts.filters[props.selected_filter_index]?.label || null
		# log props.selected_layout_index
		opts = props.opts
		data = props.data
		grid_key = @getGridKey(props)
		if @_grid_slide
			grid = h MultiGrid,
				className: css['model-grid-list']
				ref: @gridRef
				# key: grid_key
				onScroll: @onGridScroll
				cellRenderer: @cellRenderer
				columnWidth: @columnWidth
				columnCount: layout.keys.length
				fixedColumnCount:0
				fixedRowCount:1
				height:@_grid_slide._outer.clientHeight
				rowHeight:30
				rowCount:data.length+1
				width:@_grid_slide._outer.clientWidth
		
		h Slide,
			beta: 100
			ref: @slideRef
			grid || null



class ModelGrid extends Component
	constructor: (props)->
		super(props)
		@state =
			selected_layout_index: 0
			selected_filter_index: 0
	
	onSelectLayout: (layout)=>
		@setState
			selected_layout_index: @props.opts.layouts.indexOf(layout) || 0
	
	onSelectFilter: (filter)=>
		@setState
			selected_filter_index: @props.opts.filters.indexOf(filter) || 0
	
	render: (props,state)->
		opts = props.opts
		data = props.data
		props.onSelectLayout = @onSelectLayout
		props.onSelectFilter = @onSelectFilter
		props.selected_layout_index = @state.selected_layout_index
		props.selected_filter_index = @state.selected_filter_index
		h Slide,
			vert: yes
			className: css['model-grid']
			h ModelGridMenu,props
			h ModelGridList,props




module.exports = ModelGrid