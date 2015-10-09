### Getting Started

#### Introduction

This **R** Shiny web application compares downscaled outputs from CMIP3
and CMIP5 global climate models (GCMs) in a variety of ways. Downscaled
observation-based historical data from the Climatological Research Unit
(CRU 3.2) can be included in comparisons as well. Five general plot
types are available: time series plots (not time series analysis),
scatter plots, heat maps, various plots designed more specifically to
highlight variability, and distributional plots. Below you can find more
information regarding the data in this app, and how to manipulate and
graph it.

#### Explore Simpler Apps First (if you need to)

If you are not familiar with
<a href="http://shiny.rstudio.com/" target="_blank">Shiny</a> by
RStudio, it is *highly* advised that you first get acquainted with basic
**R** Shiny web applications for data analysis and visualization! You
don't need to learn how to make them, but this app certainly shouldn't
be the first one you use. But I'm a statistician; I like to urge
caution. So you may take that suggestion lightly. Another likely
possibility is that you are a colleague working in climate science who
is well-versed in climate modeling and the types of data contained in
this app, in which case you may be more at home just poking around the
app until you figure things out. This app is not for teaching purposes,
so terms like `SRES A1B` or `RCP 6.0` which may seem alien to people not
working with climate models are not expanded upon in any way.

If you are an **R** user and have not explored Shiny, here is a
<a href="http://shiny.rstudio.com/tutorial/" target="_blank">tutorial</a>
if you wish to experiment with making your own apps. They are fun and as
simple as you want them to be. If you already are comfortable with
**R**, you will have no problem. Excellent collections of **R** Shiny
web application examples to play around with can be found in RStudio's
<a href="http://shiny.rstudio.com/gallery/" target="_blank">Gallery</a>
and at <a href="http://www.showmeshiny.com/" target="_blank">Show Me
Shiny</a>. I suggest checking out many apps ranging from simple to
complex so that you can get a sense for how they operate as well as a
range of approaches people take that result in somewhat stylistically
and functionally different apps. This will also give you a sense for how
relatively complex this particular app is.

This app is quite complex. There are two ways to learn how to use it
properly and successfully. One is the brute force method. You can click
on every button in every conceivable permutation until you figure out
what is going on. The preferred method is to read the documentation. You
are here. Good. Continue.

### Audience

The primary audience for this app is myself. I use apps like this one to
enhance my data QA/QC tasks at SNAP as well as to support various
projects. It is first and foremost a convenient workflow-enhancing tool
made specific to my needs.

The secondary audience consists of other **R** Shiny users who are
interested in exploring and developing similar apps. I enjoy sharing my
work, the code is freely available, and networking with other useRs is
fun.

Mandatory caveats: I do not have time to teach you how to make apps. Nor
will you be able to swap your data sets for mine and have this app work
for you. It is far too complex to use so directly as a template, but
various bits of code you may find useful in your own contexts.

This is to say, if you want an app "just like this," it will not happen
overnight no matter how much you borrow from this app. Even if I could
write the code for this app without any planning, revision, or
refactoring, just straight through as a stream-of-consciousness exercise
in one sitting, it would still take quite some time to write it all out.
And that doesn't even begin to get into the code written to parse and
prep large amounts of data, which the app (among other projects) makes
use of. In fact, even the help documentation verbosity that follows, I
needed to write just to recall all of what I had done here.

The tertiary audience would be other colleagues which do not use **R**
but happen to be very interested in climate models and climate change in
the Arctic.

The quaternary audience would be the general public. I like to make apps
that are simple, easy to use, and convey a straightforward message that
does not require esoteric knowledge or the specialized interpretation
skills of a statistician-priest. This app is not one of them. It was
never meant to be. I'd prefer not to mention this fourth tier audience
at all except that I don't want to give the impression of complete
neglect. But ultimately, this app was made to assist my own complex and
data-heavy workflow. It can't be all things.

### Exploratory Data Analysis

The plots available in the app allow for an in-depth graphical analysis
of the included downscaled climate model outputs and CRU data.
Nevertheless, they provide an exploratory as opposed to confirmatory
analysis of the data. This is not to take away from their value. Much
can be gleaned from the wide range of customizable plots which can be
produced. In fact, any confirmatory data analysis should be preceded by
exploratory data analysis. This is just to say that no inferences are
inherent in the graphs. There is no statistical modelling being
performed. It is strictly a descriptive analysis; a visual (and tabular)
representation of the data - ignoring for the moment that the GCMs
include projected model outputs out to year 2100 (or that the earlier
years of CRU data over Alaska also have increasing uncertainty), but
that has nothing to do with what this app does with the data provided to
it.

### App Layout

This is not your grandma's **R** Shiny app. So let's start simple.

#### Navigation Bar

The navigation bar at the top has the typical `Home` tab, followed by a
tab for each type of plot available in the app, labeled `Time Series`,
`Scatter Plot`, `Heat Map`, and `Variability`, `Spatial Distributions`,
and finally an `About` tab. The tabs which have to do with the actual
graphical EDA are split into left and right panels. Data selection and
plot formatting occurs on the left. Graphs and tables appear on the
right.

#### Data Selection Panel

The data selection panel appears in the top left corner under the
navigation bar. But there is no reason for it to appear on the `Home`
tab, so make sure to navigate over to `Time Series` for example and then
it will become available. By default the panel is open on app launch
with the data selection checkbox checked. This reveals a number of
options. Until data selection is completed, there is nothing else to
display, no plot options panel, and of course, no plots or tables.

#### Plot Options Panel

The plot options panel appears directly beneath the data selection
panel. Similar to the data selection panel, it is visible only when
relevant. You must be on a plot tab in the navigation bar. It also does
not appear below the data selection panel if data selection has not been
completed. When displayed, the plot options panel offers a number of
powerful options for organizing the data in a plot various ways such as
grouping and faceting, as well as basic formatting options like color,
transparency, and font size.

#### Graphs and Tables

Graphs and tables appear on the right for any plot tab. Tables appear
first. Tables are ready for display as soon as data selection occurs,
even though plot options have not been set yet by the user. Once plot
options are set and a plot is generated, the plot will appear at the top
of the right panel, bumping any table further below.
