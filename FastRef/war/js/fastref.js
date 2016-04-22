PDFDoc = false;
currentPage = 1;
currentKW = 0;

keywords = {
    ADD : { page: 8 },
    AND : { page: 9 },
    BR  : { page: 10},
    JMP : { page: 11},
    RET : { page: 11},
    Memory : { page: 10 }
};

$(document).ready(function(event) {
    $(document).keydown(function(event) {
        if (event.keyCode == 27) {
            $("#keyword").focus();
        }
    });
    
    $("#keyword-form").submit(function(event) {
        event.preventDefault();
    });
    
    $(".click-remove").click(function(event) {
        removeKeyword(this);
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
        
        if (page_res != currentPage) {
            currentPage = page_res;
            renderPage(page_res);
        }
        
        updateCurrent(keyword);
    }
}

function updateCurrent(newOne) {
    if (currentKW !== 0) {
        $("#kw-"+currentKW).removeClass("bg-primary");
    }
    $("#kw-"+newOne).addClass("bg-primary");
    
    currentKW = newOne;
}

function removeKeyword(element) {
    keyword = $(element).parent()[0].id.substr(3);
    $(element).parent().parent()[0].remove(); // Remove the thing on the page
    delete keywords[keyword];
}

function searchKeyword(input) {
    for (keyword in keywords) {
        if (keyword.toLowerCase() == input.toLowerCase()) {
            return keyword;
        }
    }
}


var pdf_url = './LC-3b_ISA.pdf';
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