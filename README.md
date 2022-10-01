# Bluebonnet Data Fellowship - Summer 2022

In 2022, I completed a data fellowship with Bluebonnet Data, working on Mike Collier's 2022 campaign for Lieutenant Governor of Texas. During my fellowship, I streamlined donation-seeking tasks for finance staff by developing two Shiny applications in R. These apps are quite similar to one another, are relatively simple, and **can be easily modified for other needs** where non-technical folks would like to quickly join two datasets.

My apps execute an inner join, which returns only the rows that are common to both datasets. File uploads are limited to CSV format, and the file output is also a CSV. The apps also utilize a preview of the output in a DT (DataTables) interface, through which the user can view all of the data output by clicking through each "page," without being overwhelmed with a huge spreadsheet all at once. The DT interface also allows the user to quickly sort, filter, or search the data output.
