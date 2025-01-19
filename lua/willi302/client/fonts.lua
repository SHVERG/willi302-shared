resource.AddFile( "resource/fonts/digital7.ttf" )
resource.AddFile( "resource/fonts/micra.ttf" )
resource.AddFile( "resource/fonts/routes.ttf" )
resource.AddFile( "resource/fonts/chixa.ttf" )
resource.AddFile( "resource/fonts/iskra.ttf" )
resource.AddFile( "resource/fonts/moscow-bus-1a2.ttf" )

surface.CreateFont( "micra", {
	font = "Micra",
	size = 60,
	weight = 0,
	scanlines = 1,
	antialias = true,
})
surface.CreateFont( "micra_bold", {
	font = "Micra",
	size = 60,
	weight = 1000,
	scanlines = 1,
	antialias = true,
})
surface.CreateFont( "digital", {
	font = "Digital-7",
	size = 60,
	weight = 0,
	scanlines = 1,
	antialias = true,
})
surface.CreateFont( "digital_bold", {
	font = "Digital-7",
	size = 60,
	weight = 1000,
	scanlines = 1,
	antialias = true,
})
surface.CreateFont( "Routes", {
	font = "Dance Floor Lightbulbs",
	size = 150,
	weight = 0,
	scanlines = 0,
	antialias = true,
	extended = true
})
surface.CreateFont( "Routes2", {
	font = "Chixa",
	size = 150,
	weight = 0,
	scanlines = 0,
	antialias = true,
	extended = true
})
surface.CreateFont( "Led5x7", {
	font = "Moscow bus 1a2",
	size = 150,
	weight = 0,
	scanlines = 0,
	antialias = true,
	extended = true
})
surface.CreateFont( "Led7x16", {
	font = "Iskra 16 7",
	size = 150,
	weight = 0,
	scanlines = 0,
	antialias = true,
	extended = true
})