/**********************
** 网页打印，依赖于jquery库
仅支持ie浏览器
=====================
用法：
  1，将要打印的部分放在一个div块内，并设置div的id为“page+数字序列”的格式，数字序列是从1开始的连续的正整数
  2，在打印按钮或打印预览按钮上分别调用方法 Webprinter.print() 或 Webprinter.printPreview()
如page1、page2...
举例：
<div id="page1">
要打印的第一页的内容
</div>
<div id="page2">
要打印的第二页的内容
</div>
<button onclick="Webprinter.print();">print</button>
<button onclick="Webprinter.printPreview();">printView</button>
=====================
***********************/
function Webprinter(){
	if($('#jatoolsPrinter').length == 0){
	  $('<object id="jatoolsPrinter" classid="CLSID:B43D3361-D975-4BE2-87FE-057188254255" codebase="/assets/jatoolsP.cab#version=1,1,6,1"></object>').appendTo(document.body);
	}
        if(navigator.userAgent.indexOf("MSIE")>0) {
          this.isIE = true;
        }else{
          this.showMsg('onlyie');
          this.isIE = false;
        }
		this.isInstalled = true;
        if(document.getElementById('jatoolsPrinter').page_div_prefix=='undefined'){
          this.showMsg('install');
          this.isIntalled = false;
        }
	
	this.options = { documents  : document,
          copyrights : '杰创软件拥有版权 www.jatools.com'
        };
}

Webprinter.prototype = {
	showMsg: function(k){
		if($('#webprinter_install').length ==0){
			$('<div id="webprinter_install" style="border: medium none ; margin: 0pt; padding: 0pt; z-index: 1000; cursor: wait; width: 100%; height: 100%; top: 0pt; left: 0pt; background-color: #000; opacity: 0.6; position: fixed;"><table border="0" cellpadding="0" cellspacing="0" style="margin:auto;padding:20px;background:#ffffff;border:black 1px solid;"><tbody><tr><td></td></tr><tr><td style="text-align:center"><input type="button" value="确定" onclick="document.body.removeChild(document.getElementById(\'webprinter_install\'));" /></td></tr></tbody></table></div>').appendTo(document.body);
		}
		$('#webprinter_install td:first').html(Webprinter.msgs[k]);
		},
	print : function(){// 打印

        if(this.isIE && this.isInstalled) { 
          document.getElementById('jatoolsPrinter').print(this.options);
        }
		},
	printPreview : function(){// 打印预览
        if(this.isIE && this.isInstalled) { 
          document.getElementById('jatoolsPrinter').printPreview(this.options);
		}
		}
};

Webprinter.msgs = {
	onlyie : '对不起，目前仅支持在IE浏览器上打印！',
	install: '请按页面顶部的黄色提示信息，下载并安装ActiveX控件!<br /><br />如果提示“不允许安装”，请从IE“菜单”选择：工具->internet 选项->安全->自定义级别，设置‘下载未签名的ActiveX’为‘启用’(或‘提示’)状态<br /><br />为安全起见，控件安装完成后，可将该设置改回到‘禁用’状态。'
	};

Webprinter.print = function(){
	var wp = new Webprinter();
	wp.print();
};

Webprinter.printPreview = function(){
	var wp = new Webprinter();
	wp.printPreview();
};