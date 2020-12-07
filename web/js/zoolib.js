/*
 * zoolib.js
 *
 * Javascript library for zoo.gr
 */

Zoo = window.Zoo || {};

Zoo.Event = window.Zoo.Event || {
	_handlers: {},

	subscribe: function(event, handler) {
		if(!this._handlers[event])
			this._handlers[event] = [];
		this._handlers[event].push(handler);
	},

	_fire: function(event) {
		var handlers = this._handlers[event];
		if(!handlers) return;

		var i;
		for(i = 0; i < handlers.length; i++)
			handlers[i]();
	}
};

Zoo.FB = window.Zoo.FB || {
	_inited: false,
	_onWindowBlock: null,

	_appId: null,
	_useXfbml: null,
	_forcePopup: null,

	// we wrap window.open to detect if a window is blocked
	_window_open: function(url, name, specs, replace) {
		// NOTE: this = window
		var handler = window._fb_open(url, name, specs, replace);

		var blocked = !handler || handler.closed || typeof handler.closed == 'undefined';
		if(blocked && Zoo.FB._onWindowBlock)
			Zoo.FB._onWindowBlock();
		Zoo.FB._onWindowBlock = null;

		return handler;
	},

	// loads facebook library
	init: function(options) {
		this._appId = options.appId;
		this._useXfbml = options.useXfbml;
		this._forcePopup = options.forcePopup;
		this._locale = options.locale;

		// this is called by facebook after initialization
		window.fbAsyncInit = function() {
			FB.init({
				appId  : Zoo.FB._appId,		// must be set in the page the loads this script
				version : options.version || 'v1.0',
				status : !Zoo.FB._forcePopup,// we need this for iframe dialogs for some reason
				cookie : true,				// enable cookies to allow the server to access the session
				xfbml  : Zoo.FB._useXfbml,	// parse XFBML, must be set in the page the loads this script
				frictionlessRequests : true,
  				hideFlashCallback : function(info) { Zoo.Canvas._onFlashHide(info) }
			});

			window.fbAsyncInit = null;
			Zoo.FB._inited = true;

			Zoo.Event._fire('Zoo.FB.init');
		};

		// this loads the library
		var e = document.createElement('script');
		e.src = document.location.protocol + '//connect.facebook.net/' + Zoo.FB._locale + '/sdk.js';
		e.async = true;
		document.getElementById('fb-root').appendChild(e);
	},

	login: function(resultHandler) {
		if(!this._inited) {
			this._sendResult(resultHandler, { status: 'not_inited' });
			return;
		};

		var opt = { scope: 'email' };

		this._onWindowBlock = function() {
			this._sendResult(resultHandler, { status: 'blocked' });
		};
		FB.login(function(response) {
			Zoo.Util.log('FB.login response', response);

			Zoo.FB._onWindowBlock = null;
			var res = { status: response.authResponse ? 'ok' : 'cancelled' };
			Zoo.FB._sendResult(resultHandler, res);
		}, opt);
	},

	getPermissions: function(resultHandler, perms) {
		if(!this._inited) {
			this._sendResult(resultHandler, { status: 'not_inited' });
			return;
		};

		var opt = {
			scope: perms.join(','),
    		auth_type: 'rerequest',
			display: this._forcePopup ? 'popup' : 'iframe'
		};

		this._onWindowBlock = function() {
			this._sendResult(resultHandler, { status: 'blocked' });
		};
		FB.login(function(response) {
			Zoo.Util.log('FB.login response', response);

			// check that the user game the requested permissions
			//
			FB.api('/me/permissions', function(response) {
				var res = { status: 'ok' };
				var myperms = response.data;

				// check that all perms are granted
				for(var i = 0; i < perms.length; i++) {
					var rec = null;
					for(var j = 0; j < myperms.length; j++)
						if(myperms[j].permission == perms[i]) {
							rec = myperms[j];
							break;
						}
					if(!(rec && rec.status == 'granted')) {
						res.status = 'cancelled';
						break;
					}
				}

				Zoo.FB._onWindowBlock = null;
				Zoo.FB._sendResult(resultHandler, res);
			});
		}, opt);
	},

	refreshLoginState: function(resultHandler) {
		if(!this._inited) {
			this._sendResult(resultHandler, { status: 'not_inited' });
			return;
		};

		FB.getLoginStatus(function(response) {
			var res = { status: 'ok' };
			Zoo.FB._sendResult(resultHandler, res);
		}, true); // force
	},

	// obsolete, 2delete
	getEmailPermission: function(resultHandler) {
		return this.login(resultHandler);
	},

	// deprecated
	streamPublish: function(resultHandler, params) {
		params.method = 'stream.publish';
		params.display = this._forcePopup ? 'popup' : 'iframe';

		this._onWindowBlock = function() {
			this._sendResult(resultHandler, { status: 'blocked' });
		};
		FB.ui(params, function(response) {
			Zoo.FB._onWindowBlock = null;
			var res = { status: response && response.post_id ? 'ok' : 'cancelled' };
			Zoo.FB._sendResult(resultHandler, res);
		});
	},

	/* uiFeed
	params: {
		link: 'http://google.com/',
		picture: 'http://upload.wikimedia.org/wikipedia/commons/b/bc/Sdf_060304.jpg',
		name: 'The name',
		caption: 'The caption <b>bold</b> <a href="www.google.com">link</a>',
		description: 'The description <b>bold</b> <a href="www.google.com">link</a>',
		properties: {
			Property1: 'no link',
			Property2: { text: 'with link', href: 'http://www.google.com' }
		},
		actions: [
			{ name: 'Action1', link: 'http://www.google.com' }
		],
		ref: 'test',
		to: null
	}
	*/
	uiFeed: function(resultHandler, params) {
		if(!params.ref) throw 'params.ref is needed';

		params.method = 'feed';
		params.display = this._forcePopup ? 'popup' : 'iframe';

		this._onWindowBlock = function() {
			this._sendResult(resultHandler, { status: 'blocked' });
		};
		FB.ui(params, function(response) {
			Zoo.FB._onWindowBlock = null;
			var res = { status: response && response.post_id ? 'ok' : 'cancelled', data: response };
			Zoo.FB._sendResult(resultHandler, res);
		});
	},

	/* uiAppRequest
	params: {
		message: 'a message',
		title: 'a title',
		to: '100003439138397,100003432803002',
		filters: '',
		exclude_ids: [],
		max_recipients: 20,
		data: 'test'
	}
	*/
	uiAppRequest: function(resultHandler, params) {
		params.method = 'apprequests';
		params.display = this._forcePopup ? 'popup' : 'iframe';

		this._onWindowBlock = function() {
			this._sendResult(resultHandler, { status: 'blocked' });
		};
		FB.ui(params, function(response) {
			Zoo.FB._onWindowBlock = null;
			var res = { status: response && response.request ? 'ok' : 'cancelled', data: response };
			Zoo.FB._sendResult(resultHandler, res);
		});
	},


	// deprecated
	shareLink: function(resultHandler, url) {
		this.uiSend(resultHandler, { link: url });
	},

	/* uiSend
	params: {
		link: 'http://www.google.com',
		name: 'foo',
		description: '...',
		picture: 'http://upload.wikimedia.org/wikipedia/commons/b/bc/Sdf_060304.jpg',
		to: '100003432803002'
	};
	*/
	uiSend: function(resultHandler, params) {
		params.method = 'feed';
		params.display = this._forcePopup ? 'popup' : 'iframe';

		this._onWindowBlock = function() {
			this._sendResult(resultHandler, { status: 'blocked' });
		};
		FB.ui(params, function(response) {
			Zoo.FB._onWindowBlock = null;
			var res = { status: response && response.post_id ? 'ok' : 'cancelled', data: response };
			Zoo.FB._sendResult(resultHandler, res);
		});
	},

	pay: function(resultHandler, data) {
		data.method = 'pay';
		data.action = 'purchaseitem';

		this._onWindowBlock = function() {
			this._sendResult(resultHandler, { status: 'blocked' });
		};
		FB.ui(data, function(response) {
			Zoo.FB._onWindowBlock = null;
			var res = { status: response && !response.error_code ? 'ok' : 'cancelled', data: response };
			Zoo.FB._sendResult(resultHandler, res);
		});
	},

	// generic dialog for inviting new friends
	//
	inviteFriends: function() {
		this.uiAppRequest(null, { message: '.', filters: ['app_non_users', 'all'] });
	},

	_sendResult: function(handler, res) {
		if(!handler) return;
		if(typeof(handler) == 'string') {
			Zoo.Util.log('calling flash handler ' + handler, res);
			var swf = document.getElementById('zoo_swf');
			swf[handler](res);
		} else {
			Zoo.Util.log('calling js handler with res', res);
			handler(res);
		}
	}
};

