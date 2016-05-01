PDFDoc = false;
currentPage = 1;
currentKW = 0;

$(document).ready(function(event) {
    createAllPanels();

    $(document).keydown(function(event) {
        if (event.keyCode == 27) {
            $("#keyword").focus();
        }
    });
    
    $("#keyword-form").submit(function(event) {
        event.preventDefault();
    });
    
    $("#keyword-add-form").submit(function(event) {
        event.preventDefault();
    
        new_keyword = $("#add-keyword").val();
        new_page    = parseInt($("#add-page").val());
        if (isNaN(new_page) || new_page < 1 || new_page > PDFDoc.pdfInfo.numPages) {
            console.log("Invalid page: "+new_page);
            return;
        }
        
        if (new_keyword.length == 0 || keywordExists(new_keyword)) {
            console.log("Keyword already exists: "+new_keyword);
            return;
        }
        
        keywords[new_keyword] = {page: new_page};
        insertKeywordPanel(new_keyword, new_page);
        
        $("#add-keyword").val("");
        $("#add-page").val("");
        $("#add-keyword").blur();
        $("#add-page").blur();
    });
    
    $(".click-remove").click(function(event) {
        removeKeyword(this);
    });
    
    $("#page-less").click(function(event) {
        if (currentPage == 1) { return; }
        updatePage(currentPage - 1);
        $("#keyword").val("");
        removeCurrent();
    });
    
    $("#page-more").click(function(event) {
        if (currentPage == PDFDoc.pdfInfo.numPages) { return; }
        updatePage(currentPage + 1);
        $("#keyword").val("");
        removeCurrent();
    });

    $("#keyword").focus(function(event) {
        this.select();
    });
    
    $("#keyword").keyup(function(event) {
        searchAndUpdate($(this).val());
    });
});



function searchAndUpdate(text) {
    var keyword_res = "";
    var page_res = "";
    keyword_res = searchKeyword(text);
    
    if (keyword_res) {
        page_res = keywords[keyword].page;
        updatePage(page_res);        
        updateCurrent(keyword);
    }
}

function updatePage(newPage) {    
    if (newPage != currentPage) {
        currentPage = newPage;
        $("#page-num").text(newPage);
        renderPage(newPage);
    }
}

function updateCurrent(newOne) {
    removeCurrent();
    $("[id='kw-"+newOne+"']").addClass("bg-primary");
    
    currentKW = newOne;
}

function removeCurrent() {
    if (currentKW !== 0) {
        $("[id='kw-"+currentKW+"']").removeClass("bg-primary");
    }
}

function removeKeyword(element) {
    keyword = $(element).parent()[0].id.substr(3);
    $(element).parent().parent()[0].remove(); // Remove the thing on the page
    delete keywords[keyword];
}

function keywordExists(new_keyword) {
    for (keyword in keywords) {
        if (new_keyword.toLowerCase() == keyword.toLowerCase()) {
            return true;
        }
    }
    return false;
}

function insertKeywordPanel(keyword, page) {
    kw_panel_html = '<div class="panel panel-default keyword-panel">' +
                        '<div class="panel-body" style="padding: 10px" id="kw-'+keyword+'">' + 
                            '<span class="badge">Page '+page+'</span> <span class="kw">'+keyword+'</span>' + 
                            '<span class="pull-right click-remove"><span class="glyphicon glyphicon-remove"></span></span>' +
                        '</div>' +
                    '</div>';
    $("#panel-holder").prepend(kw_panel_html);
    new_element = $(".keyword-panel:first-of-type");
    new_element.children("div").children(".click-remove").click(function (event) {
        removeKeyword(this);
    });
    new_element.click(function (event) {
        searchAndUpdate(keyword);
    });
}

function createAllPanels() {
    keys = Object.keys(keywords);
    for (i = keys.length - 1; i >= 0; i--) {
        insertKeywordPanel(keys[i], keywords[keys[i]].page);
    }
}

function searchKeyword(input) {
    for (keyword in keywords) {
        if (keyword.toLowerCase() == input.toLowerCase()) {
            return keyword;
        }
    }
}

PDFJS.workerSrc = 'js/pdf/pdf.worker.js';

function loadPDF(callback = function(){}) {
    PDFJS.getDocument(pdf_url).then(function getPdfHelloWorld(pdf) {
        PDFDoc = pdf;
        callback();
    });
}

function renderPage(pageNum) {
    PDFDoc.getPage(pageNum).then(function getPageHelloWorld(page) {
        var scale = 1.0;
        var viewport = page.getViewport(scale);
        //
        // Prepare canvas using PDF page dimensions
        //
        var canvas = document.getElementById('the-canvas');
        var context = canvas.getContext('2d');
        canvas.height = viewport.height;
        canvas.width = viewport.width;
        //
        // Render PDF page into canvas context
        //
        var renderContext = {
            canvasContext: context,
            viewport: viewport
        };
        page.render(renderContext);
    });
}

function postJSON(keywords, blobid) {
	var currentdate = new Date(); 
	var minutes = currentdate.getMinutes();
	if(currentdate.getMinutes() < 10)
	{
		minutes = "0" + minutes;
	}
	var datetime = "Last saved: " + currentdate.getDate() + "/"
	                + (currentdate.getMonth()+1)  + "/" 
	                + currentdate.getFullYear() + " @ "  
	                + currentdate.getHours() + ":"  
	                + minutes;
	document.getElementById("saved").innerHTML = datetime;
    $.post("/viewer",{"newjson":JSON.stringify(keywords), "sameblob":blobid});
}
function download(blobid){
	document.getElementById("download").innerHTML = "Download";
	$.post("/serve",{"blob-key":blobid});
}
    