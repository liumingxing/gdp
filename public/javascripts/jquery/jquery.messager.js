( function() {
	var ua = navigator.userAgent.toLowerCase();
	var is = (ua.match(/\b(chrome|opera|safari|msie|firefox)\b/) || [ '',
			'mozilla' ])[1];
	var r = '(?:' + is + '|version)[\\/: ]([\\d.]+)';
	var v = (ua.match(new RegExp(r)) || [])[1];
	jQuery.browser.is = is;
	jQuery.browser.ver = v;
	jQuery.browser[is] = true;

})();

( function(jQuery) {

	/*
	 * 
	 * jQuery Plugin - Messager
	 * 
	 * Author: corrie Mail: corrie@sina.com Homepage: www.corrie.net.cn
	 * 
	 * Copyright (c) 2008 corrie.net.cn
	 * 
	 * @license http://www.gnu.org/licenses/gpl.html [GNU General Public
	 * License]
	 * 
	 * 
	 * 
	 * $Date: 2008-12-26
	 * 
	 * $Vesion: 1.6 @ how to use and example: Please Open index.html
	 * 
	 * update by liulijun 2009-9-16
	 * change log: 
	 * 1 修改了样式
	 * 2 修改了 show 方法
	 * 3 修改了 inits 方法
	 */

	this.version = '@1.6';
	this.layer = {
		'width' :200,
		'height' :150
	};
	this.title = '信息提示';
	this.time = 4000;
	this.anims = {
		'type' :'slide',
		'speed' :600
	};
	this.timer1 = null;
	this.inits = function(title, text, iserr) {

		if ($("#message").is("div")) {
			return;
		}
		$(document.body)
				.prepend(
						'<div id="message" style="width:'
								+ this.layer.width
								+ 'px;height:'
								+ this.layer.height
								+ 'px;"><div class="msgtitlebar"><span id="message_close"><a href="#" onclick="return false;" title="关闭">&nbsp;</a></span><div class="msgtitle">'
								+ title
								+ '</div><div style="clear:both;"></div></div> <div class="msg_content_container '+(iserr? 'msg_err':'msg_ok')+'"><div id="message_content" style="width:'
								+ (this.layer.width - 52)
								+ 'px;height:'
								+ (this.layer.height - 50)
								+ 'px;">'
								+ text + '</div></div></div>');

		$("#message_close").click( function() {
			setTimeout('this.close()', 1);
		});
		$("#message").hover( function() {
			clearTimeout(timer1);
			timer1 = null;
		}, function() {
			if (time > 0)
				timer1 = setTimeout('this.close()', time);
			});

		$(window).scroll(
				function() {
					var bottomHeight =  "-"+document.documentElement.scrollTop;
					$("#message").css("bottom", bottomHeight + "px");
				});

	};

	this.show = function(opts) {//opts:{title, text, time, isErr, width, height, animType, animSpeed}
		if ($("#message").is("div")) {
			return;
		}
		
		if(typeof(opts) != 'object'){
			opts = {text:opts};
			if(arguments.length > 1){
				opts.isErr = arguments[1];
			}
		}else if(opts.text == undefined){
			return;
		}
		
		if( (opts.width && opts.width > 0)
			|| (opts.height && opts.height > 0)){
			this.lays(opts.width, opts.height);
		}
		
		if( opts.animType || opts.animSpeed){
			this.anim(opts.animType, opts.animSpeed);
		}
		
		if (opts.title == 0 || !opts.title)
			opts.title = this.title;
		if(opts.isErr){
			this.time = 0;
		}
		if (opts.time != undefined && opts.time >= 0)
			this.time = opts.time;
		
		this.inits(opts.title, opts.text, opts.isErr);
		
		switch (this.anims.type) {
		case 'slide':
			$("#message").slideDown(this.anims.speed);
			break;
		case 'fade':
			$("#message").fadeIn(this.anims.speed);
			break;
		case 'show':
			$("#message").show(this.anims.speed);
			break;
		default:
			$("#message").slideDown(this.anims.speed);
			break;
		}
		var bottomHeight =  "-"+document.documentElement.scrollTop;
		$("#message").css("bottom", bottomHeight + "px");
		
		if ($.browser.is == 'chrome') {
			setTimeout( function() {
				$("#message").remove();
				this.inits(opts.title, opts.text, opts.isErr);
				$("#message").css("display", "block");
			}, this.anims.speed - (this.anims.speed / 5));
		}
		this.rmmessage(this.time);
	};

	this.lays = function(width, height) {

		if ($("#message").is("div")) {
			return;
		}
		if (width != 0 && width)
			this.layer.width = width;
		if (height != 0 && height)
			this.layer.height = height;
	}

	this.anim = function(type, speed) {
		if ($("#message").is("div")) {
			return;
		}
		if (type != 0 && type)
			this.anims.type = type;
		if (speed != 0 && speed) {
			switch (speed) {
			case 'slow':
				;
				break;
			case 'fast':
				this.anims.speed = 200;
				break;
			case 'normal':
				this.anims.speed = 400;
				break;
			default:
				this.anims.speed = speed;
			}
		}
	}

	this.rmmessage = function(time) {
		if (time > 0) {
			timer1 = setTimeout('this.close()', time);
		}
	};
	this.close = function() {
		switch (this.anims.type) {
		case 'slide':
			$("#message").slideUp(this.anims.speed);
			break;
		case 'fade':
			$("#message").fadeOut(this.anims.speed);
			break;
		case 'show':
			$("#message").hide(this.anims.speed);
			break;
		default:
			$("#message").slideUp(this.anims.speed);
			break;
		}
		;
		setTimeout('$("#message").remove();', this.anims.speed);
		this.original();
	}

	this.original = function() {
		this.layer = {
			'width' :200,
			'height' :150
		};
		this.title = '信息提示';
		this.time = 4000;
		this.anims = {
			'type' :'slide',
			'speed' :600
		};
	};
	jQuery.messager = this;
	return jQuery;
})(jQuery);