Zoo.Canvas = window.Zoo.Canvas || {
	autoResize: function() {
		window.onresize = function() {
			FB.Canvas.getPageInfo(
				function(info) {
					Zoo.Util.log('FB.Canvas.getPageInfo', info);
					var elem = document.getElementById('allContent');
					elem.style.height = (info.clientHeight - info.offsetTop) + 'px';
					FB.Canvas.setSize();
				}
			);
		};
		Zoo.Event.subscribe('Zoo.FB.init', window.onresize);
	},

	forwardWheelEvents: function() {
		// set event handler
		if(window.addEventListener)
			window.addEventListener("DOMMouseScroll", this._handleWheel, false);
		if (document.attachEvent)	//if IE (and Opera depending on user setting)
			document.attachEvent('onmousewheel', this._hadleWheel);
		window.onmousewheel = document.onmousewheel = this._handleWheel;
	},

	_handleWheel : function(e) {
		var swf = document.getElementById('zoo_swf');
		swf.handleWheel({
			x: e.screenX,
			y: e.screenY,
			delta: e.detail,
			ctrlKey: e.ctrlKey,
			altKey: e.altKey,
			shiftKey: e.shiftKey
		});

		// cancel the event's default behaviour
		if(e.preventDefault) e.preventDefault();	// necessary for addEventListener, works with traditional
		e.returnValue = false; 						// necessary for attachEvent, works with traditional
		return false;								// works with traditional, not with attachEvent or addEventListener	
	},

	_onFlashHide : function(info) {
		if(info.state == "opened")
			this._pauseFlash();
		else
			this._resumeFlash();
	},

	_pauseFlash : function() {
		if(this._pausePending || this._flashIsPaused) return;
		this._pausePending = true;
		this._flashIsPaused = true;

		try {
			document.getElementById("zoo_swf").pause();
		} catch(e) {
		}

		document.getElementById('screenshot').style.display = 'none';
		document.getElementById('flashContent').style.top = '-10000px';
		document.getElementById('imageContent').style.top = '';
		document.getElementById('pauseLoading').style.display = '';
	},

	setFlashScreenshot : function(data) {
		if(!this._pausePending) return;
		pausePending = false;

		var imageContent = document.getElementById("imageContent");
		var flashContent = document.getElementById("flashContent")
		var screenshot = document.getElementById("screenshot");

		document.getElementById('pauseLoading').style.display = 'none';

		var imageData = "data:image/jpeg;base64," + data;

		screenshot.src = imageData.toString();
		screenshot.style.display = '';
	},

	_resumeFlash : function() {
		if(!this._flashIsPaused) return;

		document.getElementById('flashContent').style.top = '';
		document.getElementById('imageContent').style.top = '-10000px';
		document.getElementById('screenshot').style.display = 'none';

		try {
			document.getElementById("zoo_swf").resume();
		} catch(e) {
		}

		this._pausePending = false;
		this._flashIsPaused = false;
	}
};

Zoo.Util = window.Zoo.Util || {
	_blank_windows: {},

	log: function(a, b, c, d, e) {
		if(window.console) {
			// IE does not like console.log.apply
			window.console.log(a, b||'', c||'', d||'', e||'');
		}
	},

	openWindow: function(url, options, name) {
		if(this._blank_windows[name]) {
			// use blank window
			this._blank_windows[name].location = url;
			this._blank_windows[name].focus();
			delete this._blank_windows[name];

		} else if(!url) {
			// open blank window
			this._blank_windows[name] = window.open('', '_blank', options);

		} else {
			window.open(url, name || '_blank', options);
		}
	},

	_callAPI: function(method, args, sid, handler) {
		var rpc = new jsonrpc.JsonRpc('/jsonrpc/api?sid='+sid);
		args.unshift(method);
		args.push({
			success: function (result) {
				handler(result)
			},
			failure: function (reason, error) {
				Zoo.Util.log(method + " failed: ", reason, error.data);
				handler({ error: reason })
			}
		});
		rpc.call.apply(rpc, args);
	}
};

Zoo.Storage = window.Zoo.Storage || {
	_get_store: function() {
		if(!this._store) {
			Persist.remove('flash');
			this._store = new Persist.Store('Zoo');
		}
		return this._store;
	},

	get: function(key) {
		var v = this._get_store().get(key);
		try {
			v = JSON.parse(v);
		} catch(e) {
			Zoo.Util.log('Zoo.Storage.get', 'cannot parse "'+v+'": '+e);
			v = null;
		}
		return v;
	},

	set: function(key, value) {
		if(value === undefined)
			value = null;
		var v = JSON.stringify(value);
		this._get_store().set(key, v);
	}
};

Zoo.Analytics = window.Zoo.Analytics || {
	init: function(options) {
		var domain = '.' + document.domain.match(/[^.]*\.[^.]*$/)[0];		// top-level domain

		window._gaq = window._gaq || [];
		_gaq.push(['_setAccount', options.account]);
		_gaq.push(['_setDomainName', domain]);
		_gaq.push(['_trackPageview']);

		var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);

		Zoo.Util.log('Zoo.Analytics.init', options);
	},

	trackPageview: function(url) {
		_gaq.push(['_trackPageview', url]);

		Zoo.Util.log('Zoo.Analytics.trackPageview', url);
	}
}

// we wrap window.open to detect if a window is blocked
window._fb_open = window.open;
window.open = Zoo.FB._window_open;

// for compatibility we have a top-level openWindow
window.openWindow = Zoo.Util.openWindow;


