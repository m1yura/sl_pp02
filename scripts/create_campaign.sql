-- Создание новой рекламной кампании
-- Предположим, что клиент с id = 1 и менеджер с id = 2 уже существуют

INSERT INTO campaigns (client_id, manager_id, name, description, budget_total, start_date, end_date, status)
VALUES (
    1,
    2,
    'Летняя распродажа 2026',
    'Продвижение летней коллекции товаров со скидками до 50%',
    1500000.00,
    '2026-06-01',
    '2026-08-31',
    'черновик'
);

-- Просмотр созданной кампании
SELECT c.*, cl.company_name, e.full_name as manager_name
FROM campaigns c
JOIN clients cl ON c.client_id = cl.id
JOIN employees e ON c.manager_id = e.id
ORDER BY c.id DESC LIMIT 1;