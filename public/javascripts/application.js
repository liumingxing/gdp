function to_float(str)
{
    num = parseFloat(str)
    if (isNaN(num))
        return 0;
    else
        return num;
}

//金额格式化，scrStr-数值,aAfterDot-小数位数
function formatNumber(srcStr,nAfterDot) 
{
  if(isNaN(srcStr)){
    return "0";
  }
  var srcStr,nAfterDot;
  var resultStr,nTen;
  srcStr = ""+srcStr+"";
  strLen = srcStr.length;
  dotPos = srcStr.indexOf(".",0);
  if (dotPos == -1){
    resultStr = srcStr+".";
    for (i=0;i<nAfterDot;i++){
      resultStr = resultStr+"0";
    }
    return resultStr;
  }else{
    if ((strLen - dotPos - 1) >= nAfterDot){
      nAfter = dotPos + nAfterDot + 1;
      nTen =1;
      for(j=0;j<nAfterDot;j++){
        nTen = nTen*10;
      }
      resultStr = Math.round(parseFloat(srcStr)*nTen)/nTen;
      return resultStr;
    }else{
      resultStr = srcStr;
      for (i=0;i<(nAfterDot - strLen + dotPos + 1);i++){
        resultStr = resultStr+"0";
      }
      return resultStr;
    }
  }
}

function urlparams()
{
  var urlParts=document.URL.split("?");
  if (urlParts[1])        //urlParts[1]为传参数部分。如果存在，进行分解
  {            
    var param =new Array;
    var parameterParts=urlParts[1].split("&");
    for (i=0;i<parameterParts.length;i++)
    {
        var pairParts=parameterParts[i].split("=");
        param[i]=pairParts[1];        //param数组存各参数
    }
    return param
  }
  return null
}

function params(text, name)
{    
    var param =new Array;
    var parameterParts=text.split("&");
    for (i=0;i<parameterParts.length;i++)
    {
        var pairParts=parameterParts[i].split("=");
        for (j=0; j<pairParts.length; j++)
        {
            if (pairParts[0] == name)
                return pairParts[1]
        }
    }
    return null
}

