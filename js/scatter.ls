_ = require "prelude-ls"

data = $data
container = '$container'


ggl = {}

ggl.margin = {top: 10, left: 10, right: 20, bottom: 20}
ggl.w = 500 - ggl.margin.left - ggl.margin.right
ggl.h = 500 - ggl.margin.top - ggl.margin.bottom

svg = d3.select container
	.append "svg"
	.attr {
		"width": ggl.w + ggl.margin.left + ggl.margin.right
		"height": ggl.h + ggl.margin.top + ggl.margin.bottom
	}
	.append "g"
	.attr {
		"transform": "translate(" + ggl.margin.left + "," + ggl.margin.top + ")"
	}


scaleX = d3.scale.linear!
	.domain d3.extent data, -> it.x
	.range [0, ggl.w]

scaleY = d3.scale.linear!
	.domain d3.extent data, -> it.y
	.range [0, ggl.w]

svg
	.selectAll "circle"
	.data data
	.enter!
	.append "circle"
	.attr {
		"cx": -> it.x |> scaleX
		"cy": -> it.y |> scaleY
		"r": 5
	}
	.style {
		"fill": -> colorbrewer["RdPu"]["9"][~~(Math.random! * 9)]
	}



