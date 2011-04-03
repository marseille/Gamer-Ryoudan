$(function() {
  $(".ajax_search").live("click", function(event) {
    event.preventDefault()
    if(event.button == 0) {
      var search_tag = $(".pagination").attr("search_tag")
      var home_search = $(".pagination").attr("home_search")
      var page = $(event.target).attr("page")            
      var url = Rails.methods["find_game"] + "/"+search_tag+"/"+home_search+"/"+page
      Rails.call(url, "html", "GET", {}, function(html) {
        $("#search-results").empty()
        $("#search-results").append(html)        
        $("#search-results").animate({width: 'show', duration : '3000' });
      });
    }
  })  
})