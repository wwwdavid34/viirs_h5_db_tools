-- FUNCTION: public._a_calc_satval3(timestamp without time zone, text, text, numeric, numeric)

-- DROP FUNCTION public._a_calc_satval3(timestamp without time zone, text, text, numeric, numeric);

CREATE OR REPLACE FUNCTION public._a_calc_satval3(
	in_dt timestamp without time zone,
	tle_l1 text,
	tle_l2 text,
	in_lat numeric,
	in_lon numeric)
    RETURNS json
    LANGUAGE 'plpython3u'

    COST 100
    VOLATILE 
AS $BODY$                                           
from datetime import datetime as dt
from datetime import timedelta as td
import sys, json
sys.path.append('/eog/reference/python/SatPredict/')
sys.path.append('/eog/reference/python/SatPredict/jdcal')
import SatPredict

from sgp4 import io
from sgp4.earth_gravity import wgs72

sp=SatPredict.SatPredict()
tle_dt=str(in_dt)[0:10]
satrec=io.twoline2rv(tle_l1, tle_l2, wgs72)
try:
	res=sp.propogate(satrec,sp.date2jd(dt.strptime(in_dt.split('.')[0],'%Y-%m-%d %H:%M:%S')),{'lon':float(in_lon),'lat':float(in_lat),'alt':0.1})

	sat_val = {'sata': res['sata'],
			   'satz':res['satz'],
			   'dt':None,'pt':None,
			   'distance':res['distance'],
			   'scan_angle':res['scanAngle']}
except:
	sat_val = {'sata': None,
			   'satz':None,
			   'dt':-1,'pt':None,
			   'distance':None,
			   'scan_angle':None}
return json.dumps(sat_val)
$BODY$;

ALTER FUNCTION public._a_calc_satval3(timestamp without time zone, text, text, numeric, numeric)
    OWNER TO postgres;
