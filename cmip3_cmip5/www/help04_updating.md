### Updating Plots and Data

Updating plots and data can occur through several means, including
making a new plot of the same data, tabbing over to a new plot type
which will reveal a new plot options panel with varied settings
resulting in an entirely different plot, choosing whether or not to
include CRU data in a plot, or making changes in the data selection
panel after a data subset has been generated.

#### Changing Plot Options

Whether the change is superficial such as choosing a new color palette
or fundamental such as altering the grouping variable, changes generally
do not take effect in the graph itself until the user presses the
`Generate Plot` button again. I say generally because there are some
particular edge cases where a plot must immediately refresh in the
browser on changing a plotting option without need of a button push, but
it is beyond the scope of this document to describe why this can
sometimes happen.

#### Changing Data Selections

Data changes are quite simple. After the user has generated a data
subset, regardless of what they have done since, whether they have made
plots or not, *any* changes at all to *any* input in the data selection
panel will require the user to generate a new subset. Any plot, data
table, and plot options panel will vanish. This occurs immediately. The
is no waiting for the user to press the `Subset Data` button after
making changes.

There are several good reasons for this, but most are technical so I
will leave them out. However, the most important one is not technical.
It would be too easy to change an item in the data selection panel and
neglect to regenerate the data subset if one is still staring at a plot
and a data table. After all, since the data has not technically changed,
there would be no reason to erase the plot or data table- which is why
the I have the app force this change.

Leaving the plot options in place and the ability to plot can result in
plotting old data but seeing it labeled in some ways as new data. This
is bad. Also, some plot options may seem odd or inapplicable. Although,
as mentioned, various elements in the browser such as plot options are
dependent on the data, for technical reasons not all of these update
based on the data change itself. Some also update in response to data
selection inputs and cannot wait for a `Subset Data` button press
confirmation. As you will see in your use of the app, best practice is
that if you reopen the minimized data selection panel and make any
change you will clear any browser elements based on the old data.
