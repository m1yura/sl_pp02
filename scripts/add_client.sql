-- Добавление нового клиента
INSERT INTO clients (company_name, contact_person, phone, email, inn, address, status)
VALUES (
    'ООО "Ромашка"',
    'Иванов Иван Иванович',
    '+7 (495) 123-45-67',
    'ivanov@romashka.ru',
    '7701123456',
    'г. Москва, ул. Ленина, д. 10',
    'активен'
);

-- Проверка добавленного клиента
SELECT * FROM clients ORDER BY id DESC LIMIT 1;