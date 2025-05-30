% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vectortranslate.R
\name{oe_vectortranslate}
\alias{oe_vectortranslate}
\title{Translate a .osm.pbf file into .gpkg format}
\usage{
oe_vectortranslate(
  file_path,
  layer = "lines",
  vectortranslate_options = NULL,
  osmconf_ini = NULL,
  extra_tags = NULL,
  force_vectortranslate = FALSE,
  never_skip_vectortranslate = FALSE,
  boundary = NULL,
  boundary_type = c("spat", "clipsrc"),
  quiet = FALSE
)
}
\arguments{
\item{file_path}{Character string representing the path of the input
\code{.pbf} or \code{.osm.pbf} file.}

\item{layer}{Which \code{layer} should be read in? Typically \code{points}, \code{lines}
(the default), \code{multilinestrings}, \code{multipolygons} or \code{other_relations}. If
you specify an ad-hoc query using the argument \code{query} (see introductory
vignette and examples), then \code{\link[=oe_get]{oe_get()}} and \code{\link[=oe_read]{oe_read()}} will read the layer
specified in the query and ignore \code{layer} argument. See also
\href{https://github.com/ropensci/osmextract/issues/122}{#122}.}

\item{vectortranslate_options}{Options passed to the \code{\link[sf:gdal_utils]{sf::gdal_utils()}}
argument \code{options}. Set by default. Check details in the introductory
vignette and the help page of \code{\link[=oe_vectortranslate]{oe_vectortranslate()}}.}

\item{osmconf_ini}{The configuration file. See documentation at
\href{https://gdal.org/en/stable/drivers/vector/osm.html}{gdal.org}. Check details in the
introductory vignette and the help page of \code{\link[=oe_vectortranslate]{oe_vectortranslate()}}. Set by
default.}

\item{extra_tags}{Which additional columns, corresponding to OSM tags, should
be in the resulting dataset? \code{NULL} by default. Check the introductory
vignette and the help pages of \code{\link[=oe_vectortranslate]{oe_vectortranslate()}} and \code{\link[=oe_get_keys]{oe_get_keys()}}.
Ignored when \code{osmconf_ini} is not \code{NULL}.}

\item{force_vectortranslate}{Boolean. Force the original \code{.pbf} file to be
translated into a \code{.gpkg} file, even if a \code{.gpkg} with the same name
already exists? \code{FALSE} by default. If tags in \code{extra_tags} match data in
previously translated \code{.gpkg} files no translation occurs (see
\href{https://github.com/ropensci/osmextract/issues/173}{#173} for details).
Check the introductory vignette and the help page of
\code{\link[=oe_vectortranslate]{oe_vectortranslate()}}.}

\item{never_skip_vectortranslate}{Boolean. This is used in case the user
passed its own \code{.ini} file or vectortranslate options (since, in those
case, it's too difficult to determine if an existing \code{.gpkg} file was
generated following the same options.)}

\item{boundary}{An \code{sf}/\code{sfc}/\code{bbox} object that will be used to create a
spatial filter during the vectortranslate operations. The type of filter
can be chosen using the argument \code{boundary_type}.}

\item{boundary_type}{A character vector of length 1 specifying the type of
spatial filter. The \code{spat} filter selects only those features that
intersect a given area, while \code{clipsrc} also clips the geometries. Check
the examples and also \href{https://gdal.org/en/stable/programs/ogr2ogr.html}{here} for
more details.}

\item{quiet}{Boolean. If \code{FALSE}, the function prints informative messages.
Starting from \code{sf} version
\href{https://r-spatial.github.io/sf/news/index.html#version-0-9-6-2020-09-13}{0.9.6},
if \code{quiet} is equal to \code{FALSE}, then vectortranslate operations will
display a progress bar.}
}
\value{
Character string representing the path of the \code{.gpkg} file.
}
\description{
This function is used to translate a \code{.osm.pbf} file into \code{.gpkg} format.
The conversion is performed using
\href{https://gdal.org/en/stable/programs/ogr2ogr.html}{ogr2ogr} via the
\code{vectortranslate} utility in \code{\link[sf:gdal_utils]{sf::gdal_utils()}} . It was created following
\href{https://github.com/OSGeo/gdal/issues/2100#issuecomment-565707053}{the suggestions}
of the maintainers of GDAL. See Details and Examples to understand the basic
usage, and check the introductory vignette for more complex use-cases.
}
\details{
The new \code{.gpkg} file is created in the same directory as the input
\code{.osm.pbf} file. The translation process is performed using the
\code{vectortranslate} utility in \code{\link[sf:gdal_utils]{sf::gdal_utils()}}. This operation can be
customized in several ways modifying the parameters \code{layer}, \code{extra_tags},
\code{osmconf_ini}, \code{vectortranslate_options}, \code{boundary} and \code{boundary_type}.

The \code{.osm.pbf} files processed by GDAL are usually categorized into 5
layers, named \code{points}, \code{lines}, \code{multilinestrings}, \code{multipolygons} and
\code{other_relations}. Check the first paragraphs
\href{https://gdal.org/en/stable/drivers/vector/osm.html}{here} for more details. This
function can covert only one layer at a time, and the parameter \code{layer} is
used to specify which layer of the \code{.osm.pbf} file should be converted.
Several layers with different names can be stored in the same \code{.gpkg} file.
By default, the function will convert the \code{lines} layer (which is the most
common one according to our experience).

The arguments \code{osmconf_ini} and \code{extra_tags} are used to modify how GDAL
reads and processes a \code{.osm.pbf} file. More precisely, several operations
that GDAL performs on the input \code{.osm.pbf} file are governed by a \code{CONFIG}
file, that can be checked at the following
\href{https://github.com/OSGeo/gdal/blob/master/ogr/ogrsf_frmts/osm/data/osmconf.ini}{link}.
The basic components of OSM data are called
\href{https://wiki.openstreetmap.org/wiki/Elements}{\emph{elements}} and they are
divided into \emph{nodes}, \emph{ways} or \emph{relations}, so, for example, the code at
line 7 of that file is used to determine which \emph{ways} are assumed to be
polygons (according to the simple-feature definition of polygon) if they
are closed. Moreover, OSM data is usually described using several
\href{https://wiki.openstreetmap.org/wiki/Tags}{\emph{tags}}, i.e pairs of two items:
a key and a value. The code at lines 33, 53, 85, 103, and 121 is used to
determine, for each layer, which tags should be explicitly reported as
fields (while all the other tags are stored in the \code{other_tags} column).
The parameter \code{extra_tags} is used to determine which extra tags (i.e.
key/value pairs) should be added to the \code{.gpkg} file (other than the
default ones).

By default, the vectortranslate operations are skipped if the function
detects a file having the same path as the input file, \code{.gpkg} extension, a
layer with the same name as the parameter \code{layer} and all \code{extra_tags}. In
that case the function will simply return the path of the \code{.gpkg} file.
This behaviour can be overwritten setting \code{force_vectortranslate = TRUE}.
The vectortranslate operations are never skipped if \code{osmconf_ini},
\code{vectortranslate_options}, \code{boundary} or \code{boundary_type} arguments are not
\code{NULL}.

The parameter \code{osmconf_ini} is used to pass your own \code{CONFIG} file in case
you need more control over the GDAL operations. Check the package
introductory vignette for an example. If \code{osmconf_ini} is equal to \code{NULL}
(the default value), then the function uses the standard \code{osmconf.ini} file
defined by GDAL (but for the extra tags).

The parameter \code{vectortranslate_options} is used to control the options that
are passed to \code{ogr2ogr} via \code{\link[sf:gdal_utils]{sf::gdal_utils()}} when converting between
\code{.osm.pbf} and \code{.gpkg} formats. \code{ogr2ogr} can perform various operations
during the conversion process, such as spatial filters or SQL queries.
These operations can be tuned using the \code{vectortranslate_options} argument.
If \code{NULL} (the default value), then \code{vectortranslate_options} is set equal
to

\code{c("-f", "GPKG", "-overwrite", "-oo", paste0("CONFIG_FILE=", osmconf_ini), "-lco", "GEOMETRY_NAME=geometry", layer)}.

Explanation:
\itemize{
\item \verb{"-f", "GPKG"} says that the output format is \code{GPKG};
\item \verb{"-overwrite} is used to delete an existing layer and recreate
it empty;
\item \verb{"-oo", paste0("CONFIG_FILE=", osmconf_ini)} is used to set the
\href{https://gdal.org/en/stable/drivers/vector/osm.html#open-options}{Open Options}
for the \code{.osm.pbf} file and change the \code{CONFIG} file (in case the user
asks for any extra tag or a totally different CONFIG file);
\item \verb{"-lco", "GEOMETRY_NAME=geometry"} is used to change the
\href{https://gdal.org/en/stable/drivers/vector/gpkg.html#layer-creation-options}{layer creation options}
for the \code{.gpkg} file and modify the name of the geometry column;
\item \code{layer} indicates which layer should be converted.
}

If \code{vectortranslate_options} is not \code{NULL}, then the options \code{c("-f", "GPKG", "-overwrite", "-oo", "CONFIG_FILE=", path-to-config-file, "-lco", "GEOMETRY_NAME=geometry", layer)} are always appended unless the user
explicitly sets different default parameters for the arguments \code{-f}, \code{-oo},
\code{-lco}, and \code{layer}.

The arguments \code{boundary} and \code{boundary_type} can be used to set up a
spatial filter during the vectortranslate operations (and speed up the
process) using an \code{sf} or \code{sfc} object (\code{POLYGON} or \code{MULTIPOLYGON}). The
default arguments create a rectangular spatial filter which selects all
features that intersect the area. Setting \code{boundary_type = "clipsrc"} clips
the geometries. In both cases, the appropriate options are automatically
added to the \code{vectortranslate_options} (unless a user explicitly sets
different default options). Check Examples in \code{oe_get()} and the
introductory vignette.

See also the help page of \code{\link[sf:gdal_utils]{sf::gdal_utils()}} and
\href{https://gdal.org/en/stable/programs/ogr2ogr.html}{ogr2ogr} for more examples and
extensive documentation on all available options that can be tuned during
the vectortranslate process.
}
\examples{
# First we need to match an input zone with a .osm.pbf file
(its_match = oe_match("ITS Leeds"))

# Copy ITS file to tempdir so that the examples do not require internet
# connection. You can skip the next 3 lines (and start directly with
# oe_download()) when running the examples locally.

file.copy(
  from = system.file("its-example.osm.pbf", package = "osmextract"),
  to = file.path(tempdir(), "test_its-example.osm.pbf"),
  overwrite = TRUE
)

# The we can download the .osm.pbf file (if it was not already downloaded)
its_pbf = oe_download(
  file_url = its_match$url,
  file_size = its_match$file_size,
  download_directory = tempdir(),
  provider = "test"
)

# Check that the file was downloaded
list.files(tempdir(), pattern = "pbf|gpkg")

# Convert to gpkg format
its_gpkg = oe_vectortranslate(its_pbf)

# Now there is an extra .gpkg file
list.files(tempdir(), pattern = "pbf|gpkg")

# Check the layers of the .gpkg file
sf::st_layers(its_gpkg, do_count = TRUE)

# Add points layer
its_gpkg = oe_vectortranslate(its_pbf, layer = "points")
sf::st_layers(its_gpkg, do_count = TRUE)

# Add extra tags to the lines layer
names(sf::st_read(its_gpkg, layer = "lines", quiet = TRUE))
its_gpkg = oe_vectortranslate(
  its_pbf,
  extra_tags = c("oneway", "maxspeed")
)
names(sf::st_read(its_gpkg, layer = "lines", quiet = TRUE))

# Adjust vectortranslate options and convert only 10 features
# for the lines layer
oe_vectortranslate(
  its_pbf,
  vectortranslate_options = c("-limit", 10)
)
sf::st_layers(its_gpkg, do_count = TRUE)

# Remove .pbf and .gpkg files in tempdir
oe_clean(tempdir())
}
\seealso{
\code{\link[=oe_get_keys]{oe_get_keys()}}
}
