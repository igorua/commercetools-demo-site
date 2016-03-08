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
    * Does not "burn" the real project name key for the hopefully acquired customer. Keys cannot be changed and are hard to re-use!  
  3. Don't add the sample dataset (it does only work well with specific language / country seutps)
  4. Navigate to "Settings" and:
    * in Tab "International": configure just one language, county, currency and zone (it's not likely that you will import multilanguage, multichannel data in a sales demo and you can still do that later if you want)
    * in Tab "Taxes": add a Tax Category named "default", give that one Rate named "default" and set "included in price" as fits. 
    * in Tab "Shipping Methods": Add a Shipping Method with the Name of a carrier the prospect currently offers (or more). Set it as default. 
      * Add one Zone Rate
        * Add one Price with a "free above" setting (yes, the structure has three levels of nesting)
    * In Tab "General" _disable_ all HTML editor checkboxes (otherwise you risk breaking the layout)
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

### enter manually

Not much to explain. You will get used to the UI. Mandatory fields:
 * Name (in the "General Info" tab)
 * Slug (in the "SEO" Tab)
  
> First of all: Think well about which scope of the catalog you want to edit products for. Empty categories are not impressive. 

> As of March 2016 there is a layout bug with long description texts. Stay concise. 
  
> Attention: The SUNRISE webshop does only periodically refresh the category tree from the platform. To force refresh, restart the Heroku app, or (much better) call the `/categories/refresh` in the webshop (e.g. http://my-sales-demo.herokuapp.com/categories/refresh )   

### import automatically. 

Please follow the documentation of the [commercetools CLI](https://github.com/sphereio/sphere-node-cli). Typical Issues to consider: 

* Plan well, which identifier to use to map the products to the categories (externalId is usually the safest way)
* Make sure that your category feed is ordered so that the parent categories are there before their children.  If you category feed is randomly ordered, do a two-pass import by first importing all categories "flat" without parent association and then running it again with parent associations, effectively building the tree). 

## Phase 5: Model the product type

> Tip: consider to first import only the minimum required data before adding lots of attributes. The SUNRISE demo works well without any custom attributes. 

> Tip: if you work with product variants, you need at least the attribute(s) that differentiate the variants so the Frontend can show the variant selector dropdowns. 

You can interactively model the product type in the Merchant Center. 
 * Take your time to understand the Attribute types and Constraints (precise documentation can be found here: http://dev.commercetools.com/http-api-projects-productTypes.html#attribute-definition )
 * From you analyis (see above), rather choose just a few core attributes and do them right instead of trying completeness. E.g. a well configured "Enum" creates a dropdown in the PIM section of the Merchant Ceter, which is more impressive than an array of 50 text fields.
 * Type speficific hints:
  * to fill the localizable types with multiple language values from CSV, append e.g. `.de` or `.en` to the column name. 
  * Enum is nice, Localizable Enum is nicer (you can "translate" / "rename" the values in the source datafeed
  * Although powerful, avoid Nested and Reference attributes in imports. They are trickier to import and harder to explain (esp. Nested)


## Phase 5: Enter or Import Products
  
### Manually 

> Don't forget to publish your products (There's a special button in the merchant center). If published, they become visible immediately. 

### Transform and Import a Datafeed

> *If* you plan to manually clean / transform the data e.g. in Excel or LibreOffice (instead of using the commercetools tools), you can skip the "Local Installation" Part.  

#### Local Installation

First of all, you need a newer [Node.js](https://nodejs.org/en/download/) runtime on your local machine (there are tips on using a package manager like Homebrew or apt at the bottom of the page).

Secondly, clone this GitHub repository to your machine and use it as the starting point for your working directory. 
It contains the necessary setup, helper scripts and sample files. 
As long as you don't push back to the commercetools GitHub, you can commit and version locally as you like. 
You can also choose to fork it on GitHub, but keep in mind that sales prospects don't really like the information public. 

To install the typically needed commercetools commandline tools, run

```
npm install
```
Now you have a project-local installation of all the commandline tools, located in `./node_modules/.bin/`  

Now add your API client key and secret to the `.sphere-project-credentials.json` file so the CLI has them available. 

#### Transform the Product Data to the right format. 

 * use [the CSV-Mapper](https://github.com/sphereio/csv-mapper/) (or a spreadsheet if you don't want to be able to reproduce the results with updated data) to
  * bring the CSV into the [format required by the CSV sync](https://github.com/sphereio/sphere-node-product-csv-sync#csv-format) 
  * A lot of real-wold examples can be found in the [CSV-Mapper Examples File](./csv-mapping-examples.yaml) in this project.  
  * A good way to start is the [csv-mapping.yaml](./csv-mapping.yaml) config template. 

 * OR bring the JSON into the [format required by the JSON import](https://github.com/sphereio/sphere-product-import/blob/master/readme/product-import.md#sample-inputs) with your preferred tooling or programming language. 
   But be warned: that is usually too much work for a quick demo setup. 
  

#### Running the Import

[IMPEX Web GUI](https://impex.sphere.io/commands/product-import) is a cloud hosted version of the commercetools CLI toolings for your convenience. All CLIs are supported, but not the csv-mapper. 

## Phase 6: Customize the Look and CSS of the Demo storefront. 

To customize the Demo Storefront, you will make use of the fact that the SUNRISE storefront has been directly deployed from GitHub to Heroku. 
This effectively creates a fork of the project on a Heroku git server. The only inconvenience is that to conveniently access that git repository you have to 

 * install the [Heroku Toolbelt](https://toolbelt.heroku.com/) (essentially a Heroku CLI)
 * create a working directory on your local machine, `cd` there and run:

```
heroku git:clone -a myapp
heroku plugins:install https://github.com/ddollar/heroku-push
```

Now you have the source code on your computer plus an extenstion to the heroku cli that optionally lets you redeploy without git. 
You can either let Heroku do work by pushing your changes there (Heroku will automatically restart the app on every push) :

```
# raw files
heroku push

# alternative: via git
$ git add -A
$ git commit -m "a foobar commit"
```
  
Alternatively, start the frontend server on your local computer (see the documentation in the SUNRISE project for that). 

### Customize CSS and Templates

The SUNRISE Java project contains good documentation on how to customize the project a bit or a lot:
 * https://github.com/sphereio/commercetools-sunrise-java/blob/master/ONBOARDING.md
 * esp. from here on: https://github.com/sphereio/commercetools-sunrise-java/blob/master/ONBOARDING.md#basic-customization

Typical Tasks for a demo: Change the Color Scheme, Mood Images and Logos, but don't touch the layout (yet). 

If you want to fully customize the theme or work on SCSS level, you should rather fork the complete [SUNRISE theme](https://github.com/sphereio/commercetools-sunrise-theme). But that is typically out of scope for a demonstration taks. 

### Customize Logic

If you need to do this, you should reconsider whether you're still in demo mode or have migrated to doing a real project. 
We do not recommend directly migrating a demo to a live project. It's not because the software is bad, but rather because it is a bad idea to not do thorough analysis on the data modeling and overall technical project architecture. 
Commercetools does offer Trainings to build Webshops on the foundation of the SUNRISE Framework. 
