

//remove the password fields when loading page
var user_password_div = ''
$(function (){
    //detach() returns the html of the element
    user_password_div = $('#user_password').detach();
});  // end $(function)
//reload the password field by mark checkbox
$(function() {	
    $('#user_update_password_checkbox').change(function(){
        if ($(this).attr('checked')) {
            $('#user_password_checkbox').after(user_password_div);
        } else {
            $('#user_password').remove();
        };
    });
});