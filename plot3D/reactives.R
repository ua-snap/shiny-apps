# Reactive expressions

# General
d <- reactive({
	if(!is.null(input$dataset)){
		if(input$dataset=="Volcano (Maunga Whau)") x <- volcano
		if(input$dataset=="Sinc") x <- sinc.data
		if(input$dataset=="Lorenz Attractor") x <- la.data[,3]
		if(input$dataset=="Hypsometry data") x <- Hypsometry$z
	} else x <- NULL
	x
})

d.dims <- reactive({
	if(!is.null(d())){
		if(input$dataset=="Volcano (Maunga Whau)") x <- list( 1:nrow(d()), ncol(d()):1 )
		if(input$dataset=="Sinc") x <- list( seq(-2*pi,2*pi,length=nrow(d()))/10,seq(-2*pi,2*pi,length=ncol(d()))/10 )
		if(input$dataset=="Lorenz Attractor") x <- list( la.data[,1], la.data[,2] )
		if(input$dataset=="Hypsometry data") x <- list( seq(0,10*25000,length=nrow(d())), seq(10*12500,0,length=ncol(d())) )
	} else x <- NULL
	x
})

rgl.data.style <- reactive({
	if(!is.null(input$dataset)){
		if(input$dataset=="Volcano (Maunga Whau)") x <- "surface"
		if(input$dataset=="Sinc") x <- "surface"
		if(input$dataset=="Lorenz Attractor") x <- "points/lines"
		if(input$dataset=="Hypsometry data") x <- "surface"
	} else x <- NULL
	x
})

plottypes <- reactive({
	if(!is.null(input$dataset)){
		x <- if(input$dataset!="Lorenz Attractor") c("2D - contour lines","2D - image plot","3D - perspective plot","3D - ribbon","3D - histogram","3D - interactive (rgl)") else "3D - interactive (rgl)"
	} else x <- NULL
	x
})

plottypes_abb <- reactive({
	if(!is.null(input$dataset)){
		x <- if(input$dataset!="Lorenz Attractor") c("p2dCL","p2dIM","p3dPP","p3dRI","p3dHI","p3dGL") else "p3dGL"
	} else x <- NULL
	x
})

ptypeID <- reactive({
	if(!is.null(input$plottype)){
		browser()
		x <- if(length(plottypes_abb()) > 1) plottypes_abb()[match(input$plottype,plottypes())] else plottypes_abb()
	} else x <- NULL
	x
})

plotFun <- reactive({ if(!is.null(ptypeID())) getFun(ptypeID()) else NULL })

# Contour
contour_colors <- reactive({
	x <- input$contour.col
	if(!is.null(d())){
		n <- length(pretty(range(d(),finite=TRUE), contour_nlevels())) + 1
		if(x=="purple-yellow"){
			x <- colorRampPalette(c("purple","yellow"))(n)
		} else if(x=="R:Heat") { x <- heat.colors(n) } else if(x=="R:Topo") { x <- topo.colors(n) } else if(x=="R:Terrain") { x <- terrain.colors(n) } else if(x=="R:Cyan-Magenta") x <- cm.colors(n)
	}
	x
})

contour_nlevels <- reactive({ as.numeric(input$contour.nlevels) })

contour_labcex <- reactive({ as.numeric(input$contour.labcex) })

contour_lwd <- reactive({ as.numeric(input$contour.lwd) })

contour_asp <- reactive({
	if(!is.null(d())){
		x <- if(input$contour.asp=="Original scale") ncol(d())/nrow(d()) else 1
	}
	x
})

# Image
image_asp <- reactive({
	if(!is.null(d())){
		x <- if(input$image.asp=="Original scale") ncol(d())/nrow(d()) else 1
	}
	x
})

image_colors <- reactive({
	x <- input$image.col
	n <- image_nlevels() - 1
	if(x=="black-white"){
		x <- colorRampPalette(c("black","white"))(n)
		} else if(x=="purple-yellow"){
			x <- colorRampPalette(c("purple","yellow"))(n)
		} else if(x=="R:Heat") { x <- heat.colors(n) } else if(x=="R:Topo") { x <- topo.colors(n) } else if(x=="R:Terrain") { x <- terrain.colors(n) } else if(x=="R:Cyan-Magenta") x <- cm.colors(n)
	x
})

image_nlevels <- reactive({ as.numeric(input$image.nlevels) })

image_theta <- reactive({
	x <- 0
	if(!is.null(input$rasterImage) & !is.null(input$image.theta)) if(input$rasterImage) x <- as.numeric(input$image.theta)
	x
})

image_rasterImage <- reactive({
	x <- FALSE
	if(!is.null(input$rasterImage))	x <- as.logical(input$rasterImage)
	x
})