/*** embed libraries to avoid having too many .js files ***/
/* json2.js 
 * 2008-01-17
 * Public Domain
 * No warranty expressed or implied. Use at your own risk.
 * See http://www.JSON.org/js.html
*/
if(!this.JSON){JSON=function(){function f(n){return n<10?'0'+n:n;}
Date.prototype.toJSON=function(){return this.getUTCFullYear()+'-'+
f(this.getUTCMonth()+1)+'-'+
f(this.getUTCDate())+'T'+
f(this.getUTCHours())+':'+
f(this.getUTCMinutes())+':'+
f(this.getUTCSeconds())+'Z';};var m={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'};function stringify(value,whitelist){var a,i,k,l,r=/["\\\x00-\x1f\x7f-\x9f]/g,v;switch(typeof value){case'string':return r.test(value)?'"'+value.replace(r,function(a){var c=m[a];if(c){return c;}
c=a.charCodeAt();return'\\u00'+Math.floor(c/16).toString(16)+
(c%16).toString(16);})+'"':'"'+value+'"';case'number':return isFinite(value)?String(value):'null';case'boolean':case'null':return String(value);case'object':if(!value){return'null';}
if(typeof value.toJSON==='function'){return stringify(value.toJSON());}
a=[];if(typeof value.length==='number'&&!(value.propertyIsEnumerable('length'))){l=value.length;for(i=0;i<l;i+=1){a.push(stringify(value[i],whitelist)||'null');}
return'['+a.join(',')+']';}
if(whitelist){l=whitelist.length;for(i=0;i<l;i+=1){k=whitelist[i];if(typeof k==='string'){v=stringify(value[k],whitelist);if(v){a.push(stringify(k)+':'+v);}}}}else{for(k in value){if(typeof k==='string'){v=stringify(value[k],whitelist);if(v){a.push(stringify(k)+':'+v);}}}}
return'{'+a.join(',')+'}';}}
return{stringify:stringify,parse:function(text,filter){var j;function walk(k,v){var i,n;if(v&&typeof v==='object'){for(i in v){if(Object.prototype.hasOwnProperty.apply(v,[i])){n=walk(i,v[i]);if(n!==undefined){v[i]=n;}}}}
return filter(k,v);}
if(/^[\],:{}\s]*$/.test(text.replace(/\\./g,'@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']').replace(/(?:^|:|,)(?:\s*\[)+/g,''))){j=eval('('+text+')');return typeof filter==='function'?walk('',j):j;}
throw new SyntaxError('parseJSON');}};}();}

/* persist-min.js */
(function(){if(window.google&&google.gears)
return;var F=null;if(typeof GearsFactory!='undefined'){F=new GearsFactory();}else{try{F=new ActiveXObject('Gears.Factory');if(F.getBuildInfo().indexOf('ie_mobile')!=-1)
F.privateSetGlobalObject(this);}catch(e){if((typeof navigator.mimeTypes!='undefined')&&navigator.mimeTypes["application/x-googlegears"]){F=document.createElement("object");F.style.display="none";F.width=0;F.height=0;F.type="application/x-googlegears";document.documentElement.appendChild(F);}}}
if(!F)
return;if(!window.google)
google={};if(!google.gears)
google.gears={factory:F};})();Persist=(function(){var VERSION='0.2.0',P,B,esc,init,empty,ec;ec=(function(){var EPOCH='Thu, 01-Jan-1970 00:00:01 GMT',RATIO=1000*60*60*24,KEYS=['expires','path','domain'],esc=escape,un=unescape,doc=document,me;var get_now=function(){var r=new Date();r.setTime(r.getTime());return r;}
var cookify=function(c_key,c_val){var i,key,val,r=[],opt=(arguments.length>2)?arguments[2]:{};r.push(esc(c_key)+'='+esc(c_val));for(i=0;i<KEYS.length;i++){key=KEYS[i];if(val=opt[key])
r.push(key+'='+val);}
if(opt.secure)
r.push('secure');return r.join('; ');}
var alive=function(){var k='__EC_TEST__',v=new Date();v=v.toGMTString();this.set(k,v);this.enabled=(this.remove(k)==v);return this.enabled;}
me={set:function(key,val){var opt=(arguments.length>2)?arguments[2]:{},now=get_now(),expire_at,cfg={};if(opt.expires){var expires=opt.expires*RATIO;cfg.expires=new Date(now.getTime()+expires);cfg.expires=cfg.expires.toGMTString();}
var keys=['path','domain','secure'];for(i=0;i<keys.length;i++)
if(opt[keys[i]])
cfg[keys[i]]=opt[keys[i]];var r=cookify(key,val,cfg);doc.cookie=r;return val;},has:function(key){key=esc(key);var c=doc.cookie,ofs=c.indexOf(key+'='),len=ofs+key.length+1,sub=c.substring(0,key.length);return((!ofs&&key!=sub)||ofs<0)?false:true;},get:function(key){key=esc(key);var c=doc.cookie,ofs=c.indexOf(key+'='),len=ofs+key.length+1,sub=c.substring(0,key.length),end;if((!ofs&&key!=sub)||ofs<0)
return null;end=c.indexOf(';',len);if(end<0)
end=c.length;return un(c.substring(len,end));},remove:function(k){var r=me.get(k),opt={expires:EPOCH};doc.cookie=cookify(k,'',opt);return r;},keys:function(){var c=doc.cookie,ps=c.split('; '),i,p,r=[];for(i=0;i<ps.length;i++){p=ps[i].split('=');r.push(un(p[0]));}
return r;},all:function(){var c=doc.cookie,ps=c.split('; '),i,p,r=[];for(i=0;i<ps.length;i++){p=ps[i].split('=');r.push([un(p[0]),un(p[1])]);}
return r;},version:'0.2.1',enabled:false};me.enabled=alive.call(me);return me;}());var index_of=(function(){if(Array.prototype.indexOf)
return function(ary,val){return Array.prototype.indexOf.call(ary,val);};else
return function(ary,val){var i,l;for(i=0,l=ary.length;i<l;i++)
if(ary[i]==val)
return i;return-1;};})();empty=function(){};esc=function(str){return'PS'+str.replace(/_/g,'__').replace(/ /g,'_s');};C={search_order:['localstorage','globalstorage','gears','cookie','ie','flash'],name_re:/^[a-z][a-z0-9_ -]+$/i,methods:['init','get','set','remove','load','save','iterate'],sql:{version:'1',create:"CREATE TABLE IF NOT EXISTS persist_data (k TEXT UNIQUE NOT NULL PRIMARY KEY, v TEXT NOT NULL)",get:"SELECT v FROM persist_data WHERE k = ?",set:"INSERT INTO persist_data(k, v) VALUES (?, ?)",remove:"DELETE FROM persist_data WHERE k = ?",keys:"SELECT * FROM persist_data"},flash:{div_id:'_persist_flash_wrap',id:'_persist_flash',path:'persist.swf',size:{w:1,h:1},args:{autostart:true}}};B={gears:{size:-1,test:function(){return(window.google&&window.google.gears)?true:false;},methods:{init:function(){var db;db=this.db=google.gears.factory.create('beta.database');db.open(esc(this.name));db.execute(C.sql.create).close();},get:function(key){var r,sql=C.sql.get;var db=this.db;var ret;db.execute('BEGIN').close();r=db.execute(sql,[key]);ret=r.isValidRow()?r.field(0):null;r.close();db.execute('COMMIT').close();return ret;},set:function(key,val){var rm_sql=C.sql.remove,sql=C.sql.set,r;var db=this.db;var ret;db.execute('BEGIN').close();db.execute(rm_sql,[key]).close();db.execute(sql,[key,val]).close();db.execute('COMMIT').close();return val;},remove:function(key){var get_sql=C.sql.get;sql=C.sql.remove,r,val=null,is_valid=false;var db=this.db;db.execute('BEGIN').close();db.execute(sql,[key]).close();db.execute('COMMIT').close();return true;},iterate:function(fn,scope){var key_sql=C.sql.keys;var r;var db=this.db;r=db.execute(key_sql);while(r.isValidRow()){fn.call(scope||this,r.field(0),r.field(1));r.next();}
r.close();}}},globalstorage:{size:5*1024*1024,test:function(){return window.globalStorage?true:false;},methods:{key:function(key){return esc(this.name)+esc(key);},init:function(){this.store=globalStorage[this.o.domain];},get:function(key){key=this.key(key);return this.store.getItem(key);},set:function(key,val){key=this.key(key);this.store.setItem(key,val);return val;},remove:function(key){var val;key=this.key(key);val=this.store[key];this.store.removeItem(key);return val;}}},localstorage:{size:-1,test:function(){return window.localStorage?true:false;},methods:{key:function(key){return this.name+'>'+key;},init:function(){this.store=localStorage;},get:function(key){key=this.key(key);return this.store.getItem(key);},set:function(key,val){key=this.key(key);this.store.setItem(key,val);return val;},remove:function(key){var val;key=this.key(key);val=this.store.getItem(key);this.store.removeItem(key);return val;},iterate:function(fn,scope){var l=this.store;for(i=0;i<l.length;i++){keys=l[i].split('>');if((keys.length==2)&&(keys[0]==this.name)){fn.call(scope||this,keys[1],l[l[i]]);}}}}},ie:{prefix:'_persist_data-',size:64*1024,test:function(){return window.ActiveXObject?true:false;},make_userdata:function(id){var el=document.createElement('div');el.id=id;el.style.display='none';el.addBehavior('#default#userdata');document.body.appendChild(el);return el;},methods:{init:function(){var id=B.ie.prefix+esc(this.name);this.el=B.ie.make_userdata(id);if(this.o.defer)
this.load();},get:function(key){var val;key=esc(key);if(!this.o.defer)
this.load();val=this.el.getAttribute(key);return val;},set:function(key,val){key=esc(key);this.el.setAttribute(key,val);if(!this.o.defer)
this.save();return val;},remove:function(key){var val;key=esc(key);if(!this.o.defer)
this.load();val=this.el.getAttribute(key);this.el.removeAttribute(key);if(!this.o.defer)
this.save();return val;},load:function(){this.el.load(esc(this.name));},save:function(){this.el.save(esc(this.name));}}},cookie:{delim:':',size:4000,test:function(){return P.Cookie.enabled?true:false;},methods:{key:function(key){return this.name+B.cookie.delim+key;},get:function(key,fn){var val;key=this.key(key);val=ec.get(key);return val;},set:function(key,val,fn){key=this.key(key);ec.set(key,val,this.o);return val;},remove:function(key,val){var val;key=this.key(key);val=ec.remove(key);return val;}}},flash:{test:function(){if(!deconcept||!deconcept.SWFObjectUtil)
return false;var major=deconcept.SWFObjectUtil.getPlayerVersion().major;return(major>=8)?true:false;},methods:{init:function(){if(!B.flash.el){var o,key,el,cfg=C.flash;el=document.createElement('div');el.id=cfg.div_id;document.body.appendChild(el);o=new deconcept.SWFObject(this.o.swf_path||cfg.path,cfg.id,cfg.size.w,cfg.size.h,'8');for(key in cfg.args)
o.addVariable(key,cfg.args[key]);o.write(el);B.flash.el=document.getElementById(cfg.id);}
this.el=B.flash.el;},get:function(key){var val;key=esc(key);val=this.el.get(this.name,key);return val;},set:function(key,val){var old_val;key=esc(key);old_val=this.el.set(this.name,key,val);return old_val;},remove:function(key){var val;key=esc(key);val=this.el.remove(this.name,key);return val;}}}};var init=function(){var i,l,b,key,fns=C.methods,keys=C.search_order;for(i=0,l=fns.length;i<l;i++)
P.Store.prototype[fns[i]]=empty;P.type=null;P.size=-1;for(i=0,l=keys.length;!P.type&&i<l;i++){b=B[keys[i]];if(b.test()){P.type=keys[i];P.size=b.size;for(key in b.methods)
P.Store.prototype[key]=b.methods[key];}}
P._init=true;};P={VERSION:VERSION,type:null,size:0,add:function(o){B[o.id]=o;C.search_order=[o.id].concat(C.search_order);init();},remove:function(id){var ofs=index_of(C.search_order,id);if(ofs<0)
return;C.search_order.splice(ofs,1);delete B[id];init();},Cookie:ec,Store:function(name,o){if(!C.name_re.exec(name))
throw new Error("Invalid name");if(!P.type)
throw new Error("No suitable storage found");o=o||{};this.name=name;o.domain=o.domain||location.hostname||'localhost';o.domain=o.domain.replace(/:\d+$/,'')
o.domain=(o.domain=='localhost')?'':o.domain;this.o=o;o.expires=o.expires||365*2;o.path=o.path||'/';this.init();}};init();return P;})();

