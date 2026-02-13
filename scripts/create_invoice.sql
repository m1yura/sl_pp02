-- Генерация уникального номера счета
-- Формат: INV-YYYYMMDD-XXXX

DELIMITER //

CREATE FUNCTION generate_invoice_number()
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE new_number VARCHAR(50);
    DECLARE seq INT;

    SELECT COALESCE(MAX(CAST(SUBSTRING_INDEX(invoice_number, '-', -1) AS UNSIGNED)), 0) + 1
    INTO seq
    FROM invoices
    WHERE DATE(issue_date) = CURDATE();

    SET new_number = CONCAT('INV-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(seq, 4, '0'));
    RETURN new_number;
END//

DELIMITER ;

-- Выставление счета
INSERT INTO invoices (client_id, campaign_id, invoice_number, amount, issue_date, due_date, status)
VALUES (
    1,
    1,
    generate_invoice_number(),
    500000.00,
    CURDATE(),
    DATE_ADD(CURDATE(), INTERVAL 14 DAY),
    'выставлен'
);

-- Просмотр счетов клиента
SELECT
    i.*,
    c.company_name,
    camp.name as campaign_name,
    DATEDIFF(i.due_date, CURDATE()) as days_until_due
FROM invoices i
JOIN clients c ON i.client_id = c.id
JOIN campaigns camp ON i.campaign_id = camp.id
WHERE i.client_id = 1
ORDER BY i.issue_date DESC;