/*******************************************************************************************
 * 大写货币
 -----------------------------------------------------------------------------------------*/
 function toBigCurrency(Num){
   for(i=Num.length-1;i>=0;i--)
   {
    Num = Num.replace(",","")//替换tomoney()中的“,”
    Num = Num.replace(" ","")//替换tomoney()中的空格
   }
   Num = Num.replace("￥","")//替换掉可能出现的￥字符
   if(isNaN(Num)) { //验证输入的字符是否为数字
    //alert("请检查小写金额是否正确");
    return "";
   }
   //---字符处理完毕，开始转换，转换采用前后两部分分别转换---//
   part = String(Num).split(".");
   newchar = "";
   //小数点前进行转化
   for(i=part[0].length-1;i>=0;i--){
   if(part[0].length > 10){ alert("位数过大，无法计算");return "";}//若数量超过拾亿单位，提示
    tmpnewchar = ""
    perchar = part[0].charAt(i);
    switch(perchar){
    case "0": tmpnewchar="零" + tmpnewchar ;break;
    case "1": tmpnewchar="壹" + tmpnewchar ;break;
    case "2": tmpnewchar="贰" + tmpnewchar ;break;

   case "3": tmpnewchar="叁" + tmpnewchar ;break;
    case "4": tmpnewchar="肆" + tmpnewchar ;break;
    case "5": tmpnewchar="伍" + tmpnewchar ;break;
    case "6": tmpnewchar="陆" + tmpnewchar ;break;
    case "7": tmpnewchar="柒" + tmpnewchar ;break;
    case "8": tmpnewchar="捌" + tmpnewchar ;break;
    case "9": tmpnewchar="玖" + tmpnewchar ;break;
    }
    switch(part[0].length-i-1){
    case 0: tmpnewchar = tmpnewchar +"元" ;break;
    case 1: if(perchar!=0)tmpnewchar= tmpnewchar +"拾" ;break;
    case 2: if(perchar!=0)tmpnewchar= tmpnewchar +"佰" ;break;
    case 3: if(perchar!=0)tmpnewchar= tmpnewchar +"仟" ;break;
    case 4: tmpnewchar= tmpnewchar +"万" ;break;
    case 5: if(perchar!=0)tmpnewchar= tmpnewchar +"拾" ;break;
    case 6: if(perchar!=0)tmpnewchar= tmpnewchar +"佰" ;break;
    case 7: if(perchar!=0)tmpnewchar= tmpnewchar +"仟" ;break;
    case 8: tmpnewchar= tmpnewchar +"亿" ;break;
    case 9: tmpnewchar= tmpnewchar +"拾" ;break;
    }
    newchar = tmpnewchar + newchar;
   }
   //小数点之后进行转化
   if(Num.indexOf(".")!=-1){
   if(part[1].length > 2) {
    alert("小数点之后只能保留两位,系统将自动截段");
    part[1] = part[1].substr(0,2)
    }
   for(i=0;i<part[1].length;i++){
    tmpnewchar = ""
    perchar = part[1].charAt(i)
    switch(perchar){
    case "0": tmpnewchar="零" + tmpnewchar ;break;
    case "1": tmpnewchar="壹" + tmpnewchar ;break;
    case "2": tmpnewchar="贰" + tmpnewchar ;break;
    case "3": tmpnewchar="叁" + tmpnewchar ;break;
    case "4": tmpnewchar="肆" + tmpnewchar ;break;
  case "5": tmpnewchar="伍" + tmpnewchar ;break;
    case "6": tmpnewchar="陆" + tmpnewchar ;break;
    case "7": tmpnewchar="柒" + tmpnewchar ;break;
    case "8": tmpnewchar="捌" + tmpnewchar ;break;
    case "9": tmpnewchar="玖" + tmpnewchar ;break;
    }
    if(i==0)tmpnewchar =tmpnewchar + "角";
    if(i==1)tmpnewchar = tmpnewchar + "分";
    newchar = newchar + tmpnewchar;
   }
   }
   //替换所有无用汉字
   while(newchar.search("零零") != -1)
    newchar = newchar.replace("零零", "零");
   newchar = newchar.replace("零亿", "亿");
   newchar = newchar.replace("亿万", "亿");
   newchar = newchar.replace("零万", "万");
   newchar = newchar.replace("零元", "元");
   newchar = newchar.replace("零角", "");
   newchar = newchar.replace("零分", "");


  if (newchar.charAt(newchar.length-1) == "元" || newchar.charAt(newchar.length-1) == "角")
    newchar = newchar+"整"
  if(newchar == "元整")
    newchar = "零元整";
   return newchar;
  }

//金额格式化千分位
function qf_num(num){
  var re = /(-?\d+)(\d{3})/;
  num = num+"";
  while(re.test(num)){
    num = num.replace(re,"$1,$2");
  }
  if(num.indexOf('.')==-1){
    num = num+".00";
  }
  return num;
}

//计算合计，至少两个参数，并且每个参数都必须是数值
function get_total(num1,num2){
  if(arguments.length<2){
      return 0;
  }
  var re = new RegExp(/^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/);//数值的正则表达式
  var total_n = 0;
  for(var i=0;i<arguments.length;i++){
    var n = arguments[i]+"";
    if(re.test(n)){
        total_n += parseFloat(n)
    }else{
        return 0;
    }
  }
    return total_n
}

