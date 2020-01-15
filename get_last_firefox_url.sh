#!/bin/bash
sqlite3 ~/.mozilla/firefox/nnbmtdtc.default/places.sqlite 'select * from moz_places ORDER BY last_visit_date;' | cut -d"|" -f 2 | tail -n 1

