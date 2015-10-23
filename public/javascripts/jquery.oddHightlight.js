 
;(function($){
    $.fn.oddHightlight=function(){

        var _handler=function(){
            var container=this;
            //odd table
            $("ul li:odd",container).removeClass('even').addClass('odd');
            $("ul li:even",container).removeClass('odd').addClass('even');
            //hover table
           $("tbody tr",container).hover(function(){
                $(this).addClass('hover');
           },function(){
                $(this).removeClass('hover');
           });

        };

        return this.each(_handler)
    };
})(jQuery)