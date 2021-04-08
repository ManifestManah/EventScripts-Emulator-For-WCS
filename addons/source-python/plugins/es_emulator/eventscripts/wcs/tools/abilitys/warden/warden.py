import es
from wcs import wcsgroup
from wcs.xtell import tell


es.msg('warden loaded')


def warden():
	es.msg('warden 1')
	userid = str(es.ServerVar('wcs_userid'))
	count = int(wcsgroup.getUser(userid, 'ability_count'))

	if count:
		es.msg('warden 2')
		param = str(wcsgroup.getUser(userid, 'ability_parameter'))

		if param:
			es.msg('warden 3')
			param = param.split('_')
			team = int(es.getplayerteam(userid))

			if team == 2:
				teamtarget = '3'
				teamtargetn = '#ct'
				color = '255 0 10 150'

			elif team == 3:
				teamtarget = '2'
				teamtargetn = '#t'
				color = '10 0 255 150'

			es.msg('warden 4')
			x,y,z = es.getplayerlocation(userid)
			es.server.queuecmd('wcs_warden '+userid+' '+param[0]+' '+param[1]+' '+param[2]+' '+teamtarget+' '+teamtargetn+' '+str(x)+' '+str(y)+' '+str(z)+' '+str(es.ServerVar('wcs_roundcounter')))

			es.msg('warden 5')
			tell(userid, 'a_wardencreated')

		if count and not count == -1:
			es.msg('warden 6')
			wcsgroup.setUser(userid, 'ability_count', count-1)

	else:
		es.msg('warden 7')
		tell(userid, 'a_failed')
