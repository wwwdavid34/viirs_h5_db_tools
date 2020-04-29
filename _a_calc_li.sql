-- FUNCTION: public._a_calc_li(timestamp without time zone, numeric, numeric)

-- DROP FUNCTION public._a_calc_li(timestamp without time zone, numeric, numeric);

CREATE OR REPLACE FUNCTION public._a_calc_li(
	in_dt timestamp without time zone,
	in_lat numeric,
	in_lon numeric)
    RETURNS numeric
    LANGUAGE 'plpython3u'

    COST 100
    VOLATILE 
AS $BODY$     
import sys

from datetime import datetime as dt
import sys, json
import numpy
sys.path.append('/eog/reference/python/')
from ngdc_lunar_illum import ngdc_lunar_illum

try:
	in_dt_parse=dt.strptime(in_dt.split('.')[0],'%Y-%m-%d %H:%M:%S')
	li = ngdc_lunar_illum(float(in_lon), float(in_lat),
						 in_dt_parse.year,
						 in_dt_parse.month,
						 in_dt_parse.day,
						 in_dt_parse.hour,
						 in_dt_parse.minute)
	return li[0]
except:
#	li=numpy.array([None])
	return None					 
#return json.dumps({'li':li[0]})
#return li[0]
$BODY$;

ALTER FUNCTION public._a_calc_li(timestamp without time zone, numeric, numeric)
    OWNER TO postgres;
