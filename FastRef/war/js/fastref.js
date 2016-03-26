keyEvent = {}

keywords = {
    ADD : { page: 1 },
    AND : { page: 5 },
    Memory : { page: 10 }
};

$(document).ready(function(event) {
    $(document).keypress(function(event) {
        if (!$("#keyword").is(":focus")) {
            if (event.keyCode == 27) {
                $("#keyword").focus();
            }
        }
    });
});