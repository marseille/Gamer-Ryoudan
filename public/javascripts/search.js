$(function() {
  
  $(".ajax_search").live("click", function(event) {
    event.preventDefault()
    if(event.button == 0) {
      var params = "search_tag="+$(".pagination").attr("search_tag")
      params += "&home_search="+$(".pagination").attr("home_search")
      params += "&page="+$(event.target).attr("page")      
      Rails.call(Rails.methods["find_game"], "html", "GET", params, function(html) {
        $("#search-results").empty()
        $("#search-results").append(html)        
        $("#search-results").animate({width: 'show', duration : '3000' });
      });
    }
  })  
})