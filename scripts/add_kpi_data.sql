-- Добавление фактических показателей по дням
-- Предположим, кампания с id = 1 и mediaplan_id = 1 (Яндекс.Директ)

INSERT INTO kpi_data (campaign_id, mediaplan_id, date, impressions, clicks, leads, cost)
VALUES
    (1, 1, '2026-06-01', 5200, 260, 5, 12500.00),
    (1, 1, '2026-06-02', 6100, 305, 7, 14700.00),
    (1, 1, '2026-06-03', 5900, 295, 6, 14200.00),
    (1, 1, '2026-06-04', 6300, 315, 8, 15100.00),
    (1, 1, '2026-06-05', 6700, 335, 9, 16000.00);

-- Расчет агрегированных показателей по медиаплану
SELECT
    mediaplan_id,
    SUM(impressions) as total_impressions,
    SUM(clicks) as total_clicks,
    SUM(leads) as total_leads,
    SUM(cost) as total_cost,
    ROUND(SUM(clicks) * 100.0 / NULLIF(SUM(impressions), 0), 2) as ctr_percent,
    ROUND(SUM(cost) / NULLIF(SUM(clicks), 0), 2) as avg_cpc,
    ROUND(SUM(cost) / NULLIF(SUM(leads), 0), 2) as cpl
FROM kpi_data
WHERE mediaplan_id = 1
GROUP BY mediaplan_id;