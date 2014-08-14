hp.tfColCir <- 'Set the number of recursive log transformations performed on the complete set of daily observations prior to assigning circle size and color.
	This is useful for discerning seasonal patterns by eye in places with very high variability in precipitation intensities, where otherwise some circles would be excessively large and others impossible to see.
	Although common practice for display purposes, is important to keep in mind the relative nature of the scale.'

hp.tfCirCexMult <- 'For the R users among us, plotting character(pch) size, regardless of transformations, will be non-negative.
	This constant multiplier will increase all elements in the vector of cex values linearly, and any set to zero will remain zero as a result.'

hp.tfColMar <- 'Set the number of recursive log transformations performed on the marginal distribution of daily observations prior to assigning circle color.
	Compared to the main panel of daily observations, these aggregate values may require a different number of transformations.'

hp.tfColBar <- 'Set the number of recursive log transformations performed on the aggregate data shown in the bar plots prior to assigning bar color.
	Compared to the main panel of daily observations, these aggregate values may require a different number of transformations.'

hp.htCompress <- 'This setting compresses the plot vertically, for the purposes of squeezing more years into the plot while limited the vertical plot dimension as sensibly as possible.
	Some effort is made to limit the effect to the main panel and bar plots while allowing the marginal plots in the upper panels to remain approximately their original size.'

hp.marginalPanels <- '(1) Historical mean scatterplot with loess smoother curve (top left).
	(2) Six-month means barplot (top right panel).
	(3) Annual six-month totals for the periods before and after then 1st of the month on which the plot is centered (lower right).
	Incomplete first and last years and years defined as having too many missing values are excluded from calculation of marginal plots.
	Historical 6-month totals, the most aggregated data (top right panel), require all four panels to be plotted (all three boxes checked). The main panel of daily observations is always plotted.'

hp.missingValues <- 'These settings determine how many missing values to permit within a single month and within an entire 12-month period, respectively.
	If the maximum number of allowable missing values per month is exceeded for even a single month, or if the maximum per year is exceeded, the entire 12-month period is excluded from any marginal calculations
	(i.e., annual and historical values). Days with missing data are shown in the main panel with a pink circle. Many days in a row will appear as a bar of overlapping circles.
	When chosen thresholds are not exceeded, missing data that may occur are not shown with a pink circle.
	Instead they are left off the plot under the premise that the user has determined there are not enough days of missing data (if any) to lead them to a misinterpretation on the plot.'
