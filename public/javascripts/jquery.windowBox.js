;(function($){
    var loading_image='images/loading.gif'
    $(document).ready(function(){
      window_init($('a.window_box'));  
    });
    $.fn.windowBox=function(){
        window_init($('a.window_box'));
    };
    //bind event
    function window_init(obj){

        obj.click(function(){
            var t=this.title||null;
            var a=$(this).attr("href");
            show_loaddig();

            mask_div();

            setTimeout(function(){show_window(t,a)},1000);//delay 10s
            return false;
        })
    };
    //loading
    function show_loaddig(){
      $("<div id='loading'><img src="+loading_image+" /></div>").appendTo($('body'));
    };
    //create mask div
    function mask_div(){
        //get mask area
        var wnd=$(window),doc=$(document);
        if(wnd.height()>doc.height()){
          var  w_height=wnd.height();
        }else{
          var  w_height=doc.height();
        };
        //create mask div
        $("<div id='mask_div'></div>").appendTo('body').width(wnd.width()).height(w_height)
                .css({position:'absolute',top:0,left:0,background:'#ccc',filter:'Alpha(opacity=90)',opacity:'0.3',zIndex:'1000'});
    };
    //
    function show_window(title,url){
        var path=get_path(url);
        var opts=get_params(url);

        $('#loading').remove();
        var window_box=$("<div id='window_box'></div>").appendTo($("body"));
        $('#window_box').append("<div id='window_header'><span id='window_title'>"+title+"</span><a href='#'><span id='window_close'></span></a></div>");
        $('#window_box').append("<div id='window_content'></div>");


        $('#window_box').width(opts.width).height(opts.height);
        var pos=window_position($('#window_box'));
        $('#window_box').css({position:'absolute',top:pos[0],left:pos[1],background:'#ffffff',zIndex:'1001'});
        if(path.match(/^#/)!=null){
        //inline content
            $('#window_content').wrap($(path));

        }else{
        //ajax content
            $("#window_content").load(path+' #selectgroup_form',function(){
                
            });
            //            $.get(path,function(data){
//              $('#window_content').html(data);
//            });
        }
        //bind close btn event handler
       $('#window_close').click(function(){
           $('#window_box,#loading,#mask_div').remove();
       }); 
    };

    function window_position(obj){
        var MyDiv_w = parseInt(obj.width());
        var MyDiv_h = parseInt(obj.height());

        var width =parseInt($(document).width());
        var height = parseInt($(window).height());
        var left = parseInt($(document).scrollLeft());
        var top = parseInt($(document).scrollTop());

        var Div_topposition = top + (height / 2) - (MyDiv_h / 2); //计算上边距
        var Div_leftposition = left + (width / 2) - (MyDiv_w / 2); //计算左边距
        return Array(Div_topposition,Div_leftposition);      
    };
    //
    function get_path(url){
        return url.substr(0,url.indexOf('?'));
    };
    //
    function get_params(url){
        var params={};
        var queryString=url.replace(/^[^\?]+\??/,'');
        var params_array=queryString.split(/[;&]/);

        for(var i=0;i<params_array.length;i++){
            var tmp=params_array[i].split('=');
            params[tmp[0]]=unescape(tmp[1]) ;
        };
        return params;
    }


})(jQuery);