image_contour <- reactive({
	x <- FALSE
	if(!is.null(input$contour)){
		if(input$contour){
			x <- list(col=contour_colors(), NAcol=input$NAcol, nlevels=contour_nlevels(), drawlabels=input$contour.drawlabels, colkey=colkey(), labcex=contour_labcex(), lwd=contour_lwd())
		}
	}
	x
})

# Perspective
persp_colors <- reactive({
	x <- input$persp.col
	n <- image_nlevels() - 1
	if(x=="black-white"){
		x <- colorRampPalette(c("black","white"))(n)
		} else if(x=="purple-yellow"){
			x <- colorRampPalette(c("purple","yellow"))(n)
		} else if(x=="R:Heat") { x <- heat.colors(n) } else if(x=="R:Topo") { x <- topo.colors(n) } else if(x=="R:Terrain") { x <- terrain.colors(n) } else if(x=="R:Cyan-Magenta") x <- cm.colors(n)
	x
})

persp_contourside <- reactive({
	x <- c()
	if(!is.null(input$persp.contourside)){
		if(!length(input$persp.contourside)) return()
		if("Below" %in% input$persp.contourside) x <- "zmin"
		if("Above" %in% input$persp.contourside) x <- c(x,"zmax")
		if("Layered" %in% input$persp.contourside) x <-c(x,"z")
	} else x <- NULL
	x
})


persp_contour <- reactive({
	if(!is.null(persp_contourside())){
		x <- list(side=persp_contourside(), col=contour_colors(), NAcol=input$NAcol, nlevels=contour_nlevels(), drawlabels=input$contour.drawlabels, labcex=contour_labcex(), lwd=contour_lwd())
	} else x <- FALSE
	x
})

persp_imageside <- reactive({
	if(!is.null(input$persp.imageside)){
		if(!length(input$persp.imageside)) return()
		if("Below" %in% input$persp.imageside) x <- "zmin"
		if("Above" %in% input$persp.imageside) x <- "zmax"
	} else x <- NULL
	x
})

persp_image <- reactive({
	if(!is.null(persp_imageside())){
		x <- list(side=persp_imageside(), col=image_colors(), NAcol=input$NAcol, border=border(), facets=facets(), resfac=as.numeric(input$resfac))
	} else x <- FALSE
	x
})

persp_zlim <- reactive({
	if(!is.null(d()) & !is.null(adjustrelief()) & !is.null(input$persp.zlim1) & !is.null(input$persp.zlim2)){
		range.d <- range(d(),na.rm=T)
		dif <- diff(range.d)
		return(range.d + c(-1,1)*dif*(c(as.numeric(input$persp.zlim1),as.numeric(input$persp.zlim2))))
	} else NULL
})

# General, perspective and RGL
colkey <- reactive({
	if(input$colkey=="None") x <- FALSE
	if(input$colkey=="Default") x <- list(side=4, plot=TRUE, length=1, width=1, dist=0, shift=0, addlines=FALSE, col.clab=NULL, cex.clab=par("cex.lab"), side.clab=NULL, line.clab =NULL, adj.clab=NULL, font.clab=NULL)
	if(input$colkey=="Manual") x <- if(!is.null(input$colkey.side) & !is.null(input$colkey.addlines)) list(side=match(input$colkey.side,c("Bottom","Left","Top","Right")),addlines=as.logical(input$colkey.addlines)) else NULL
	x
})

clab <- reactive({
	x <- ""
	if(!is.null(colkey())) if(!is.null(input$clab)) if(input$clab) x <- "Title"
	x
})

border <- reactive({
	if(length(input$border)){
		if(input$border=="") x <- NA
		if(input$border=="White") x <- "white"
		if(input$border=="Black") x <- "black"
	} else x <- NA
	x
})

facets <- reactive({ if(input$facets=="Grid cells") TRUE else FALSE })

lighting <- reactive({
	x <- input$lighting
	if(x=="None") x <- FALSE else x <- TRUE
	x
})

bty <- reactive({
	if(input$bty=="No box") x <- "n"
	if(input$bty=="Full box") x <- "f"
	if(input$bty=="Back panels only") x <- "b"
	if(input$bty=="Panels w/ grid lines") x <- "b2"
	if(input$bty=="Gray w/ white lines") x <- "g"
	if(input$bty=="Black") x <- "bl"
	if(input$bty=="Black w/ gray lines") x <- "bl2"
	if(input$bty=="Manual") x <- "u"
	x
})

aspectratio <- reactive({
	if(input$aspectratio=="Original scale") FALSE else TRUE
})

along <- reactive({	if(input$along=="x-axis") "x" else if(input$along=="y-axis") "y" else if(input$along=="both axes") "xy" else "x" })

adjustrelief <- reactive({
	if(!is.null(input$adjustrelief)){
		x <- as.numeric(input$adjustrelief)
		if(x==0) y <- 1
		if(x<0) y <- -1/x
		if(x>0) y <- x
	} else y <- NULL
	y
})

