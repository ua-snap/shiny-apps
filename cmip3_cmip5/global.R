library(shinyIncubator)
library(shinysky)
load("external/gcm_meta.RData",envir=.GlobalEnv)
load("external/files_meta.RData",envir=.GlobalEnv)
load("external/data_CRU31.RData", envir=.GlobalEnv)
load("external/data_cities_CRU31.RData", envir=.GlobalEnv)

#### If overriding these four objects from files_meta.RData ####
if(Sys.info()["sysname"]=="Windows"){ # for local devl/testing
	region.gcm.files.path <- "Y:/Users/mfleonawicz/AR4_AR5_Comparisons/region_files_GCM"
	region.gcm.files <- list.files(region.gcm.files.path, full=T)
	city.gcm.files.path <- "Y:/Users/mfleonawicz/AR4_AR5_Comparisons/city_files_GCM"
	city.gcm.files <- list.files(city.gcm.files.path, full=T)
}
###############################################################

help_tabpanel_conditional <- conditionalPanel(
	condition=
	#"input.vars == null || (input.doms == null && input.cities == '') ||
	#( (input.cmip3scens == null || input.cmip3models == null) && (input.cmip5scens == null || input.cmip5models == null) )",
	"input.goButton == null || input.goButton == 0",
	HTML(
		"<h4>Data Selection</h4>
		<ul>
			<li>Select at least one climate variable, scenario, corresponding model, month, decade, and area (region or city) to plot.</li>
			<li>Time Series, variability plots, and heat map</li>
			<ul>
				<li>If multiple climate variables are selected, the data subset is truncated to the first in the list.</li>
				<li>The time series and variability plots are univariate.
				The heat map is bivariate but X and Y are categorical variables.
				The data, Z, is still a single variable and may consist of temperature or precipitation values but not both.</li>
			</ul>
			<li>Scatter Plot</li>
			<ul>
				<li>Must select two climate variables.</li>
				<li>If only one climate variable is selected, you may not plot. The scatter plot is bivariate.</li>
			</ul>
			<li>If months or decades left blank, selection defaults to all. Select only what you want, but no need to click every factor level.</li>
			<li>Years are the intersection of the years slider and the decades list. One may suffice, unless you want partial or discontinuous decades.</li>
			<li>You may subset data when minimally required selections are complete. This text will vanish and a blue subset button will appear.</li>
			<li>You may download data when subset is complete. The data selection panel will minimize and the plot options panel will appear below.</li>
		</ul>
		<h4>Plot Options</h4>
		<ul>
			<li>Plot options are based on the data in use and must be selected after subsetting the data.</li>
			<li>Since plot options are based on the data subset, any changes to data selections will require generating a new data set and selecting plot options again.</li>
			<li>As with the data download, you may plot in the browser or download the plot as a PDF via the respective buttons when subsetting is complete.</li>
		</ul>"
	)
)