function enablePngImages() {
  var version = parseFloat(navigator.appVersion.split("MSIE")[1]);
  if (version == 6.0 && (document.body.filters)) {
    var imgArr = document.getElementsByTagName("IMG");
    for(var i=0, j=imgArr.length; i<j; i++){
      if(imgArr[i].src.toLowerCase().lastIndexOf(".png") != -1){
        imgArr[i].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + imgArr[i].src + "', sizingMethod='auto')";
        imgArr[i].src = "/img/clear.gif";
      }
   }   
   
   imgArr = $(".Main_ToolBar_bg");
   imgArr.removeClass("Main_ToolBar_bg")
   imgArr.addClass("Main_ToolBar_bg_ie6")
   
   imgArr = $(".Main_ToolBar_bg_left") ;
   for(var i=0, j=imgArr.length; i<j; i++){
        if(imgArr[i].currentStyle.backgroundImage.lastIndexOf(".png") != -1){
              var img = imgArr[i].currentStyle.backgroundImage.substring(5,imgArr[i].currentStyle.backgroundImage.length-2);
              imgArr[i].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+img+"', sizingMethod='crop')";
              imgArr[i].style.backgroundImage = "url(/img/clear.gif)";
          }
    }
    
    imgArr = $(".Main_ToolBar_bg_right");
   for(var i=0, j=imgArr.length; i<j; i++){
        if(imgArr[i].currentStyle.backgroundImage.lastIndexOf(".png") != -1){
              var img = imgArr[i].currentStyle.backgroundImage.substring(5,imgArr[i].currentStyle.backgroundImage.length-2);
              imgArr[i].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+img+"', sizingMethod='crop')";
              imgArr[i].style.backgroundImage = "url(/img/clear.gif)";
          }
    }
    
    imgArr = $(".Main_ToolBar_textlabel_bg_left") ;
   for(var i=0, j=imgArr.length; i<j; i++){
        if(imgArr[i].currentStyle.backgroundImage.lastIndexOf(".png") != -1){
              var img = imgArr[i].currentStyle.backgroundImage.substring(5,imgArr[i].currentStyle.backgroundImage.length-2);
              imgArr[i].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+img+"', sizingMethod='crop')";
              imgArr[i].style.backgroundImage = "url(/img/clear.gif)";
          }
    }
    
     imgArr = $(".Main_ToolBar_textlabel_bg_right") ;
   for(var i=0, j=imgArr.length; i<j; i++){
        if(imgArr[i].currentStyle.backgroundImage.lastIndexOf(".png") != -1){
              var img = imgArr[i].currentStyle.backgroundImage.substring(5,imgArr[i].currentStyle.backgroundImage.length-2);
              imgArr[i].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+img+"', sizingMethod='crop')";
              imgArr[i].style.backgroundImage = "url(/img/clear.gif)";
          }
    }

  }
}

window.onload = function() {
  enablePngImages();
}

