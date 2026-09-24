1. Go to console.cloud.google.com and sign in.
2. Create a new query.
3. Always check the estimated bytes processed 
4. Explore the Dataset

```sql
SELECT *
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
LIMIT 10;
```

5. Aggregate Query

```sql
SELECT
  EXTRACT(YEAR FROM trip_start_timestamp) AS year,
  COUNT(*) AS total_trips,
  ROUND(AVG(fare), 2) AS avg_fare_usd,
  ROUND(AVG(trip_miles), 2) AS avg_miles
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE trip_start_timestamp IS NOT NULL
GROUP BY year
ORDER BY year DESC;
```

6. BigQuery stores data in columns, not rows. Selecting fewer columns = less data scanned = lower cost. 

```sql
SELECT * FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips` LIMIT 1000;

SELECT taxi_id, fare, tips
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
LIMIT 1000;
```

7. Create a Partitioned Table

```sql
CREATE SCHEMA IF NOT EXISTS `formal-incline-431300-v8.bq_lab`
OPTIONS (location = 'US');

CREATE OR REPLACE TABLE `formal-incline-431300-v8.bq_lab.taxi_optimized`
PARTITION BY DATE(trip_start_timestamp)
CLUSTER BY payment_type, company
AS
SELECT *
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE trip_start_timestamp >= '2022-01-01'
  AND trip_start_timestamp <  '2023-01-01';
```

8. Compare Query Cost 

```sql
SELECT COUNT(*), ROUND(AVG(fare),2) AS avg_fare
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE DATE(trip_start_timestamp) BETWEEN '2022-01-01' AND '2022-03-31'
  AND payment_type = 'Cash';


SELECT COUNT(*), ROUND(AVG(fare),2) AS avg_fare
FROM `formal-incline-431300-v8.bq_lab.taxi_optimized`
WHERE DATE(trip_start_timestamp) BETWEEN '2022-01-01' AND '2022-03-31'
  AND payment_type = 'Cash';
```

9. Create a Streaming Target Table

```sql
CREATE OR REPLACE TABLE `formal-incline-431300-v8.bq_lab.taxi_stream`
(
  event_id     STRING,
  event_ts     TIMESTAMP,
  payment_type STRING,
  fare         FLOAT64,
  tip          FLOAT64,
  company      STRING
)PARTITION BY DATE(event_ts);
```

```bash
pip install google-cloud-bigquery
```

```pyhon
from google.cloud import bigquery
import uuid, random
from datetime import datetime, timezone

client  = bigquery.Client(project='formal-incline-431300-v8')
table   = 'formal-incline-431300-v8.bq_lab.taxi_stream'

rows = [
    {
        'event_id':     str(uuid.uuid4()),
        'event_ts':     datetime.now(timezone.utc).isoformat(),
        'payment_type': random.choice(['Cash','Credit Card','Mobile']),
        'fare':         round(random.uniform(5, 50), 2),
        'tip':          round(random.uniform(0, 10), 2),
        'company':      random.choice(['Yellow Cab','Blue Ribbon','City Taxi'])
    }
    for _ in range(10)
]

errors = client.insert_rows_json(table, rows)
if errors:
    print('Errors:', errors)
else:
    print(f'Streamed {len(rows)} rows successfully')

```


10. Query the Streamed Data

```sql
SELECT *
FROM `formal-incline-431300-v8.bq_lab.taxi_stream`
ORDER BY event_ts DESC
LIMIT 20;
```

11. Monitor Ingestion

```sql
SELECT
  COUNT(*) AS total_rows,
  MIN(event_ts) AS first_event,
  MAX(event_ts) AS last_event,
  SUM(fare) AS total_fares
FROM `formal-incline-431300-v8.bq_lab.taxi_stream`;
```

12. Avoid Ongoing Storage Costs

```sql
DROP SCHEMA IF EXISTS `formal-incline-431300-v8.bq_lab` CASCADE;
```