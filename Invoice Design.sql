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


CREATE TABLE "invoice_details" (
    "invoice_detail_id" SERIAL PRIMARY KEY,
    "invoice_id" integer NOT NULL,
    "buyer_name" varchar,
    "seller_name" varchar,
    "product_name" varchar,
    "coupon_code" varchar,
    "courier_name" varchar,
    "payment_method" varchar,
    "total_amount" decimal,
    "invoice_date" timestamp,
    "due_date" timestamp,
    "status" varchar,
    
    FOREIGN KEY ("invoice_id") REFERENCES "invoices" ("invoice_id")
);

INSERT INTO invoice_details (
    invoice_id,
    buyer_name,
    seller_name,
    product_name,
    coupon_code,
    courier_name,
    payment_method,
    total_amount,
    invoice_date,
    due_date,
    status
)
SELECT
    i.invoice_id,
    u.username AS buyer_name,
    s.store_name AS seller_name,
    p.name AS product_name,
    c.code AS coupon_code,
    cr.courier_name AS courier_name,
    pm.method_name AS payment_method,
    i.total_amount,
    i.invoice_date,
    i.due_date,
    i.status
FROM
    invoices i
JOIN
    orders o ON i.order_id = o.order_id
JOIN
    users u ON o.user_id = u.user_id
JOIN
    order_items oi ON o.order_id = oi.order_id
JOIN
    products p ON oi.product_id = p.product_id
JOIN
    sellers s ON p.seller_id = s.seller_id
LEFT JOIN
    order_coupons oc ON o.order_id = oc.order_id
LEFT JOIN
    coupons c ON oc.coupon_id = c.coupon_id
LEFT JOIN
    couriers cr ON o.courier_id = cr.courier_id
LEFT JOIN
    payments pay ON o.order_id = pay.order_id
LEFT JOIN
    payment_methods pm ON pay.payment_method_id = pm.payment_method_id;
