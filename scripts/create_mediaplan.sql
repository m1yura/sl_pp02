-- Создание медиаплана для кампании
-- Предположим, кампания с id = 1

INSERT INTO mediaplans (campaign_id, channel, channel_type, planned_budget, planned_impressions, planned_clicks, start_date, end_date, status)
VALUES
    (1, 'Яндекс.Директ - Поиск', 'яндекс', 300000.00, 150000, 7500, '2026-06-01', '2026-06-30', 'план'),
    (1, 'Яндекс.Директ - РСЯ', 'яндекс', 250000.00, 300000, 4500, '2026-06-01', '2026-06-30', 'план'),
    (1, 'VK Реклама - Лента', 'vk', 200000.00, 250000, 5000, '2026-06-01', '2026-06-30', 'план'),
    (1, 'Google Ads', 'google', 150000.00, 100000, 3000, '2026-06-01', '2026-06-30', 'план');

-- Просмотр медиаплана с расчетом долей
SELECT
    channel,
    channel_type,
    planned_budget,
    ROUND(planned_budget * 100.0 / SUM(planned_budget) OVER(), 2) as budget_share_percent,
    planned_impressions,
    planned_clicks,
    ROUND(planned_budget / NULLIF(planned_clicks, 0), 2) as planned_cpc
FROM mediaplans
WHERE campaign_id = 1;