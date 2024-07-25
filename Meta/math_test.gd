extends Node2D

var points: Array[PackedVector2Array]
var polygon_a: PackedVector2Array
var polygon_b: PackedVector2Array

func _ready() -> void:
	#polygon_a = PackedVector2Array([Vector2(100,-100), Vector2(100,100), Vector2(-100,100), Vector2(-100,-100)])
	#polygon_b = PackedVector2Array([Vector2(0,0), Vector2(-100,-200), Vector2(100,-200)])

	#polygon_a = $Polygon2D2.polygon
	#polygon_b = $Polygon2D3.polygon
	
	#polygon_a = $PolygonA.polygon
	#polygon_b = $PolygonB.polygon

	#polygon_a = Geometry.generate_arc(10, 1)
	#polygon_b = Geometry.generate_arc(10, 1)
	

	polygon_a = $PolygonA.polygon
	polygon_b = $PolygonB.polygon

	#for i in range(len(polygon_b)):
		#polygon_b[i].y -= 10
		
	
	points = Geometry.polygon_subtract_b(polygon_a.duplicate(), polygon_b.duplicate())



	$Polygon2D.polygon = points[0]


func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_colored_polygon(polygon_b, Color.BLUE)
	#draw_colored_polygon(polygon_a, Color.RED)
	for point in points:
		draw_colored_polygon(point, Color.GREEN)
	#draw_colored_polygon(points[1], Color.PINK)
