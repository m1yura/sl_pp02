-- Создание базы данных
CREATE DATABASE marketing_agency
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE marketing_agency;

-- Таблица клиентов (рекламодателей)
CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255) UNIQUE NOT NULL,
    inn VARCHAR(12) UNIQUE,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('активен', 'архив', 'потенциальный') DEFAULT 'потенциальный'
);

-- Таблица сотрудников агентства
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    position VARCHAR(100) NOT NULL,
    department ENUM('аккаунтинг', 'креатив', 'медиа', 'аналитика') NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

-- Таблица рекламных кампаний
CREATE TABLE campaigns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    manager_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    budget_total DECIMAL(15,2),
    start_date DATE,
    end_date DATE,
    status ENUM('черновик', 'на согласовании', 'активна', 'на паузе', 'завершена', 'архив') DEFAULT 'черновик',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES employees(id)
);

-- Таблица креативов
CREATE TABLE creatives (
    id INT PRIMARY KEY AUTO_INCREMENT,
    campaign_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    type ENUM('баннер', 'видео', 'пост', 'статья', 'аудио') NOT NULL,
    file_url VARCHAR(500),
    approval_status ENUM('в работе', 'на ревью', 'на согласовании', 'утвержден', 'отклонен') DEFAULT 'в работе',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP NULL,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
);

-- Таблица медиапланов
CREATE TABLE mediaplans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    campaign_id INT NOT NULL,
    channel VARCHAR(100) NOT NULL,
    channel_type ENUM('яндекс', 'google', 'vk', 'ok', 'tv', 'radio', 'outdoor') NOT NULL,
    planned_budget DECIMAL(15,2),
    actual_budget DECIMAL(15,2) DEFAULT 0,
    planned_impressions INT,
    planned_clicks INT,
    start_date DATE,
    end_date DATE,
    status ENUM('план', 'активен', 'завершен') DEFAULT 'план',
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
);

-- Таблица показателей эффективности (KPI)
CREATE TABLE kpi_data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    campaign_id INT NOT NULL,
    mediaplan_id INT NOT NULL,
    date DATE NOT NULL,
    impressions INT DEFAULT 0,
    clicks INT DEFAULT 0,
    leads INT DEFAULT 0,
    cost DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (mediaplan_id) REFERENCES mediaplans(id) ON DELETE CASCADE
);

-- Таблица счетов
CREATE TABLE invoices (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    campaign_id INT NOT NULL,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    payment_date DATE NULL,
    status ENUM('выставлен', 'оплачен', 'просрочен', 'отменен') DEFAULT 'выставлен',
    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);

-- Индексы для ускорения поиска
CREATE INDEX idx_clients_status ON clients(status);
CREATE INDEX idx_campaigns_status ON campaigns(status);
CREATE INDEX idx_campaigns_dates ON campaigns(start_date, end_date);
CREATE INDEX idx_kpi_date ON kpi_data(date);