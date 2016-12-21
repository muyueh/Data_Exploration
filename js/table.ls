_ = require "prelude-ls"

data = $data
container = '$container'

cellStyle = ->
	it
		.style {
			"width": "100px"
			"border": "2px solid white"
		}

d3.select container
	.select "table"
	.remove!


table = d3.select container
	.append "table"


table
	.append "thead"
	.append 'tr'
	.selectAll "td"
	.data (data[0] |> _.Obj.keys)
	.enter!
	.append "td"
	.text -> it
	.call cellStyle

table
	.append "tbody"
	.selectAll "tr"
	.data data
	.enter!
	.append "tr"
	.selectAll "td"
	.data -> it |> _.Obj.values
	.enter!
	.append "td"
	.attr {
		"class": (it, i)-> "col col-" + i
	}
	.call cellStyle
	.text -> it



fontColor = (color)->
	hsl = color |> d3.hsl
	if hsl.l < 0.7 then return "white" else return "black"


paintColumn = ->
	setting = {}
	setting.color = colorbrewer["RdYlBu"]["9"]
	setting.colClass = null
	setting.scale = 'quantize'
	setting.format = d3.format "0,000"

	build = ->
		if not setting.colClass then return

		setting.color |> _.map(-> it |> fontColor)

		data = table.selectAll setting.colClass .data!

		if setting.scale is 'quantize'
			scale = d3.scale.quantize!
				.domain d3.extent data
				.range setting.color
		else if setting.scale is 'quantile'
			scale = d3.scale.quantize!
				.domain data
				.range setting.color
		else
			"not supported scale" |> console.log 
			return 
			
		table
			.selectAll setting.colClass
			.style {
				"background-color": -> it |> scale
				"text-align": "right"
				"margin-right": "5px"
				"color": -> it |> scale |> fontColor
			}
			.text -> it |> setting.format


	for let it of setting
		build[it] = (v)->
			if arguments.length is 0
				return setting[it]
			else 
				setting[it] := v
				build

	build




### this will range together
# do (paintColumn!.colClass ".col-2,.col-3" )

### this will range seperately
# do (paintColumn!.colClass ".col-0" )
# do (paintColumn!.colClass ".col-2" )
# do (paintColumn!.colClass ".col-4" )


