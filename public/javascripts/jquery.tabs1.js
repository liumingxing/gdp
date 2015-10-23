(function($){
    $.fn.tabs1=function(){

        var _handler=function(){

            var container=this;
            //init tab_panel
            $('.tab_panel').hide();
           //bind tab click event handler
            $('ul li a:first-child',container).live('click',function(){
                //show tab_panel
                var current_tab=$(this).attr('href');
                $(current_tab).show()
                              .siblings().hide();
                //highlight tab
                $(this).parents('li').addClass('selected')
                                     .siblings().removeClass('selected');
            });
            //bind close event handler
            $('.tab_close',container).live('click',function(e){
                $(this).parents('li').remove();
                 var current_tab=$(this).prev().attr('href');
                $(current_tab).hide();
                e.stopPropagation();
            });
        };
        return this.each(_handler);
    };
})(jQuery);