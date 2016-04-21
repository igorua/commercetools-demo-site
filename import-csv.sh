#!/usr/bin/env bash

# You can optionally do a full delete and recreate of the products
#  - e.g. to completely re-do category mapping
#  - e.g. because in certain circumstances it is faster than a sync and requires less RAM on your local machine.
# first unpublish (you do need this step, otherwise the delete will fail):
# product-csv-sync state --changeTo unpublish --projectKey $CT_PROJECT --clientId $CT_CLIENT_ID --clientSecret $CT_CLIENT_SECRET
# then delete:
# product-csv-sync state --changeTo delete  --projectKey $CT_PROJECT --clientId $CT_CLIENT_ID --clientSecret $CT_CLIENT_SECRET

# for testing: import just the subset:
#./node_modules/.bin/product-csv-sync  --projectKey $CT_PROJECT --clientId $CT_CLIENT_ID --clientSecret $CT_CLIENT_SECRET import --csv data/products4commercetools.subset.csv --matchBy sku --language de --allowRemovalOfVariants --publish --continueOnProblems

# import all:
./node_modules/.bin/product-csv-sync  --projectKey $CT_PROJECT --clientId $CT_CLIENT_ID --clientSecret $CT_CLIENT_SECRET import --csv data/products4commercetools.csv --matchBy sku --language de --allowRemovalOfVariants --publish --continueOnProblems
