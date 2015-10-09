#### Data Selection

Select at least one climate variable, scenario, corresponding model, month, decade, and area (region or city) to plot.

##### Time Series, variability plots, and heat map

*   If multiple climate variables are selected, the data subset is truncated to the first in the list.
*   The time series and variability plots are similar.
*   The latter focuses on displaying variability in different ways, which include but are not limited to time series plots.
*   Must select unique x- and y-axis categorical variables for the heat map. Axes cover the range of factor levels of these variables.

##### Scatter plot

*   The scatter plot is bivariate, plotting temperature and precipitation against one another.
*   There are placeholders for specific variable selection, but currently only these two variables are available.

##### Distributions

*   Distributions are plotted as histograms, density curves, box plots and stripcharts. Plot type options depend on whether the x-axis variable is discrete or continuous.
*   Bootstrap sampling is restricted in the publicly available app to limit memory usage and processing time, which is why the dropdown menu offers a single fixed sample size option.

##### Time period options

*   If months or decades left blank, selection defaults to all. Select only what you want, but no need to click every factor level. Months and decades are sorted if you select any out of order.
*   Years are the intersection of the years slider and the decades list. One may suffice, unless you want partial or discontinuous decades.
*   Months can be aggregated to seasons and decades to multi-decadal periods. These options appear below the month and decade selection boxes, respectively, only if you select continuous months or decades.
*   You may choose the number of seasons or multi-decadal periods. Equal-length periods are assumed. For example, if you select four consecutive months, you can make two 2-month seasons or one 4-month season. Decades work similarly.

##### Completing data selection

*   You may subset data when minimally required selections are complete. This introduction text will vanish and a blue subset button will appear at the bottom of the data selection tab to the left.
*   After pressing the button, a progress bar will display at the top of the page. You may download data via the download button when subsetting is complete. The data selection panel will minimize and the plot options panel will appear below.

#### Plot Options

*   Plot options are based on the data in use and must be selected after subsetting the data.
*   Since plot options are based on the data subset, any changes to data selections will require generating a new data set and selecting plot options again.
*   As with the data download, you may plot in the browser or download the plot as a PDF via the respective buttons when subsetting is complete.
*   The intelligence behind the automatic plot titles and the in-panel text and its placement is limited.
Title do not always describe the data perfectly or concisely and in-panel text placement is not even within the axis limits for some plots. Both options are off by default.
