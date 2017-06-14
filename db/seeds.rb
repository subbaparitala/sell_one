# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


def seed_image(file_name)
  File.open(File.join(Rails.root, "/app/assets/images/seeds/#{file_name}.jpg"))
end


mobiles = ["mobile1","mobile2","mobile3","mobile4","mobile5","mobile6"]
cameras = ["camera1","camera2","camera3","camera4"]
Category.create(title: 'mobile')
Category.create(title: "camera")
mobiles.each do |m|
	product = Product.new(name: m ,description: "", price: rand.to_s[2..5].to_f,  product_img: seed_image(m.first+m.last))
  if product.save
  	product.product_categories.create(category_id: Category.first)
  end
end
cameras.each do |c|
	product = Product.new(name: c ,description: "", price: rand.to_s[2..5].to_f,product_img: seed_image(c.first+c.last))
  if product.save
  	product.product_categories.create(category_id: Category.last)
  end
end