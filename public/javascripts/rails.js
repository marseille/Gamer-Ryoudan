var Rails = {
  
  call : function(url, data_type, method_type, params, success_callback) {
    if(method_type == "POST"){
      params = JSON.stringify(params)
    }
    $.ajax({
      "url": url,
      "dataType": data_type,
      "type": method_type,
      "data": params,
      "success": function(data) { success_callback(data) },
      "error": function (event, XMLHttpRequest, ajaxOptions, thrownError)  {
        alert("problems")
      },
      "processData":"false",
      "contentType":"application/json"
    });    
  },
  
  methods : {"find_game" :        "/games/find_game",
                    "save_attribute" :   "/users/save_attribute",
                    "add_to_list" :         "/users/add_game_to_list",
                    "add_to_db":          "/games/add_game"}
}