function tr_mouseover(row)
  {
    row.old_color = row.style.backgroundColor;
    row.style.backgroundColor = "#FFFDD7";
  }
  
  function tr_mouseout(row)
  {
      row.style.backgroundColor = row.old_color;
  }
  
  function tr_click(row)
  {
   
    var parent = row.parentNode;
    if (parent.tagName == "TBODY")
        parent = parent.parentNode;
          
    var child = parent.childNodes[0];
    if (child.tagName == undefined)
    {
        child = parent.childNodes[1];
    }
    
    for(var i=0; i<child.childNodes.length; i++)
    {
        node = child.childNodes[i];
        if (node.className == "TrSelected")
        {
            node.className = node.old_class;
        }
    }
    
    row.old_class = row.className;
    row.className = "TrSelected"; 
    //parent.data_id = row.id;
    
    $(parent).attr('data_id', row.id);
    //Element.writeAttribute(parent, "data_id", row.id);
  }
  
  function geturl(path, element_id, refresh)
  {
    var result = path;

    //var data_id = Element.readAttribute(element_id, "data_id")
    var data_id = $("#" + element_id).attr("data_id");
    if (data_id == undefined)
    {
        alert("请选择一行记录");
        return;
    }
    result += data_id;
    if (refresh)
       document.location = result;
    return result;
  }
  
  function close_round(obj)
  {
      var div = obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.nextSibling.children[2].children[0];
      if (div.style.display == "none")
      {
         div.style.display = "block";
         obj.children[0].src = "/img/i_jt1.gif";
      }  
      else
      {
        div.style.display = "none";        
        obj.children[0].src = "/img/i_jt2.gif";
      }
        
  }
  
  function set_path(text)
  {
      $('#path').append("当前路径: " + text);
  }
  
  function add_tab_button(img, tip, link)
    {
        $('#separator').before('<td width=2%><a href="'+link + '" class="Main_ToolBar_Button"><img class="Main_ToolBar_Button_Icon" src="'+img+'" title="'+tip+'" border="0" ></a></td>');
        //$('separator').insert({before: '<td width=2%><a href="'+link + '" class="Main_ToolBar_Button"><img class="Main_ToolBar_Button_Icon" src="'+img+'" title="'+tip+'" border="0" ></a></td>'})
    }
    
    function add_sep()
    {
        $('#separator').before('<td class="Main_ToolBar_Separator_cell"><IMG src="/img/blank.gif" class="Main_ToolBar_Separator"></td>');
        //$('separator').insert({before: '<td class="Main_ToolBar_Separator_cell"><IMG src="/img/blank.gif" class="Main_ToolBar_Separator"></td>'})
    }
    
    function add_submit(tip, img)
    {
        img = img || "/img/iconSave.png";
        $('#separator').before('<td width=2%><a href="javascript:if(document.forms[0].onsubmit == null || document.forms[0].onsubmit()!=false){document.forms[0].submit();}" class="Main_ToolBar_Button"><img class="Main_ToolBar_Button_Icon" src="'+img+'" title="'+tip+'" border="0" ></a></td>');
        //$('separator').insert({before: '<td width=2%><a href="javascript:document.forms[0].submit();" class="Main_ToolBar_Button"><img class="Main_ToolBar_Button_Icon" src="'+img+'" title="'+tip+'" border="0" ></a></td>'})
    }
    
    function add_delete_button(link)
    {
        onclikstr = "if (confirm('您确定删除本记录吗?')) { var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;f.submit(); };return false;";
        $('#separator').before('<td width=2%><a href="'+link+'" class="Main_ToolBar_Button" onclick="'+onclikstr+'"><img class="Main_ToolBar_Button_Icon" src="/img/iconErase.png" title="删除" border="0" ></a></td>');
        //$('separator').insert({before: '<td width=2%><a href="'+link+'" class="Main_ToolBar_Button" onclick="'+onclikstr+'"><img class="Main_ToolBar_Button_Icon" src="/img/iconErase.png" title="删除" border="0" ></a></td>'})
    }
    
    function add_right_text(text)
    {
        $('#right_text').append(text);
    }
    
    function add_link(name, url, id  )
    {
        if(arguments[2]){
            $('#links').append('<a id='+id + ' style="color:#000060;font-size:12px;" href="'+url + '">'+ name+ '</a>&nbsp;&nbsp;&nbsp;');
        }else{
            $('#links').append('<a style="color:#000060;font-size:12px;" href="'+url + '">'+ name+ '</a>&nbsp;&nbsp;&nbsp;');
        }
    }
    
    function add_js_link(name, url, id  )
    {
        if(arguments[2]){
            $('#links').append('<a id='+id + ' style="color:#000060;font-size:12px;" href="#" onclick="'+url + '">'+ name+ '</a>&nbsp;&nbsp;&nbsp;');
        }else{
            $('#links').append('<a style="color:#000060;font-size:12px;" href="#" onclick="'+url + '">'+ name+ '</a>&nbsp;&nbsp;&nbsp;');
        }
    }
    
    function add_dynamic_delete_button(link, element_id, tip)
    {
        element_id = element_id || "table";
        link = "geturl('"+ link + "', '" + element_id + "', false)";
        
        onclikstr = "if (confirm('您确定删除本记录吗?')) { var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; if("+link+"){ f.action = "+link+"; f.submit(); }};return false;";
        //link = "javascript:"+link;
        link = "#";
        tip = tip || "删除"
        $('#separator').before('<td width=2%><a href="'+link+'" class="Main_ToolBar_Button" onclick="'+onclikstr+'"><img class="Main_ToolBar_Button_Icon" src="/img/iconErase.png" title="'+tip+'" border="0" ></a></td>');
        //$('separator').insert({before: '<td width=2%><a href="'+link+'" class="Main_ToolBar_Button" onclick="'+onclikstr+'"><img class="Main_ToolBar_Button_Icon" src="/img/iconErase.png" title="'+tip+'" border="0" ></a></td>'})
    }
    
    function add_dynamic_button(img, tip, link, element_id)
    {
        element_id = element_id || "table";
        link = "javascript:geturl('"+ link + "', '" + element_id + "', true);";
        $('#separator').before('<td width=2%><a href="'+link + '" class="Main_ToolBar_Button"><img class="Main_ToolBar_Button_Icon" src="'+img+'" title="'+tip+'" border="0" ></a></td>');
        //$('separator').insert({before: '<td width=2%><a href="'+link + '" class="Main_ToolBar_Button"><img class="Main_ToolBar_Button_Icon" src="'+img+'" title="'+tip+'" border="0" ></a></td>'})
    }
    
    function popupDiv(div_id) {   
        var div_obj = $("#"+div_id);   
        var windowWidth = document.documentElement.clientWidth;       
        var windowHeight = document.documentElement.clientHeight;       
        var popupHeight = div_obj.height();       
        var popupWidth = div_obj.width();    
        //添加并显示遮罩层   
        $("<div id='mask'></div>").addClass("mask")   
                                  .width(windowWidth * 0.99)   
                                  .height(windowHeight * 0.99)   
                                  .click(function() {hideDiv(div_id); })   
                                  .appendTo("body")   
                                  .fadeIn(200);   
        div_obj.css({"position": "absolute"})   
               .animate({left: windowWidth/2-popupWidth/2,    
                         top: windowHeight/2-popupHeight/2, opacity: "show" }, "slow");   
    }   
      
    function hideDiv(div_id) {   
        $("#mask").remove();   
        $("#" + div_id).animate({left: 0, top: 0, opacity: "hide" }, "slow");   
    } 

