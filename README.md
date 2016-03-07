# Template and and Documentation to set up a demo webshop wiht the commercetools platform

This README describes how ot set up a sales demo as easy as possible using free or commercetools provided cloud hosting. 

## Summary of Tools and Implementations that you (may) need

For sure:

 * The default CTP webshop ["SUNRISE" in Java](https://github.com/sphereio/commercetools-sunrise-java/) Java or [PHP](https://github.com/sphereio/commercetools-sunrise-php)
 * The default [SUNRISE theme](https://github.com/sphereio/commercetools-sunrise-theme) 

Depending on the data situation the commercetools import tooling:

 * [Generate CTP product types from a CSV based format](https://github.com/sphereio/sphere-product-type-json-generator)
 * [Import Category Trees into CTP](https://github.com/sphereio/sphere-category-sync) via the [commercetools CLI](https://github.com/sphereio/sphere-node-cli)
 * CSV based product import:
   * [CSV mapper to bring the file into the right format](https://github.com/sphereio/csv-mapper/)
   * [CTP CSV Product Sync / Import](https://github.com/sphereio/sphere-node-product-csv-sync)
 * JSON based product import:
   * [CTP product importer - part of the commercetools / sphere CLI](https://github.com/sphereio/sphere-node-cli)

Optional additional tooling:

 * the [Heroku Toolbelt]() helps you in checking out and changing the shop frontend you created.  
 * [CSVKit to analze, clean up etc. CSV files](https://github.com/wireservice/csvkit)
 * Excel or LibreOffice to work manually with CSV files
 * a decent XML and JSON viewer / editor (if you're not in an IDE anyways)
 
## Necessary Accounts

(both free for the purpose fo demo applications) 

  * [set up a personal account on the commercetools platform](https://admin.sphere.io/en/signup). 
    If your company already has an "Organization" in the commercetools platform, ask a colleague to invite you. Otherwise you will get a fresh personal organization on signup.
  * [create an account at Heroku.com to temporarily host your web frontend](https://signup.heroku.com/). Heroku is a service that lets you run server applications as "dynos" with own web address. It's free for up to five dynos. If a free dyno is not used, it's put into sleep and restarted the next time someone is using it. 
 
## Phase 1: Analysis
 
OK, so now you have a prospect and want to show him commercetools, but not "just" the API to make clear that he/she will really get a webshop from you and that it will really be responsive etc. pp. 
 
> Question #1: Do you want to manually type in sample categories and products or rather import a data feed you received? 
 
Although typing in seems awkward, it can often be the much more efficient choice, especially when it comes to product types (=the data model) and the categories. 
If you have not received sample data it's clear anyways: Take a coffee, open [the Merchant Center](https://admin.sphere.io) and create the custom's world from scratch. 
 
If you have received sample data (often some product CSV feed or a specialized XML format), the first step is to get an idea of the content, 
structure and quality: 
 
  1. Content: What's in? Is it enough for a demo to be sensible? (e.g. no description texts and no images -> demo will look bad -> type data yourself). Some random Tips:
   * CSV: Opening in a Spreadsheet application can give a good first impression
   * CSV: CSVkit's `csvstat` command generates very helpful statistics on column types, value distribution, value density etc.
  2. Structure: 
   * What field means what? 
   * Is there a concept of product variants? how are they identified?
   * Is it possible to create absolute paths to the live images? 
   * How are the price data structured?  Net or Gross? VAT included in price or not? 
   * ... 
  3. Quality: Is it good enough for a visual demo (e.g. most fields empty? -> type data yourself)? 
 
Result: you know whether to try importing automatically or rather taking a subsset of the catalog and typing that in. 
 
## Phase 2: Commercetools Setup
  
  1. Log in, go to "Organization Settings", choose or create the Organization (e.g. a special org for your demo sites)
  2. Navigate to "Manage Projects" and create a new one. Please choose a key that makes clear it's a demo or playground by appending `-demo` or something similar. 
    * Leads to less confusion and easier "please free this from billing" processes. 
    * Does not "burn" the real project name key for the hopefully acquired client. Keys cannot be changed and are hard to re-use!  
  3. Don't add the sample dataset (it does only work well with specific language / country seutps)
  4. Navigate to "Settings" and:
    * in Tab "International": configure just one language, county, currency and zone (it's not likely that you will import multilanguage, multichannel data in a sales demo and you can still do that later if you want)
    * in Tab "Taxes": add a Tax Category named "default", give that one Rate named "default" and set "included in price" as fits. 
    * in Tab "Shipping Methods": Add a Shipping Method with the Name of a carrier the prospect currently offers (or more). Set it as default. 
      * Add one Zone Rate
        * Add one Price wiht a "free above" setting (yes, the structure has three levels of nesting) 
  5. Navigate to "Developers" and
    * in Tab "Product Types", create a product type named "default", e.g. named "Standard Product"
      * for simple demos, it's easier to use a big "catch all attributes" product type definition. Better spend your time to model that one correctly than in differentiating types that then all just have plain String fields.  
      * (do the attribute modeling later)
    * Find the Tab "API Clients". You will need the Client ID and Client Secret a lot later on. 
     
## Phase 3: Fire up a SUNRISE demo storefront
   
   1. Go to https://github.com/sphereio/commercetools-sunrise-java#deployment and press the "Deploy to Heroku" Button. 
   2. Fill "App Name" with what you want to be in the URL of the demo shop (better not leave blank)
   3. The nice people at commercetools have prepared the project so that you get a nice form to configure the UI now:
     * Fill Project Key, Client ID and Client Secret of your platform project (they are safe here if you have a secure Heroku password)
     * FILL ALL OTHER VARIABLES LATER WHEN YOU HAVE DONE THE DATA MODELING. You can find them as "environemnt variables" in the app / dyno settings. 
   4. Press "deploy for free", wait a while and hooray, you should have a working, but empty online store live on the web.  
   
   
## Phase 4: Enter or Import Categories
  
TODO add detailed tips
  
> Attention: The SUNRISE webshop does only periodically refresh the category tree from the platform. To force refresh, restart the Heroku app. 
TODO is there a smarter method? 


## Phase 5: Model the product type

You can interactively model the product type in the Merchant Center. 
 * Take your time to understand the Attribute types and Constraints (precise documentation can be found here: http://dev.commercetools.com/http-api-projects-productTypes.html#attribute-definition )
 * From you analyis (see above), rather choose just a few core attributes and do them right instead of trying completeness. E.g. a well configured "Enum" creates a dropdown in the PIM section of the Merchant Ceter, which is more impressive than an array of 50 text fields.
 * Type speficific hints:
  * to fill the localizable types with multiple language values from CSV, append e.g. `.de` or `.en` to the column name. 
  * Enum is nice, Localizable Enum is nicer (you can "translate" / "rename" the values in the source datafeed
  * Although powerful, avoid Nested and Reference attributes in imports. They are trickier to import and harder to explain (esp. Nested)

After having done that, 

## Phase 5: Enter or Import Products
  
### Manually 

TODO add practical tips. 

> Don't forget to publish your products (There's a special button in the merchant center). If published, they become visible immediately. 

### Transform and Import a Datafeed

TODO Generally: Maybe better let people use the Web based http://impex.sphere.io/ ?  PRO: less to install.  CON: less reproducible, problematic with large files, need to install csv-mapper anyways.  

First of all, you need a newer [Node.js](https://nodejs.org/en/download/) runtime on your local machine (there are tips on using a package manager like Homebrew or apt at the bottom of the page).

Secondly, clone this GitHub repository to your machine and use it as the starting point for your working directory. 
It contains the necessary setup, helper scripts and sample files. 
As long as you don't push back to the commercetools GitHub, you can commit and version locally as you like. 
You can also choose to fork it on GitHub, but keep in mind that sales prospects don't really like the information public. 

To install the typically needed commercetools commandline tools, just run

```
npm install
```
Now you have a project-local installation of all the commandline tools, located in `./node_modules/.bin/`  

Now add your API client key and secret to the `.sphere-project-credentials.json` file so the CLI has them available. 

 * TODO explain csv-mapper, csv and json formats. 
 * TODO add template files to this project, esp. a csv-mapper example with typical cases. 

## Phase 6: Customize the Look and CSS of the Demo storefront. 

To customize the Demo Storefront, you will make use of the fact that the SUNRISE storefront has been directly deployed from GitHub to Heroku. 
This effectively creates a fork of the project on a Heroku git server. The only inconvenience is that to conveniently access that git repository you have to 

 * install the [Heroku Toolbelt](https://toolbelt.heroku.com/) (essentially a Heroku CLI)
 * create a working directory on your local machine and `cd` there

```
TODO command to check out your app
```

Now you have the source code on your computer. You can either let Heroku do work by comitting and pushing every change (Heroku will automatically restart the app on every push) 

```
TODO commands to push to Heroku
```
  
Alternatively, start the frontend server on your local computer (see the documentation in the SUNRISE project for that). 

### Customize CSS

TODO 

### Customize Templates

TODO

### Customize Logic

If you need to do this, you should reconsider whether you're still in demo mode or have migrated to doing a real project. 
We do not recommend directly migrating a demo to a live project. It's not because the software is bad, but rather because it is a bad idea to not do thorough analysis on the data modeling and overall technical project architecture. 
Commercetools does offer Trainings to build Webshops on the foundation of the SUNRISE Framework. 



    
 
 