/**********************
** ��ҳ��ӡ��������jquery��
��֧��ie�����
=====================
�÷���
  1����Ҫ��ӡ�Ĳ��ַ���һ��div���ڣ�������div��idΪ��page+�������С��ĸ�ʽ�����������Ǵ�1��ʼ��������������
  2���ڴ�ӡ��ť���ӡԤ����ť�Ϸֱ���÷��� Webprinter.print() �� Webprinter.printPreview()
��page1��page2...
������
<div id="page1">
Ҫ��ӡ�ĵ�һҳ������
</div>
<div id="page2">
Ҫ��ӡ�ĵڶ�ҳ������
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
          copyrights : '�ܴ����ӵ�а�Ȩ www.jatools.com'
        };
}

Webprinter.prototype = {
	showMsg: function(k){
		if($('#webprinter_install').length ==0){
			$('<div id="webprinter_install" style="border: medium none ; margin: 0pt; padding: 0pt; z-index: 1000; cursor: wait; width: 100%; height: 100%; top: 0pt; left: 0pt; background-color: #000; opacity: 0.6; position: fixed;"><table border="0" cellpadding="0" cellspacing="0" style="margin:auto;padding:20px;background:#ffffff;border:black 1px solid;"><tbody><tr><td></td></tr><tr><td style="text-align:center"><input type="button" value="ȷ��" onclick="document.body.removeChild(document.getElementById(\'webprinter_install\'));" /></td></tr></tbody></table></div>').appendTo(document.body);
		}
		$('#webprinter_install td:first').html(Webprinter.msgs[k]);
		},
	print : function(){// ��ӡ

        if(this.isIE && this.isInstalled) { 
          document.getElementById('jatoolsPrinter').print(this.options);
        }
		},
	printPreview : function(){// ��ӡԤ��
        if(this.isIE && this.isInstalled) { 
          document.getElementById('jatoolsPrinter').printPreview(this.options);
		}
		}
};

Webprinter.msgs = {
	onlyie : '�Բ���Ŀǰ��֧����IE������ϴ�ӡ��',
	install: '�밴ҳ�涥���Ļ�ɫ��ʾ��Ϣ�����ز���װActiveX�ؼ�!<br /><br />�����ʾ��������װ�������IE���˵���ѡ�񣺹���->internet ѡ��->��ȫ->�Զ��弶�����á�����δǩ����ActiveX��Ϊ�����á�(����ʾ��)״̬<br /><br />Ϊ��ȫ������ؼ���װ��ɺ󣬿ɽ������øĻص������á�״̬��'
	};

Webprinter.print = function(){
	var wp = new Webprinter();
	wp.print();
};

Webprinter.printPreview = function(){
	var wp = new Webprinter();
	wp.printPreview();
};