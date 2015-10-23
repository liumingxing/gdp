;
(function($){
    
    $.fn.grid_table = function(){
    
        var _handler = function(){
            var container = this;
            //odd table
            $("tbody tr:odd", container).removeClass('even').addClass('odd');
            $("tbody tr:even", container).removeClass('odd').addClass('even');
            //hover table
            $("tbody tr", container).hover(function(){
                $(this).addClass('hover');
            }, function(){
                $(this).removeClass('hover');
            });
            
        };
        
        return this.each(_handler)
    };
})(jQuery)
