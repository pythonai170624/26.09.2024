-- Trigger
-- function returns value
-- procedure DOES NOT returns value
CREATE function one() RETURNS integer
language plpgsql AS
    $$
    BEGIN
        return 1;
    end;
$$;

select now();

select one();

-- select * from sales;

---- BLACK BOX
-- each time a product will be added to an order --> the price*amount will be added to the total
CREATE OR REPLACE FUNCTION update_order_total()
RETURNS TRIGGER AS $$
DECLARE
    product_price REAL;
BEGIN
    -- Get the price of the product that is being added to the order
    SELECT price INTO product_price
    FROM products
    WHERE product_id = NEW.product_id;

    -- Update the total price of the order by adding the new product's total cost
    UPDATE orders
    SET total_price = total_price + (product_price * NEW.amount)
    WHERE order_id = NEW.order_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_order_total_trigger
AFTER INSERT ON products_orders
FOR EACH ROW
EXECUTE FUNCTION update_order_total();

select * from orders where order_id = 1;
select * from products where product_id = 3;
-- 33.28
insert into products_orders(order_id, product_id, amount) VALUES (1, 3, 1);
delete from products_orders where order_id = 1 and product_id=3;

-- delete trigger
drop trigger update_order_total_trigger on products_orders;

CREATE OR REPLACE FUNCTION update_total_price_after_delete()
RETURNS TRIGGER AS $$
DECLARE
    product_price REAL;
BEGIN
    -- Get the price of the product being deleted
    SELECT price INTO product_price
    FROM products
    WHERE product_id = OLD.product_id;

    -- Update the total price in the orders table by subtracting the product's total cost
    UPDATE orders
    SET total_price = total_price - (product_price * OLD.amount)
    WHERE order_id = OLD.order_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER update_order_total_after_delete
AFTER DELETE ON products_orders
FOR EACH ROW
EXECUTE FUNCTION update_total_price_after_delete();

select * from orders where order_id = 1;
select * from products where product_id = 3;
delete from products_orders where order_id = 1 and product_id=3;
-- 33.28
insert into products_orders(order_id, product_id, amount) VALUES (1, 3, 1);

-- update
CREATE OR REPLACE FUNCTION update_total_price_after_update()
RETURNS TRIGGER AS $$
DECLARE
    product_price REAL;
BEGIN
    -- Get the price of the product being updated
    SELECT price INTO product_price
    FROM products
    WHERE product_id = NEW.product_id;

    -- Update the total price in the orders table by adjusting for the changed amount
    UPDATE orders
    SET total_price = total_price + (product_price * (NEW.amount - OLD.amount))
    WHERE order_id = NEW.order_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_order_total_after_update
AFTER UPDATE ON products_orders
FOR EACH ROW
EXECUTE FUNCTION update_total_price_after_update();

select * from orders where order_id = 1;
update products_orders
set amount = 2
where order_id = 1 and product_id = 3;

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

select * from order_details_view where order_id = 1;


