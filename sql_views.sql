--VIEW --------------------------------------------------------

CREATE VIEW order_details_view AS
SELECT
    o.order_id,
    o.date_time,
    o.address,
    o.customer_name,
    o.customer_ph,
    p.name AS product_name,
    po.amount,
    p.price,
    (po.amount * p.price) AS total_price_per_product,
    o.total_price
FROM
    orders o
JOIN
    products_orders po ON o.order_id = po.order_id
JOIN
    products p ON po.product_id = p.product_id;

-- execute
select * from order_details_view where order_id = 1;


