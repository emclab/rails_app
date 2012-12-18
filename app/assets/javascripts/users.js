//remove and add field on page
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").remove();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

// end remove fields

//remove the password fields when loading page
var user_password_div = ''
$(function (){
    //detach() returns the html of the element
    user_password_div = $('#user_password_fields').detach();
});  // end $(function)
//reload the password field by mark checkbox
$(function() {
    $('#user_update_password_checkbox').change(function(){
        if ($(this).attr('checked')) {
            $('#user_password_checkbox').after(user_password_div);
        } else {
            $('#user_password_fields').remove();
        };
    });
});