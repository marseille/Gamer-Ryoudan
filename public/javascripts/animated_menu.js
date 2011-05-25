$(document).ready(function(){

    //When mouse rolls over
    $(".li").mouseover(function(){
        $(this).stop().animate({height:'85px'},{queue:false, duration:700})
    });

    //When mouse is removed
    $(".li").mouseout(function(){
        $(this).stop().animate({height:'25px'},{queue:false, duration:500})
    });
});