hp.tfColCir <- '<p style="text-align:justify">Set the number of recursive log transformations performed on the complete set of daily observations prior to assigning circle size and color.
	This is useful for discerning seasonal patterns by eye in places with very high variability in precipitation intensities, where otherwise some circles would be excesively large and others impossible to see.
	Although common practice for display purposes, is important to keep in mind the relative nature of the scale.</p>'

hp.tfCirCexMult <- '<p style="text-align:justify">For the R users among us, plotting character(pch) size, regardless of transformations, will be non-negative.
	This constant multiplier will increase all elements in the vector of cex values linearly, and any set to zero will remain zero as a result.</p>'

hp.tfColMar <- '<p style="text-align:justify">Set the number of recursive log transformations performed on the marginal distribution of daily observations prior to assigning circle color.
	Compared to the main panel of daily observations, these aggregate values may require a different number of transformations.</p>'

hp.tfColBar <- '<p style="text-align:justify">Set the number of recursive log transformations performed on the aggregate data shown in the barplots	prior to assigning bar color.
	Compared to the main panel of daily observations, these aggregate values may require a different number of transformations.</p>'

hp.htCompress <- '<p style="text-align:justify">This setting compresses the plot vertically, for the purposes of squeezing more years into the plot while limited the vertical plot dimension as sensibly as possible.
	Some effort is made to limit the effect to the main panel and barplots while allowing the marginal plots in the upper panels to remain approximately their original size.</p>'

hp.marginalPanels <- '<p style="text-align:justify">(1) Historical mean scatterplot with loess smoother curve (top left).</p>
	<p style="text-align:justify">(2) Six-month means barplot (top right panel).</p>
	<p style="text-align:justify">(3) Annual six-month totals for the periods before and after then 1st of the month on which the plot is centered (lower right).</p>
	<p style="text-align:justify">Incomplete first and last years and years defined as having too many missing values are excluded from calucation of marginal plots.
	Historical 6-month totals, the most aggregated data (top right panel), require all four panels to be plotted (all three boxes checked). The main panel of daily observations is always plotted.</p>'