//////////////////////////////////////////////////////////////////////////////


      String.prototype.Trim = function(){
        return this.replace(/(^\s*)|(\s*$)/g, "");
      }

      jQuery(document).ready(function($){
          //===全选按钮======//
          $(':checkbox[name=chckedall]').click(function(){
              $(':checkbox[name="'+$(this).attr('subname')+'"]').attr('checked',$(this).attr('checked'));
          });
          $(':checkbox[name=chckedall]').each(function(){
              var chkall = $(this);
              $(':checkbox[name="'+$(this).attr('subname')+'"]').click(function(){
                  if(!$(this).attr('checked')){
                      chkall.attr('checked',false);
                  }
              });
          });

          //=======将表单转换为查看详细信息========================================
        function formToShow(){
            if($('.show_detail').length == 0) return;
            $('.show_detail :text').each(function(){
              var v = $(this).val();
              $(this).replaceWith(v);
            });
            $('.show_detail :radio, .show_detail :checkbox').each(function(){
                var stp = this.type;
              if($(this).is(':checked')){
                $(this).replaceWith('<img src="/images/'+ stp +'_checked.gif" />');
              }else{
                $(this).replaceWith('<img src="/images/'+ stp +'_unchecked.gif" />');
              }
            });
            $('.show_detail :input').each(function(){
                if($(this).is(":hidden")) return;
                if($(this).is(":file")){
                    $(this).hide();
                }
                var ndName = this.nodeName.toLowerCase();
                var v = null;
                if(ndName == 'select'){
                    v = $("option:selected", this).attr('value');
                    if (v!=''){
                        v = $("option:selected", this).html();
                    } 
                }else if(ndName == 'textarea'){
                  v = $(this).val();
                  v = v.replace(/</g,"&lt;");
                  v = v.replace(/>/g,"&gt;");
                  v = v.replace(/\n/g,"<br />");
                  if(v == ''){
                    v = '&nbsp;'
                  }
                }
                if(v != null){
                    $(this).replaceWith(v);
                }
            });
            //隐藏为编辑界面特有的元素，如”查找“按钮、特殊的提示等
            $('.show_detail .for_edit').hide();
        }
        formToShow();

        //=====弹出层初始化 ================
        if($('div.popover_div').length > 0){
            $('<div id="popover_div_switch">'+$('div.popover_div').attr('title')+'</div>').appendTo(document.body);
            var div_h = $('div.popover_div').height();
            var div_w = $('div.popover_div').width()//$(document.body).width() - 20;
            $('div.popover_div').height(0);
            $('div.popover_div').width(0);
            $('div.popover_div').appendTo(document.body);
            $('div.popover_div').hide();
            $('#popover_div_switch').live("click", function(){
                if($('div.popover_div').is(":hidden")){
                    $('div.popover_div').animate({width:div_w, height:div_h},"fast","swing",function(){$('div.popover_div').show();});
                } else {
                    $('div.popover_div').animate({width:0, height:0},"fast","swing",function(){$('div.popover_div').hide();});
                }
            });
        }

  });

