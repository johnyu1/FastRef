keyEvent = {}

keywords = {
    ADD : { page: 1 },
    AND : { page: 5 },
    Memory : { page: 10 }
};

$(document).ready(function(event) {
    $(document).keypress(function(event) {
        if (event.keyCode == 27) {
            $("#keyword").focus();
        }
    });
    
    $("#keyword").focus(function(event) {
        this.select();
    });
    
    $("#keyword").keyup(function(event) {
        var keyword_res = "";
        var page_res = "";
        for (keyword in keywords) {
            if (keyword.toLowerCase() == $(this).val().toLowerCase()) {
                keyword_res = keyword;
                page_res = keywords[keyword].page;
                break;
            }
        }
        
        $("p#keyword_res").text("keyword: " + keyword_res);
        $("p#page_res").text("page: " + page_res);
    });
});