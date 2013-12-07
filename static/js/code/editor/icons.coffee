# Icons are specified as:
#	key: [
#		[strokeColor, fillColor, svgPath]
#		...
#   ]
icons =
	folder: [
		['ed8', 'c92', 'M1.5,5.5v11h17v-11h-17l2-3h5l2,3z']
	]
	file: [
		['fff', '999', 'M3.5,1.5v17h13v-12l-5,-5zM11.5,1.5v5h5z']
	]
	save: [
		['47c', '03a', 'M2.5,2.5v13l2,2h13v-15z']
		['ccc', '999', 'M5.5,2.5v6h9v-6z']
		['ccc', '666', 'M6.5,12.5v5h7v-5zM8.5,14.5h1v2h-1z']
	]
	console: [
		['ddd', '000', 'M1.5,3.5v13h17v-13zM3.5,6.5l3,2l-3,2l3-2zM8.5,11.5h4z']
	]
	search: [
		['cb6', '640', 'M12,12h2.5l5,5.5l-2,2l-5.5,-5z']
		['fff', '9ac', 'M7.5,13.5c-3,0-6-2-6-6c0-3,2-6,6-6c3,0,6,2,6,6c0,3,-2,6-6,6z']
	]
	db: [
		['bcd', '567', 'M2.5,4.5c0,4,15,4,15,0c0-4-15-4-15,0v11c0,4,15,4,15,0v-11c0,4-15,4-15,0z']
	]
	add: [
		['cfc', '090', 'M7.5,7.5v-4h5v4h4v5h-4v4h-5v-4h-4v-5z']
	]
	delete: [
		['fdd', '900', 'M3.5,7l3,3l-3,3l3.5,3.5l3-3l3,3l3.5-3.5l-3-3l3-3l-3.5-3.5l-3,3l-3-3z']
	]
	minus: [
		['aaa', '444', 'M5.5,7.5l4,6l4-6l-4,1z']
	]
	plus: [
		['aaa', '444', 'M7.5,5.5l6,4l-6,4l1-4z']
	]
	empty: []

# Convert icons to SVG HTML.
for own key, paths of icons
	html = '<svg>'
	for path in paths
		html += '<path stroke="#' + path[0] + '" fill="#' + path[1] + '" d="' + path[2] + '" stroke-linejoin="round"></path>'
	html += '</svg>'
	icons[key] = html
icons.tree = icons.folder

