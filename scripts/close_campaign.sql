-- Завершение кампании и расчет ROI
-- Предположим, кампания с id = 1

-- 1. Обновление статуса кампании
UPDATE campaigns
SET status = 'завершена', end_date = CURDATE()
WHERE id = 1;

-- 2. Обновление фактических бюджетов в медиапланах
UPDATE mediaplans m
SET actual_budget = (
    SELECT SUM(cost)
    FROM kpi_data
    WHERE mediaplan_id = m.id
)
WHERE campaign_id = 1;

-- 3. Итоговый отчет по кампании
SELECT
    c.name as campaign_name,
    c.budget_total as planned_budget_total,
    SUM(k.cost) as actual_cost_total,
    SUM(k.leads) as total_leads,
    ROUND(SUM(k.cost) / NULLIF(SUM(k.leads), 0), 2) as avg_cpl,
    cl.company_name,
    e.full_name as manager_name,
    c.start_date,
    c.end_date,
    DATEDIFF(c.end_date, c.start_date) as duration_days
FROM campaigns c
JOIN clients cl ON c.client_id = cl.id
JOIN employees e ON c.manager_id = e.id
LEFT JOIN kpi_data k ON c.id = k.campaign_id
WHERE c.id = 1
GROUP BY c.id;

-- 4. Детализация по каналам
SELECT
    m.channel,
    m.channel_type,
    m.planned_budget,
    m.actual_budget,
    ROUND(m.actual_budget - m.planned_budget, 2) as budget_variance,
    SUM(k.impressions) as impressions,
    SUM(k.clicks) as clicks,
    SUM(k.leads) as leads,
    ROUND(SUM(k.cost) / NULLIF(SUM(k.leads), 0), 2) as channel_cpl
FROM mediaplans m
LEFT JOIN kpi_data k ON m.id = k.mediaplan_id
WHERE m.campaign_id = 1
GROUP BY m.id;