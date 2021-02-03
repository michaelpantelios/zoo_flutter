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
        console.log("login")
        alert("fb login! " +resultHandler)
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
	appLoaded() {
		var clientContent = document.getElementById("clientContent");
		if(clientContent)	
			clientContent.style.background = "white";
	},

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