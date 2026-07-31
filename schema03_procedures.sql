DELIMITER $$

CREATE PROCEDURE create_sale (
    IN p_cashier_id INT,
    IN p_customer_id INT,
    IN p_payment_method VARCHAR(50)
)
BEGIN
    INSERT INTO sales (
        cashier_id,
        customer_id,
        subtotal,
        tax_total,
        deposit_total,
        discount_total,
        grand_total,
        payment_method,
        created_at
    )
    VALUES (
        p_cashier_id,
        p_customer_id,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        p_payment_method,
        NOW()
    );

    SELECT LAST_INSERT_ID() AS sale_id;
END$$


CREATE PROCEDURE add_sale_item (
    IN p_sale_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_unit_price DECIMAL(10,2);
    DECLARE v_tax_rate DECIMAL(5,3);
    DECLARE v_deposit DECIMAL(10,2);
    DECLARE v_tax_amount DECIMAL(10,2);
    DECLARE v_line_total DECIMAL(10,2);

    SELECT 
        COALESCE(retail_price, 0.00),
        COALESCE(bottle_deposit, 0.00),
        COALESCE(taxes.rate, 0.00)
    INTO v_unit_price, v_deposit, v_tax_rate
    FROM products
    LEFT JOIN taxes ON products.tax_id = taxes.tax_id
    WHERE product_id = p_product_id;

    SET v_tax_amount = (v_unit_price * p_quantity) * (v_tax_rate / 100);

    SET v_line_total = (v_unit_price * p_quantity)
                       + (v_deposit * p_quantity)
                       + v_tax_amount;

    INSERT INTO sale_items (
        sale_id,
        product_id,
        quantity,
        unit_price,
        tax_amount,
        deposit_amount,
        discount_amount,
        line_total
    )
    VALUES (
        p_sale_id,
        p_product_id,
        p_quantity,
        v_unit_price,
        v_tax_amount,
        v_deposit * p_quantity,
        0.00,
        v_line_total
    );

    UPDATE sales
    SET subtotal = subtotal + (v_unit_price * p_quantity),
        tax_total = tax_total + v_tax_amount,
        deposit_total = deposit_total + (v_deposit * p_quantity),
        grand_total = grand_total + v_line_total
    WHERE sale_id = p_sale_id;

    SELECT 
        sale_id,
        subtotal,
        tax_total,
        deposit_total,
        discount_total,
        grand_total,
        created_at
    FROM sales
    WHERE sale_id = p_sale_id;
END$$


CREATE PROCEDURE finalize_sale (
    IN p_sale_id INT,
    IN p_amount_paid DECIMAL(10,2),
    IN p_payment_method VARCHAR(50)
)
BEGIN
    DECLARE v_grand_total DECIMAL(10,2);
    DECLARE v_change_due DECIMAL(10,2);

    SELECT grand_total INTO v_grand_total
    FROM sales
    WHERE sale_id = p_sale_id;

    SET v_change_due = p_amount_paid - v_grand_total;

    INSERT INTO payments (
        sale_id,
        amount_paid,
        change_due,
        payment_method,
        paid_at
    )
    VALUES (
        p_sale_id,
        p_amount_paid,
        v_change_due,
        p_payment_method,
        NOW()
    );

    UPDATE sales
    SET payment_method = p_payment_method
    WHERE sale_id = p_sale_id;

    SELECT 
        s.sale_id,
        s.subtotal,
        s.tax_total,
        s.deposit_total,
        s.discount_total,
        s.grand_total,
        p.amount_paid,
        p.change_due,
        p.payment_method,
        s.created_at,
        p.paid_at
    FROM sales s
    JOIN payments p ON s.sale_id = p.sale_id
    WHERE s.sale_id = p_sale_id;
END$$

DELIMITER ;
