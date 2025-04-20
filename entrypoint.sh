#!/usr/bin/env bash
set -e

echo "等待 Postgres（$LETTA_PG_HOST:$LETTA_PG_PORT）…"
until pg_isready -h "$LETTA_PG_HOST" -p "$LETTA_PG_PORT" -U "$LETTA_PG_USER"; do
  sleep 1
done

echo "執行資料庫遷移…"
alembic upgrade head

echo "啟動 OpenTelemetry Collector…"
otelcol-contrib --config /etc/otel/config-file.yaml &

echo "啟動 Letta 服務…"
exec letta server --host 0.0.0.0 --port 8283
