SELECT
  id,
  service,
  event,
  severity,
  description,
  created_at
FROM `flawless-window-499104-u9.ema_dev_events.raw_events`
ORDER BY created_at DESC
LIMIT 10;