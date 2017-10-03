SolidusPurchasing
=================

This gem adds the ability to monitor stock needs based on current stock level vs.
recent sales & create+send purchase orders.

Installation
------------

Add solidus_purchasing to your Gemfile:

```ruby
gem 'solidus_purchasing'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g solidus_purchasing:install
```

What You Need To Know
------------

First Steps:

Create Categories - "Shipping" will already exists. Example categories are
"Assembly Parts" or "Bank Fee"

Create Vendors - tick "Send Email" if you want to auto-send the purchase order
when you approve it. Delivery_Time is used in calculating when you need to order
something - it's the default setting if you don't set a delivery_time in the
product information.

Add puchasing info to each variant - Located in the admin product page, you'll
need to fill out the info here to get them to show up in the dashboard report.

Run the dashboard_info rake job with "rake generate_dashboard_info" - This runs
the rake job that gives you your current inventory status and tells you what
you need to order.

Go to the dashboard - this shows you your stock needs. If you need to order
anything, a sample PO will be generated for each vendor you need to order from.
You can choose to either ignore (temporarily) or place the PO. The "Days on Hand"
number you see is generated from current stock, recent sales, and delivery time.
The idea is, if you order when "days on hand" is at 1, you should receive the
products a day before you run out of your current stock.

Place the purchase orders - There are two steps - "approve" and "place". Approve
just marks the PO as reviewed and ready to place - "place" is what actually
emails the vendor.

Receive products - on a placed PO, you can receive the items that you placed. This
will add the amount received into stock, and also (if you ticked the box) adjust
the cost of the product (using cost averaging).



Copyright (c) 2017 Sean Denny, released under the New BSD License