// jsonrpc (https://github.com/gimmi/jsonrpcjs, with modifications by Kostas)
jsonrpc={CallStack:function(a,c,b,d){this._counter=0;this._enterFn=a;this._exitFn=b;this._enterScope=c;this._exitScope=d}};jsonrpc.CallStack.prototype={enter:function(){this._counter=0>this._counter?1:this._counter+1;1===this._counter&&this._enterFn.apply(this._enterScope,arguments)},exit:function(a){this._counter-=1;0===this._counter&&this._exitFn.apply(this._exitScope,arguments)}};jsonrpc.DelayedTask=function(a,c,b){this._fn=a||function(){};this._scope=c||void 0;this._args=b||[];this._id=null};
jsonrpc.DelayedTask.prototype={delay:function(a,c,b,d){var e=this;this._fn=c||this._fn;this._scope=b||this._scope;this._args=d||this._args;this.cancel();this._id=window.setInterval(function(){window.clearInterval(e._id);e._id=null;e._fn.apply(e._scope,e._args)},a)},cancel:function(){this._id&&(window.clearInterval(this._id),this._id=null)}};
jsonrpc.JsonRpc=function(a){this._url=a;this.loading=new jsonrpc.Observable;this.loaded=new jsonrpc.Observable;this.unhandledFailure=new jsonrpc.Observable;this._loadingState=new jsonrpc.CallStack(this.loading.trigger,this.loading,this.loaded.trigger,this.loaded);this._requests=[];this._batchingMilliseconds=10;this._delayedTask=new jsonrpc.DelayedTask};
jsonrpc.JsonRpc.prototype={setBatchingMilliseconds:function(a){this._batchingMilliseconds=a},call:function(){var a=this._getParams.apply(this,arguments);this._loadingState.enter();this._requests.push(a);this._batchingMilliseconds?this._delayedTask.delay(this._batchingMilliseconds,this._sendRequests,this):this._sendRequests()},_sendRequests:function(){var a=this,c=this._requests,b=[],d;this._requests=[];for(d=0;d<c.length;d+=1)c[d].request.id=d,b.push(c[d].request);1===b.length&&(b=b[0]);a._doJsonPost(a._url,
b,function(b,f){var g;if(b)g=a._isArray(f)?f:[f];else{g=[];for(d=0;d<c.length;d+=1)g[d]={id:d,error:{message:f}}}a._handleResponses(c,g)})},_handleResponses:function(a,c){var b,d,e;for(b=0;b<c.length;b+=1)d=c[b],e=a[d.id],this._handleResponse(e,d)},_handleResponse:function(a,c){var b=!c.error,d=b?c.result:c.error.message;this._loadingState.exit();b?a.success.call(a.scope,d):a.failure.call(a.scope,d,c.error);a.callback.call(a.scope,b,d)},_getParams:function(){var a=this,c=Array.prototype.slice.call(arguments),
b={request:{jsonrpc:"2.0",method:c.shift()}};for(b.request.params=[];1<c.length&&!this._isFunction(c[0]);)b.request.params.push(c.shift());this._isFunction(c[0])?(b.success=c[0],b.scope=c[1]):(b.success=c[0].success,b.failure=c[0].failure,b.callback=c[0].callback,b.scope=c[0].scope);b.success=b.success||function(){};b.failure=b.failure||function(){a.unhandledFailure.trigger.apply(a.unhandledFailure,arguments)};b.callback=b.callback||function(){};return b},_isArray:function(a){return"[object Array]"===
Object.prototype.toString.apply(a)},_isFunction:function(a){return"[object Function]"===Object.prototype.toString.apply(a)},_doJsonPost:function(a,c,b){var d=(new URI(a)).hostname(),d=d&&d!=(new URI(location.href)).hostname(),e=new XMLHttpRequest;if(!d||"withCredentials"in e)e.open("POST",a,!0),e.setRequestHeader("Content-Type","application/json"),e.onreadystatechange=function(){if(4===e.readyState){var a=e.getResponseHeader("Content-Type");200!==e.status?b(!1,'Expected HTTP response "200 OK", found "'+
e.status+" "+e.statusText+'"'):0!==a.indexOf("application/json")?b(!1,'Expected JSON encoded response, found "'+a+'"'):b(!0,JSON.parse(this.responseText))}},e.send(JSON.stringify(c));else if("undefined"!=typeof XDomainRequest)e=new XDomainRequest,e.open("POST",a),e.onerror=function(){b(!1,"request failed: "+this.responseText)},e.onload=function(){b(!0,JSON.parse(this.responseText))},e.send(JSON.stringify(c));else throw"crossdomain AJAX calls not supported";}};
jsonrpc.Observable=function(){this._listeners=[]};jsonrpc.Observable.prototype={bind:function(a,c){var b={fn:a,scope:c||this};this._listeners.push(b);return b},unbind:function(a){a=this._listeners.indexOf(a);-1!==a&&this._listeners.splice(a,1)},trigger:function(){var a;for(a=0;a<this._listeners.length;a+=1)this._listeners[a].fn.apply(this._listeners[a].scope,arguments)}};