rgladjustrelief <- reactive({
	if(!is.null(input$rgladjustrelief)){
		x <- as.numeric(input$rgladjustrelief)
		y <- 1 + x/100
	} else y <- NULL
	y
})

rglcolors <- reactive({
	if(!is.null(d()) & !is.null(rgladjustrelief())){
		x <- input$rglcol
		zlim <- range(d(),na.rm=T)
		n.default <- 31
		if(diff(zlim) %% 1 == 0) n <- zlim[2] - zlim[1] + 1 else n <- n.default
		if(x=="black-white"){
			x <- colorRampPalette(c("black","white"))(n)
		} else if(x=="purple-yellow"){
			x <- colorRampPalette(c("purple","yellow"))(n)
		} else if(x=="R:Heat") { x <- heat.colors(n) } else if(x=="R:Topo") { x <- topo.colors(n) } else if(x=="R:Terrain") { x <- terrain.colors(n) } else if(x=="R:Cyan-Magenta") x <- cm.colors(n)
		if(diff(zlim) %% 1 == 0){
			x <- x[d()-zlim[1]+1]
		} else if(is.matrix(d())) {
			x <- x[matrix(as.numeric(cut(d(),n,1:n)),nrow(d()),ncol(d()))]
		} else x <- x[as.numeric(cut(d(),n,1:n))]
	} else x <- NULL
	x
})

# Plot
doPlot <- reactive({
	if(!is.null(d()) & !is.null(adjustrelief())){
	d.new <- d()*adjustrelief()
	d.new <- d.new + min(d(),na.rm=T) - min(d.new,na.rm=T)
	f <- function(type){
		switch(type,
			p2dCL=contour2D(z=d(), col=contour_colors(), NAcol=input$NAcol, nlevels=contour_nlevels(), drawlabels=input$contour.drawlabels,
				colkey=colkey(), labcex=contour_labcex(), lwd=contour_lwd(), clab=clab(), asp=contour_asp()
			),
			p2dIM=image2D(z=d(), col=image_colors(), NAcol=input$NAcol, border=border(), facets=facets(), contour=image_contour(), 
				colkey=colkey(), resfac=as.numeric(input$resfac), clab=clab(), lighting=lighting(), shade=as.numeric(input$shade),
				ltheta=-135, lphi=0, theta=image_theta(), rasterImage=image_rasterImage(), asp=image_asp(),	add=FALSE, plot=TRUE
			),
			p3dPP=persp3D(z=d.new, col=persp_colors(), NAcol=input$NAcol, zlim=persp_zlim(), border=border(), facets=facets(), contour=persp_contour(), image=persp_image(),
				colkey=colkey(), resfac=as.numeric(input$resfac), clab=clab(), lighting=lighting(), shade=as.numeric(input$shade), ltheta=-135, lphi=0,
				theta=as.numeric(input$theta), phi=as.numeric(input$phi), rasterImage=image_rasterImage(), bty=bty(), curtain=as.logical(input$curtain), add=FALSE, plot=TRUE
			),
			p3dRI=ribbon3D(z=d.new, col=persp_colors(), NAcol=input$NAcol, zlim=persp_zlim(), border=border(), facets=facets(), contour=persp_contour(), image=persp_image(),
				colkey=colkey(), resfac=as.numeric(input$resfac), clab=clab(), lighting=lighting(), shade=as.numeric(input$shade), ltheta=-135, lphi=0,
				theta=as.numeric(input$theta), phi=as.numeric(input$phi), rasterImage=image_rasterImage(), bty=bty(), curtain=as.logical(input$curtain), along=along(),	add=FALSE, plot=TRUE
			),
			p3dHI=hist3D(z=d.new, col=persp_colors(), NAcol=input$NAcol, zlim=persp_zlim(), border=border(), facets=facets(), contour=persp_contour(), image=persp_image(),
				colkey=colkey(), resfac=as.numeric(input$resfac), clab=clab(), lighting=lighting(), shade=as.numeric(input$shade), ltheta=-135, lphi=0,
				theta=as.numeric(input$theta), phi=as.numeric(input$phi), rasterImage=image_rasterImage(), bty=bty(), curtain=as.logical(input$curtain), add=FALSE, plot=TRUE
			)
		)
	}
	} else f <- NULL
	f
})

# Reactive expression for code tab in main panel
# Ideal, but cannot do this on the server side due to a bug in the shinyAce package.
#codeTab <- reactive({
#	if(is.null(input$nlp)) return()
#	id <- gsub("nlp_", "show_", input$nlp)
#	show_list <- ls(pattern="^show_.*.R$", envir=.GlobalEnv)
#	if(id %in% show_list) x <- tabPanel(paste0("tp_",id), get(id)) else x <- NULL
#	x
#})
