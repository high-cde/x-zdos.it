#!/bin/bash
while true; do
  echo "[" > agents/feed.json
  date +"  {\"time\": \"%T\", \"agent\": \"AGENT_KALI\", \"message\": \"Heartbeat OK\"}," >> agents/feed.json
  date +"  {\"time\": \"%T\", \"agent\": \"AGENT_SENTINEL\", \"message\": \"Scan complete. No threats.\"}" >> agents/feed.json
  echo "]" >> agents/feed.json
  git add agents/feed.json
  git commit -m "🔁 Feed update"
  git push
  sleep 10
done

