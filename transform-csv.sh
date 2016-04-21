#!/usr/bin/env bash

# PREREQUISITES: see install.sh

# EXAMPLE of how to fix the encoding and formatting of a CSV to get a standard CSV:
# csvformat data/products.raw.csv -e ISO-8859-1 -d ";" > data/products.clean.csv
csvformat data/products.raw.csv > data/products.clean.csv

# EXAMPLE of how to replace certain character sequences. semicolons are sometimes problematic as they are also the
# separator for Set (multiple value) attributes in the CTP import CSV format.
# replace all &quot; escapes with CSV style "" escapes
sed 's/&quot;/""/g' data/products.clean.csv > data/products.cleaner.csv

# EXAMPLE of how to remove lines that should not be imported (e.g. dummy products, broken stuff etc.)
# remove lines with dummy products that have p_nr zero:
# csvgrep -c id -i -m evilIdentifier data/products.cleaner.csv > data/products.reallyclean.csv

# Sort by product if not the case yet.
# This is IMPORTANT because the CTP product import requires that variants come in grouped lines.
# DO NOT FORGET TO change "ID" to the column name in your file that groups product variants into a product.
csvsort -c ID data/products.reallycleanandsorted.csv > data/products.reallycleanandsorted.subset.csv

# create a separate smaller file to test the transformations and imports faster during development:
head -n 1000 data/products.reallycleanandsorted.csv > data/products.reallycleanandsorted.subset.csv

# finally: the actual data structure transform to the format required by the commercetools csv sync (you DO have to completely modify the csv-mapping.yaml for your case!)
./node_modules/.bin/csv-mapper --inCsv data/products.reallycleanandsorted.subset.csv --outCsv data/products4commercetools.subset.csv --mapping csv-mapping.yaml
./node_modules/.bin/csv-mapper --inCsv data/products.reallycleanandsorted.csv --outCsv data/products4commercetools.csv --mapping csv-mapping.yaml