/*! URI.js v1.10.2 http://medialize.github.com/URI.js/ */
/* build contains: URI.js */
(function(e,t){if(typeof exports==="object"){module.exports=t(require("./punycode"),require("./IPv6"),require("./SecondLevelDomains"))}else if(typeof define==="function"&&define.amd){define(["./punycode","./IPv6","./SecondLevelDomains"],t)}else{e.URI=t(e.punycode,e.IPv6,e.SecondLevelDomains)}})(this,function(e,t,n){"use strict";function r(e,t){if(!(this instanceof r)){return new r(e,t)}if(e===undefined){if(typeof location!=="undefined"){e=location.href+""}else{e=""}}this.href(e);if(t!==undefined){return this.absoluteTo(t)}return this}function o(e){return e.replace(/([.*+?^=!:${}()|[\]\/\\])/g,"\\$1")}function u(e){return String(Object.prototype.toString.call(e)).slice(8,-1)}function a(e){return u(e)==="Array"}function f(e,t){var n={};var r,i;if(a(t)){for(r=0,i=t.length;r<i;r++){n[t[r]]=true}}else{n[t]=true}for(r=0,i=e.length;r<i;r++){if(n[e[r]]!==undefined){e.splice(r,1);i--;r--}}return e}function l(e,t){var n,r;if(a(t)){for(n=0,r=t.length;n<r;n++){if(!l(e,t[n])){return false}}return true}var i=u(t);for(n=0,r=e.length;n<r;n++){if(i==="RegExp"){if(typeof e[n]==="string"&&e[n].match(t)){return true}}else if(e[n]===t){return true}}return false}function c(e,t){if(!a(e)||!a(t)){return false}if(e.length!==t.length){return false}e.sort();t.sort();for(var n=0,r=e.length;n<r;n++){if(e[n]!==t[n]){return false}}return true}function h(e){return encodeURIComponent(e).replace(/[!'()*]/g,escape).replace(/\*/g,"%2A")}var i=r.prototype;var s=Object.prototype.hasOwnProperty;r._parts=function(){return{protocol:null,username:null,password:null,hostname:null,urn:null,port:null,path:null,query:null,fragment:null,duplicateQueryParameters:r.duplicateQueryParameters}};r.duplicateQueryParameters=false;r.protocol_expression=/^[a-z][a-z0-9-+-]*$/i;r.idn_expression=/[^a-z0-9\.-]/i;r.punycode_expression=/(xn--)/i;r.ip4_expression=/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;r.ip6_expression=/^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/;r.find_uri_expression=/\b((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))/ig;r.defaultPorts={http:"80",https:"443",ftp:"21",gopher:"70",ws:"80",wss:"443"};r.invalid_hostname_characters=/[^a-zA-Z0-9\.-]/;r.encode=h;r.decode=decodeURIComponent;r.iso8859=function(){r.encode=escape;r.decode=unescape};r.unicode=function(){r.encode=h;r.decode=decodeURIComponent};r.characters={pathname:{encode:{expression:/%(24|26|2B|2C|3B|3D|3A|40)/ig,map:{"%24":"$","%26":"&","%2B":"+","%2C":",","%3B":";","%3D":"=","%3A":":","%40":"@"}},decode:{expression:/[\/\?#]/g,map:{"/":"%2F","?":"%3F","#":"%23"}}},reserved:{encode:{expression:/%(21|23|24|26|27|28|29|2A|2B|2C|2F|3A|3B|3D|3F|40|5B|5D)/ig,map:{"%3A":":","%2F":"/","%3F":"?","%23":"#","%5B":"[","%5D":"]","%40":"@","%21":"!","%24":"$","%26":"&","%27":"'","%28":"(","%29":")","%2A":"*","%2B":"+","%2C":",","%3B":";","%3D":"="}}}};r.encodeQuery=function(e){return r.encode(e+"").replace(/%20/g,"+")};r.decodeQuery=function(e){return r.decode((e+"").replace(/\+/g,"%20"))};r.recodePath=function(e){var t=(e+"").split("/");for(var n=0,i=t.length;n<i;n++){t[n]=r.encodePathSegment(r.decode(t[n]))}return t.join("/")};r.decodePath=function(e){var t=(e+"").split("/");for(var n=0,i=t.length;n<i;n++){t[n]=r.decodePathSegment(t[n])}return t.join("/")};var p={encode:"encode",decode:"decode"};var d;var v=function(e,t){return function(n){return r[t](n+"").replace(r.characters[e][t].expression,function(n){return r.characters[e][t].map[n]})}};for(d in p){r[d+"PathSegment"]=v("pathname",p[d])}r.encodeReserved=v("reserved","encode");r.parse=function(e,t){var n,i;if(!t){t={}}n=e.indexOf("#");if(n>-1){t.fragment=e.substring(n+1)||null;e=e.substring(0,n)}n=e.indexOf("?");if(n>-1){t.query=e.substring(n+1)||null;e=e.substring(0,n)}if(e.substring(0,2)==="//"){t.protocol="";e=e.substring(2);e=r.parseAuthority(e,t)}else{n=e.indexOf(":");if(n>-1)
{t.protocol=e.substring(0,n);if(t.protocol&&!t.protocol.match(r.protocol_expression)){t.protocol=undefined}else if(t.protocol==="file"){e=e.substring(n+3)}else if(e.substring(n+1,n+3)==="//"){e=e.substring(n+3);e=r.parseAuthority(e,t)}else{e=e.substring(n+1);t.urn=true}}}t.path=e;return t};r.parseHost=function(e,t){var n=e.indexOf("/");var r;var i;if(n===-1){n=e.length}if(e.charAt(0)==="["){r=e.indexOf("]");t.hostname=e.substring(1,r)||null;t.port=e.substring(r+2,n)||null}else if(e.indexOf(":")!==e.lastIndexOf(":")){t.hostname=e.substring(0,n)||null;t.port=null}else{i=e.substring(0,n).split(":");t.hostname=i[0]||null;t.port=i[1]||null}if(t.hostname&&e.substring(n).charAt(0)!=="/"){n++;e="/"+e}return e.substring(n)||"/"};r.parseAuthority=function(e,t){e=r.parseUserinfo(e,t);return r.parseHost(e,t)};r.parseUserinfo=function(e,t){var n=e.indexOf("@");var i=e.indexOf("/");var s;if(n>-1&&(i===-1||n<i)){s=e.substring(0,n).split(":");t.username=s[0]?r.decode(s[0]):null;s.shift();t.password=s[0]?r.decode(s.join(":")):null;e=e.substring(n+1)}else{t.username=null;t.password=null}return e};r.parseQuery=function(e){if(!e){return{}}e=e.replace(/&+/g,"&").replace(/^\?*&*|&+$/g,"");if(!e){return{}}var t={};var n=e.split("&");var i=n.length;var s,o,u;for(var a=0;a<i;a++){s=n[a].split("=");o=r.decodeQuery(s.shift());u=s.length?r.decodeQuery(s.join("=")):null;if(t[o]){if(typeof t[o]==="string"){t[o]=[t[o]]}t[o].push(u)}else{t[o]=u}}return t};r.build=function(e){var t="";if(e.protocol){t+=e.protocol+":"}if(!e.urn&&(t||e.hostname)){t+="//"}t+=r.buildAuthority(e)||"";if(typeof e.path==="string"){if(e.path.charAt(0)!=="/"&&typeof e.hostname==="string"){t+="/"}t+=e.path}if(typeof e.query==="string"&&e.query){t+="?"+e.query}if(typeof e.fragment==="string"&&e.fragment){t+="#"+e.fragment}return t};r.buildHost=function(e){var t="";if(!e.hostname){return""}else if(r.ip6_expression.test(e.hostname)){if(e.port){t+="["+e.hostname+"]:"+e.port}else{t+=e.hostname}}else{t+=e.hostname;if(e.port){t+=":"+e.port}}return t};r.buildAuthority=function(e){return r.buildUserinfo(e)+r.buildHost(e)};r.buildUserinfo=function(e){var t="";if(e.username){t+=r.encode(e.username);if(e.password){t+=":"+r.encode(e.password)}t+="@"}return t};r.buildQuery=function(e,t){var n="";var i,o,u,f;for(o in e){if(s.call(e,o)&&o){if(a(e[o])){i={};for(u=0,f=e[o].length;u<f;u++){if(e[o][u]!==undefined&&i[e[o][u]+""]===undefined){n+="&"+r.buildQueryParameter(o,e[o][u]);if(t!==true){i[e[o][u]+""]=true}}}}else if(e[o]!==undefined){n+="&"+r.buildQueryParameter(o,e[o])}}}return n.substring(1)};r.buildQueryParameter=function(e,t){return r.encodeQuery(e)+(t!==null?"="+r.encodeQuery(t):"")};r.addQuery=function(e,t,n){if(typeof t==="object"){for(var i in t){if(s.call(t,i)){r.addQuery(e,i,t[i])}}}else if(typeof t==="string"){if(e[t]===undefined){e[t]=n;return}else if(typeof e[t]==="string"){e[t]=[e[t]]}if(!a(n)){n=[n]}e[t]=e[t].concat(n)}else{throw new TypeError("URI.addQuery() accepts an object, string as the name parameter")}};r.removeQuery=function(e,t,n){var i,o,u;if(a(t)){for(i=0,o=t.length;i<o;i++){e[t[i]]=undefined}}else if(typeof t==="object"){for(u in t){if(s.call(t,u)){r.removeQuery(e,u,t[u])}}}else if(typeof t==="string"){if(n!==undefined){if(e[t]===n){e[t]=undefined}else if(a(e[t])){e[t]=f(e[t],n)}}else{e[t]=undefined}}else{throw new TypeError("URI.addQuery() accepts an object, string as the first parameter")}};r.hasQuery=function(e,t,n,i){if(typeof t==="object"){for(var o in t){if(s.call(t,o)){if(!r.hasQuery(e,o,t[o])){return false}}}return true}else if(typeof t!=="string"){throw new TypeError("URI.hasQuery() accepts an object, string as the name parameter")}switch(u(n)){case"Undefined":return t in e;case"Boolean":var f=Boolean(a(e[t])?e[t].length:e[t]);return n===f;case"Function":return!!n(e[t],t,e);case"Array":if(!a(e[t])){return false}var h=i?l:c;return h(e[t],n);case"RegExp":if(!a(e[t])){return Boolean(e[t]&&e[t].match(n))}if(!i){return false}return l(e[t],n);case"Number":n=String(n);case"String":if(!a(e[t])){return e[t]===n}if(!i){return false}return l(e[t],n);default:throw new TypeError("URI.hasQuery() accepts undefined, boolean, string, number, RegExp, Function as the value parameter")}};r.commonPath=function(e,t){var n=Math.min(e.length,t.length);var r;for(r=0;r<n;r++){if(e.charAt(r)!==t.charAt(r)){r--;break}}if(r<1){return e.charAt(0)===t.charAt(0)&&e.charAt(0)==="/"?"/":""}if(e.charAt(r)!=="/"||t.charAt(r)!=="/"){r=e.substring(0,r).lastIndexOf("/")}return e.substring(0,r+1)};r.withinString=function(e,t){return e.replace(r.find_uri_expression,t)};r.ensureValidHostname=function(t){if(t.match(r.invalid_hostname_characters)){if(!e){throw new TypeError("Hostname '"+t+"' contains characters other than [A-Z0-9.-] and Punycode.js is not available")}if(e.toASCII(t).match(r.invalid_hostname_characters)){throw new TypeError("Hostname '"+t+"' contains characters other than [A-Z0-9.-]")}}};i.build=function(e){if(e===true){this._deferred_build=true}else if(e===undefined||this._deferred_build)
{this._string=r.build(this._parts);this._deferred_build=false}return this};i.clone=function(){return new r(this)};i.valueOf=i.toString=function(){return this.build(false)._string};p={protocol:"protocol",username:"username",password:"password",hostname:"hostname",port:"port"};v=function(e){return function(t,n){if(t===undefined){return this._parts[e]||""}else{this._parts[e]=t;this.build(!n);return this}}};for(d in p){i[d]=v(p[d])}p={query:"?",fragment:"#"};v=function(e,t){return function(n,r){if(n===undefined){return this._parts[e]||""}else{if(n!==null){n=n+"";if(n.charAt(0)===t){n=n.substring(1)}}this._parts[e]=n;this.build(!r);return this}}};for(d in p){i[d]=v(d,p[d])}p={search:["?","query"],hash:["#","fragment"]};v=function(e,t){return function(n,r){var i=this[e](n,r);return typeof i==="string"&&i.length?t+i:i}};for(d in p){i[d]=v(p[d][1],p[d][0])}i.pathname=function(e,t){if(e===undefined||e===true){var n=this._parts.path||(this._parts.urn?"":"/");return e?r.decodePath(n):n}else{this._parts.path=e?r.recodePath(e):"/";this.build(!t);return this}};i.path=i.pathname;i.href=function(e,t){var n;if(e===undefined){return this.toString()}this._string="";this._parts=r._parts();var i=e instanceof r;var o=typeof e==="object"&&(e.hostname||e.path);if(!i&&o&&e.pathname!==undefined){e=e.toString()}if(typeof e==="string"){this._parts=r.parse(e,this._parts)}else if(i||o){var u=i?e._parts:e;for(n in u){if(s.call(this._parts,n)){this._parts[n]=u[n]}}}else{throw new TypeError("invalid input")}this.build(!t);return this};i.is=function(e){var t=false;var i=false;var s=false;var o=false;var u=false;var a=false;var f=false;var l=!this._parts.urn;if(this._parts.hostname){l=false;i=r.ip4_expression.test(this._parts.hostname);s=r.ip6_expression.test(this._parts.hostname);t=i||s;o=!t;u=o&&n&&n.has(this._parts.hostname);a=o&&r.idn_expression.test(this._parts.hostname);f=o&&r.punycode_expression.test(this._parts.hostname)}switch(e.toLowerCase()){case"relative":return l;case"absolute":return!l;case"domain":case"name":return o;case"sld":return u;case"ip":return t;case"ip4":case"ipv4":case"inet4":return i;case"ip6":case"ipv6":case"inet6":return s;case"idn":return a;case"url":return!this._parts.urn;case"urn":return!!this._parts.urn;case"punycode":return f}return null};var m=i.protocol;var g=i.port;var y=i.hostname;i.protocol=function(e,t){if(e!==undefined){if(e){e=e.replace(/:(\/\/)?$/,"");if(e.match(/[^a-zA-z0-9\.+-]/)){throw new TypeError("Protocol '"+e+"' contains characters other than [A-Z0-9.+-]")}}}return m.call(this,e,t)};i.scheme=i.protocol;i.port=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(e!==undefined){if(e===0){e=null}if(e){e+="";if(e.charAt(0)===":"){e=e.substring(1)}if(e.match(/[^0-9]/)){throw new TypeError("Port '"+e+"' contains characters other than [0-9]")}}}return g.call(this,e,t)};i.hostname=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(e!==undefined){var n={};r.parseHost(e,n);e=n.hostname}return y.call(this,e,t)};i.host=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(e===undefined){return this._parts.hostname?r.buildHost(this._parts):""}else{r.parseHost(e,this._parts);this.build(!t);return this}};i.authority=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(e===undefined){return this._parts.hostname?r.buildAuthority(this._parts):""}else{r.parseAuthority(e,this._parts);this.build(!t);return this}};i.userinfo=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(e===undefined){if(!this._parts.username){return""}var n=r.buildUserinfo(this._parts);return n.substring(0,n.length-1)}else{if(e[e.length-1]!=="@"){e+="@"}r.parseUserinfo(e,this._parts);this.build(!t);return this}};i.resource=function(e,t){var n;if(e===undefined){return this.path()+this.search()+this.hash()}n=r.parse(e);this._parts.path=n.path;this._parts.query=n.query;this._parts.fragment=n.fragment;this.build(!t);return this};i.subdomain=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(e===undefined){if(!this._parts.hostname||this.is("IP")){return""}var n=this._parts.hostname.length-this.domain().length-1;return this._parts.hostname.substring(0,n)||""}else{var i=this._parts.hostname.length-this.domain().length;var s=this._parts.hostname.substring(0,i);var u=new RegExp("^"+o(s));if(e&&e.charAt(e.length-1)!=="."){e+="."}if(e){r.ensureValidHostname(e)}this._parts.hostname=this._parts.hostname.replace(u,e);this.build(!t);return this}};i.domain=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(typeof e==="boolean"){t=e;e=undefined}if(e===undefined){if(!this._parts.hostname||this.is("IP")){return""}var n=this._parts.hostname.match(/\./g);if(n&&n.length<2){return this._parts.hostname}var i=this._parts.hostname.length-this.tld(t).length-1;i=this._parts.hostname.lastIndexOf(".",i-1)+1;return this._parts.hostname.substring(i)||""}else{if(!e){throw new TypeError("cannot set domain empty")}r.ensureValidHostname(e);if(!this._parts.hostname||this.is("IP"))
{this._parts.hostname=e}else{var s=new RegExp(o(this.domain())+"$");this._parts.hostname=this._parts.hostname.replace(s,e)}this.build(!t);return this}};i.tld=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(typeof e==="boolean"){t=e;e=undefined}if(e===undefined){if(!this._parts.hostname||this.is("IP")){return""}var r=this._parts.hostname.lastIndexOf(".");var i=this._parts.hostname.substring(r+1);if(t!==true&&n&&n.list[i.toLowerCase()]){return n.get(this._parts.hostname)||i}return i}else{var s;if(!e){throw new TypeError("cannot set TLD empty")}else if(e.match(/[^a-zA-Z0-9-]/)){if(n&&n.is(e)){s=new RegExp(o(this.tld())+"$");this._parts.hostname=this._parts.hostname.replace(s,e)}else{throw new TypeError("TLD '"+e+"' contains characters other than [A-Z0-9]")}}else if(!this._parts.hostname||this.is("IP")){throw new ReferenceError("cannot set TLD on non-domain host")}else{s=new RegExp(o(this.tld())+"$");this._parts.hostname=this._parts.hostname.replace(s,e)}this.build(!t);return this}};i.directory=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(e===undefined||e===true){if(!this._parts.path&&!this._parts.hostname){return""}if(this._parts.path==="/"){return"/"}var n=this._parts.path.length-this.filename().length-1;var i=this._parts.path.substring(0,n)||(this._parts.hostname?"/":"");return e?r.decodePath(i):i}else{var s=this._parts.path.length-this.filename().length;var u=this._parts.path.substring(0,s);var a=new RegExp("^"+o(u));if(!this.is("relative")){if(!e){e="/"}if(e.charAt(0)!=="/"){e="/"+e}}if(e&&e.charAt(e.length-1)!=="/"){e+="/"}e=r.recodePath(e);this._parts.path=this._parts.path.replace(a,e);this.build(!t);return this}};i.filename=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(e===undefined||e===true){if(!this._parts.path||this._parts.path==="/"){return""}var n=this._parts.path.lastIndexOf("/");var i=this._parts.path.substring(n+1);return e?r.decodePathSegment(i):i}else{var s=false;if(e.charAt(0)==="/"){e=e.substring(1)}if(e.match(/\.?\//)){s=true}var u=new RegExp(o(this.filename())+"$");e=r.recodePath(e);this._parts.path=this._parts.path.replace(u,e);if(s){this.normalizePath(t)}else{this.build(!t)}return this}};i.suffix=function(e,t){if(this._parts.urn){return e===undefined?"":this}if(e===undefined||e===true){if(!this._parts.path||this._parts.path==="/"){return""}var n=this.filename();var i=n.lastIndexOf(".");var s,u;if(i===-1){return""}s=n.substring(i+1);u=/^[a-z0-9%]+$/i.test(s)?s:"";return e?r.decodePathSegment(u):u}else{if(e.charAt(0)==="."){e=e.substring(1)}var a=this.suffix();var f;if(!a){if(!e){return this}this._parts.path+="."+r.recodePath(e)}else if(!e){f=new RegExp(o("."+a)+"$")}else{f=new RegExp(o(a)+"$")}if(f){e=r.recodePath(e);this._parts.path=this._parts.path.replace(f,e)}this.build(!t);return this}};i.segment=function(e,t,n){var r=this._parts.urn?":":"/";var i=this.path();var s=i.substring(0,1)==="/";var o=i.split(r);if(typeof e!=="number"){n=t;t=e;e=undefined}if(e!==undefined&&typeof e!=="number"){throw new Error("Bad segment '"+e+"', must be 0-based integer")}if(s){o.shift()}if(e<0){e=Math.max(o.length+e,0)}if(t===undefined){return e===undefined?o:o[e]}else if(e===null||o[e]===undefined){if(a(t)){o=t}else if(t||typeof t==="string"&&t.length){if(o[o.length-1]===""){o[o.length-1]=t}else{o.push(t)}}}else{if(t||typeof t==="string"&&t.length){o[e]=t}else{o.splice(e,1)}}if(s){o.unshift("")}return this.path(o.join(r),n)};var b=i.query;i.query=function(e,t){if(e===true){return r.parseQuery(this._parts.query)}else if(typeof e==="function"){var n=r.parseQuery(this._parts.query);var i=e.call(this,n);this._parts.query=r.buildQuery(i||n,this._parts.duplicateQueryParameters);this.build(!t);return this}else if(e!==undefined&&typeof e!=="string"){this._parts.query=r.buildQuery(e,this._parts.duplicateQueryParameters);this.build(!t);return this}else{return b.call(this,e,t)}};i.setQuery=function(e,t,n){var i=r.parseQuery(this._parts.query);if(typeof e==="object"){for(var o in e){if(s.call(e,o)){i[o]=e[o]}}}else if(typeof e==="string"){i[e]=t!==undefined?t:null}else{throw new TypeError("URI.addQuery() accepts an object, string as the name parameter")}this._parts.query=r.buildQuery(i,this._parts.duplicateQueryParameters);if(typeof e!=="string"){n=t}this.build(!n);return this};i.addQuery=function(e,t,n){var i=r.parseQuery(this._parts.query);r.addQuery(i,e,t===undefined?null:t);this._parts.query=r.buildQuery(i,this._parts.duplicateQueryParameters);if(typeof e!=="string"){n=t}this.build(!n);return this};i.removeQuery=function(e,t,n){var i=r.parseQuery(this._parts.query);r.removeQuery(i,e,t);this._parts.query=r.buildQuery(i,this._parts.duplicateQueryParameters);if(typeof e!=="string"){n=t}this.build(!n);return this};i.hasQuery=function(e,t,n){var i=r.parseQuery(this._parts.query);return r.hasQuery(i,e,t,n)};i.setSearch=i.setQuery;i.addSearch=i.addQuery;i.removeSearch=i.removeQuery;i.hasSearch=i.hasQuery;i.normalize=function(){if(this._parts.urn)
{return this.normalizeProtocol(false).normalizeQuery(false).normalizeFragment(false).build()}return this.normalizeProtocol(false).normalizeHostname(false).normalizePort(false).normalizePath(false).normalizeQuery(false).normalizeFragment(false).build()};i.normalizeProtocol=function(e){if(typeof this._parts.protocol==="string"){this._parts.protocol=this._parts.protocol.toLowerCase();this.build(!e)}return this};i.normalizeHostname=function(n){if(this._parts.hostname){if(this.is("IDN")&&e){this._parts.hostname=e.toASCII(this._parts.hostname)}else if(this.is("IPv6")&&t){this._parts.hostname=t.best(this._parts.hostname)}this._parts.hostname=this._parts.hostname.toLowerCase();this.build(!n)}return this};i.normalizePort=function(e){if(typeof this._parts.protocol==="string"&&this._parts.port===r.defaultPorts[this._parts.protocol]){this._parts.port=null;this.build(!e)}return this};i.normalizePath=function(e){if(this._parts.urn){return this}if(!this._parts.path||this._parts.path==="/"){return this}var t;var n;var i=this._parts.path;var s,o;if(i.charAt(0)!=="/"){if(i.charAt(0)==="."){n=i.substring(0,i.indexOf("/"))}t=true;i="/"+i}i=i.replace(/(\/(\.\/)+)|\/{2,}/g,"/");while(true){s=i.indexOf("/../");if(s===-1){break}else if(s===0){i=i.substring(3);break}o=i.substring(0,s).lastIndexOf("/");if(o===-1){o=s}i=i.substring(0,o)+i.substring(s+3)}if(t&&this.is("relative")){i=i.substring(1)}i=r.recodePath(i);this._parts.path=i;this.build(!e);return this};i.normalizePathname=i.normalizePath;i.normalizeQuery=function(e){if(typeof this._parts.query==="string"){if(!this._parts.query.length){this._parts.query=null}else{this.query(r.parseQuery(this._parts.query))}this.build(!e)}return this};i.normalizeFragment=function(e){if(!this._parts.fragment){this._parts.fragment=null;this.build(!e)}return this};i.normalizeSearch=i.normalizeQuery;i.normalizeHash=i.normalizeFragment;i.iso8859=function(){var e=r.encode;var t=r.decode;r.encode=escape;r.decode=decodeURIComponent;this.normalize();r.encode=e;r.decode=t;return this};i.unicode=function(){var e=r.encode;var t=r.decode;r.encode=h;r.decode=unescape;this.normalize();r.encode=e;r.decode=t;return this};i.readable=function(){var t=this.clone();t.username("").password("").normalize();var n="";if(t._parts.protocol){n+=t._parts.protocol+"://"}if(t._parts.hostname){if(t.is("punycode")&&e){n+=e.toUnicode(t._parts.hostname);if(t._parts.port){n+=":"+t._parts.port}}else{n+=t.host()}}if(t._parts.hostname&&t._parts.path&&t._parts.path.charAt(0)!=="/"){n+="/"}n+=t.path(true);if(t._parts.query){var i="";for(var s=0,o=t._parts.query.split("&"),u=o.length;s<u;s++){var a=(o[s]||"").split("=");i+="&"+r.decodeQuery(a[0]).replace(/&/g,"%26");if(a[1]!==undefined){i+="="+r.decodeQuery(a[1]).replace(/&/g,"%26")}}n+="?"+i.substring(1)}n+=t.hash();return n};i.absoluteTo=function(e){var t=this.clone();var n=["protocol","username","password","hostname","port"];var i,s,o;if(this._parts.urn){throw new Error("URNs do not have any generally defined hierachical components")}if(!(e instanceof r)){e=new r(e)}if(!t._parts.protocol){t._parts.protocol=e._parts.protocol}if(this._parts.hostname){return t}for(s=0,o;o=n[s];s++){t._parts[o]=e._parts[o]}n=["query","path"];for(s=0,o;o=n[s];s++){if(!t._parts[o]&&e._parts[o]){t._parts[o]=e._parts[o]}}if(t.path().charAt(0)!=="/"){i=e.directory();t._parts.path=(i?i+"/":"")+t._parts.path;t.normalizePath()}t.build();return t};i.relativeTo=function(e){var t=this.clone();var n=["protocol","username","password","hostname","port"];var i,s,u,a,f;if(t._parts.urn){throw new Error("URNs do not have any generally defined hierachical components")}if(!(e instanceof r)){e=new r(e)}if(t.path().charAt(0)!=="/"||e.path().charAt(0)!=="/"){throw new Error("Cannot calculate common path from non-relative URLs")}i=r.commonPath(t.path(),e.path());for(var l=0,c;c=n[l];l++){t._parts[c]=null}if(i==="/"){return t}else if(!i){return this.clone()}s=e.directory();u=t.directory();if(s===u){t._parts.path=t.filename();return t.build()}a=s.substring(i.length);f=u.substring(i.length);if(s+"/"===i){if(f){f+="/"}t._parts.path=f+t.filename();return t.build()}var h="../";var p=new RegExp("^"+o(i));var d=s.replace(p,"/").match(/\//g).length-1;while(d--){h+="../"}t._parts.path=t._parts.path.replace(p,h);return t.build()};i.equals=function(e){var t=this.clone();var n=new r(e);var i={};var o={};var u={};var f,l,h;t.normalize();n.normalize();if(t.toString()===n.toString()){return true}f=t.query();l=n.query();t.query("");n.query("");if(t.toString()!==n.toString()){return false}if(f.length!==l.length){return false}i=r.parseQuery(f);o=r.parseQuery(l);for(h in i){if(s.call(i,h)){if(!a(i[h])){if(i[h]!==o[h]){return false}}else if(!c(i[h],o[h])){return false}u[h]=true}}for(h in o){if(s.call(o,h)){if(!u[h]){return false}}}return true};i.duplicateQueryParameters=function(e){this._parts.duplicateQueryParameters=!!e;return this};return r})

