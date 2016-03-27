PDFDoc = "";
currentPage = 1;

keywords = {
    ADD : { page: 8 },
    AND : { page: 9 },
    BR  : { page: 10},
    JMP : { page: 11},
    RET : { page: 11},
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
                if (page_res != currentPage) {
                    renderPage(page_res);
                    currentPage = page_res;
                }
                break;
            }
        }
        
        $("span#keyword_res").text(keyword_res);
        $("span#page_res").text(page_res);
    });
});


var url = './LC-3b_ISA.pdf';
PDFJS.workerSrc = 'js/pdf/pdf.worker.js';
PDFJS.getDocument(url).then(function getPdfHelloWorld(pdf) {
    PDFDoc = pdf;
    renderPage(1);
});

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