-- FUNCTION: public._a_calc_satval3(timestamp without time zone, numeric, numeric, text)

-- DROP FUNCTION public._a_calc_satval3(timestamp without time zone, numeric, numeric, text);

CREATE OR REPLACE FUNCTION public._a_calc_satval3(
	in_dt timestamp without time zone,
	in_lat numeric,
	in_lon numeric,
	sc text)
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

if sc == 'npp':
  satid='37849'
elif sc == 'j01':
  satid='43013'
  
sp=SatPredict.SatPredict()
tle_dt=str(in_dt)[0:10]
satrec=sp.get_satrec(str(in_dt), str(satid))     
res=sp.propogate(satrec,sp.date2jd(dt.strptime(in_dt.split('.')[0],'%Y-%m-%d %H:%M:%S')),{'lon':float(in_lon),'lat':float(in_lat),'alt':0.1})

sat_val = {'sata': res['sata'],
		   'satz':res['satz'],
	 	   'dt':-1,'pt':'1900-01-01',
		   'distance':res['distance'],
		   'scan_angle':res['scanAngle']}
return json.dumps(sat_val)
$BODY$;

ALTER FUNCTION public._a_calc_satval3(timestamp without time zone, numeric, numeric, text)
    OWNER TO postgres;
