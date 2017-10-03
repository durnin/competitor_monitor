# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' },
#                          { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
group = Group.create(name: 'Baseball Bats')
group.competitors.create(name: 'Rawlings YBRR11', link: 'https://www.amazon.com/dp/B011BX2A5M/ref=twister_dp_update?_encoding=UTF8&psc=1')
group.competitors.create(name: 'Louisville Slugger Genuine Series 3X', link: 'https://www.amazon.com/dp/B01K8B5AG4/ref=twister_dp_update?_encoding=UTF8&psc=1')
group.competitors.create(name: 'Louisville Slugger Omaha 517 BBCOR', link: 'https://www.amazon.com/dp/B01JP6E82U/ref=twister_dp_update?_encoding=UTF8&psc=1')
group.competitors.create(name: 'BB-W', link: 'https://www.amazon.com/BB-W-Wooden-baseball-bat-size/dp/B002BZIVSU/ref=s%20r_1_8?ie=UTF8&qid=1501170697&sr=8-8&keywords=baseball+bats')
group.competitors.create(name: 'Marucci Cat 6 BBCOR', product_asin: 'B00L9A95T2')
# group = Group.create(name: 'Bluetooth Headphones')
# group.competitors.create(name: 'Mpow', link: 'https://www.amazon.com/Mpow-Bluetooth-Headphones-Wireless-Memory-Protein/dp/B01NAJGGA2/ref=sr_1_1?s=aht&ie=UTF8&qid=1507047685&sr=1-1&keywords=headphones&refinements=p_n_feature_four_browse-bin%3A12097501011%2Cp_72%3A1248879011%2Cp_36%3A1253504011')
# group.competitors.create(name: 'OneOdio', product_asin: 'B01N6ZJH96')
# group.competitors.create(name: 'SUPSOO B102', product_asin: 'B075D1Q1ZZ')
# group.competitors.create(name: 'AlierGo', product_asin: 'B074N2Q9K9')
