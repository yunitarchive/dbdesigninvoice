CREATE TABLE "users" (
  "user_id" integer PRIMARY KEY,
  "username" varchar,
  "password" varchar,
  "email" varchar,
  "default_shipping_address" text,
  "default_shipping_city" varchar,
  "default_shipping_postal_code" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "sellers" (
  "seller_id" integer PRIMARY KEY,
  "user_id" integer,
  "store_name" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "products" (
  "product_id" integer PRIMARY KEY,
  "seller_id" integer,
  "name" varchar,
  "description" text,
  "price" decimal,
  "stock_quantity" integer,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "orders" (
  "order_id" integer PRIMARY KEY,
  "user_id" integer,
  "order_date" timestamp,
  "status" varchar,
  "total_amount" decimal,
  "shipping_address" text,
  "shipping_city" varchar,
  "shipping_postal_code" varchar,
  "courier_id" integer,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "order_items" (
  "order_item_id" integer PRIMARY KEY,
  "order_id" integer,
  "product_id" integer,
  "quantity" integer,
  "price" decimal,
  "created_at" timestamp
);

CREATE TABLE "payments" (
  "payment_id" integer PRIMARY KEY,
  "order_id" integer,
  "payment_date" timestamp,
  "amount" decimal,
  "payment_method_id" integer,
  "status" varchar
);

CREATE TABLE "payment_methods" (
  "payment_method_id" integer PRIMARY KEY,
  "method_name" varchar,
  "created_at" timestamp
);

CREATE TABLE "coupons" (
  "coupon_id" integer PRIMARY KEY,
  "code" varchar,
  "discount_type" varchar,
  "discount_value" decimal,
  "expiry_date" timestamp,
  "minimum_order_value" decimal
);

CREATE TABLE "order_coupons" (
  "order_coupon_id" integer PRIMARY KEY,
  "order_id" integer,
  "coupon_id" integer,
  "created_at" timestamp
);

CREATE TABLE "couriers" (
  "courier_id" integer PRIMARY KEY,
  "courier_name" varchar,
  "tracking_url" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "addresses" (
  "address_id" integer PRIMARY KEY,
  "user_id" integer,
  "address_line" text,
  "city" varchar,
  "postal_code" varchar,
  "is_default" boolean,
  "created_at" timestamp,
  "updated_at" timestamp
);

ALTER TABLE "sellers" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "products" ADD FOREIGN KEY ("seller_id") REFERENCES "sellers" ("seller_id");

ALTER TABLE "orders" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "orders" ADD FOREIGN KEY ("courier_id") REFERENCES "couriers" ("courier_id");

ALTER TABLE "order_items" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("order_id");

ALTER TABLE "order_items" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("product_id");

ALTER TABLE "payments" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("order_id");

ALTER TABLE "payments" ADD FOREIGN KEY ("payment_method_id") REFERENCES "payment_methods" ("payment_method_id");

ALTER TABLE "order_coupons" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("order_id");

ALTER TABLE "order_coupons" ADD FOREIGN KEY ("coupon_id") REFERENCES "coupons" ("coupon_id");

ALTER TABLE "addresses" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");
