# Contributing to this

## Goals

The goal is to strip down the necessary steps to the maximum reliable and barest minimum necessary to create a (typically sales) _throwaway_ demonstration setup.
 
It must be doable on a Windows or Mac OS machine (assuming admin or at least application installation permissions). 
 
The goal is _not_ to provide the maximum capabilities or fully use the frameworks' capabilites. 

## Isn't this duplicate documentation? 

(e.g. to the ONBOARDING file in the Sunrise Java project). 

Yes, Nothing here is original information, but no, there is no other place that explains the most efficient bare minimum steps without "distracting" by explaining all the other great possibilities. 

## Related open Issues in SUNRISE and other projects 

Please track the following issues and update the documentation accordingly once they have improved:

 * Not all language bundles loaded (so only english works for now)  https://github.com/sphereio/commercetools-sunrise-java/issues/342
 * All products need to be in categories to no break suggestions  https://github.com/sphereio/commercetools-sunrise-java/issues/340
 * Heroku Button can deploy unstable versions https://github.com/sphereio/commercetools-sunrise-java/issues/348 

General documentation TODOs for SUNRISE are tracked here: https://github.com/sphereio/commercetools-sunrise-java/issues/241

## Design decisions

 * Product types generation and import is not mentioned because the tutorial advises to use a single product type for demos or at most a small amount and that is better done in the MC UI. 
 * Demo data not used because they are not consistent and removing the languages, products and categories is more work than creating the mimimal metadata from scratch. 