//中心人员、部门选择器
function selecter_department_users(params){
    var cs = ''
    for(var p in params){
      if(cs.length>0) cs+="&";
      cs += p + '=' + encodeURI(params[p]);
    }
    JqueryDialog.Open1('部门结构', "/department/select_department_users?" +cs, 300, 400);
    
    //if($('#select_department_users_dialog').size() == 0){
    //    var selecter_dialog = $('<div id="select_department_users_dialog" title="部门结构"><iframe width="280" height="400" frameborder="0" scrolling="auto" src="/department/select_department_users?'+ cs +'"></iframe></div>').appendTo(document.body);
        //$.get("/department/select_department_users", params, function(data){ selecter_dialog.html(data);});
   //    selecter_dialog.dialog({modal:true, width:300, height:400, resizable:false});
   // }else{
   //    $('#select_department_users_dialog > iframe').attr('src','/department/select_department_users?'+ cs ); 
   // }
   // $('#select_department_users_dialog').dialog('open');
    return false;
}

//公用审批意见【临时】
jQuery(document).ready(function($){

    $('.default_opinion').live('click',function(){
        $('.audit_opinion_input_area').val($(this).val());
        $('#audit_opinion_selector').hide();
    });
    //[name=reason]委托, [name=opinion_content]工作流, [name=audit_opinion]定点
    $('textarea[name=opinion_content], textarea[name=audit_opinion]').each(function(){
        if($(this).attr('readonly')!= undefined && $(this).attr('disabled')!=undefined){
            $(this).addClass('audit_opinion_input_area');
        }
    });
    $('.audit_opinion_input_area').focus(function(){
        if($('#audit_opinion_selector').size()==0){
               //创建默认审批意见选项
            $('<div id="audit_opinion_selector" style="display:none;position:absolute;width:200px;height:75px;overflow:auto;z-index:99999;border-color:#eeeeee #999 #999 #eeeeee;border-width:1px;border-style:solid;padding:2px;background:#F6A828;">'+
        '<div style="font-size:14px;font-weight:bold;">请选择审批意见：</div>'+
        '<ul style="list-style:none;margin:0;padding:0;">'+
        '<li style="height:25px;line-height:25px;border-bottom:1px solid #ccc;"><input type="radio" class="default_opinion" name="default_opinoin" value="同意"/>同意</li>'+
        '<li style="height:25px;line-height:25px;border-bottom:1px solid #ccc;"><input type="radio" class="default_opinion" name="default_opinoin" value="不同意"/>不同意</li>'+
        '</ul></div>').appendTo('body');
        }
        var p = $(this).position();
		var t = p.top-80;
		if(t < 0) t = p.top + $(this).height()+ 12;
        $('#audit_opinion_selector').css({'left':p.left+'px','top':t+'px'});
        $('#audit_opinion_selector').show();
    });
});
