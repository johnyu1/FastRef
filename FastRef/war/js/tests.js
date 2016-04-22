QUnit.test("Init", function (assert) {
    assert.ok(currentPage === 1, "Page init: " + currentPage);
    assert.ok(typeof pdf_url === "string", "PDF URL Provided: " + pdf_url);
    assert.ok(typeof keywords !== "undefined", "Keywords Provided");
});

QUnit.test("Keywords Sanity Check", function (assert) {
    assert.ok(Object.keys(keywords).length > 0, "Positive amount of keywords");

    for (keyword in keywords) {
        assert.ok(typeof keyword == "string", "Check keyword identifier " + keyword);
    }
});

QUnit.test("Load Document", function (assert) {
    var done = assert.async();
    callback = function() {
        assert.ok(PDFDoc !== false, "Loading PDF at url " + pdf_url);
        done();
    };
    loadPDF(callback);
});

QUnit.test("Page Number Checks", function (assert) {
    var done = assert.async();
    callback = function() {
        for (keyword in keywords) {
            page = keywords[keyword].page;
            assert.ok(page >= 1 &&
                      page < PDFDoc.pdfInfo.numPages,
                      "Check valid page number for keyword (" + keyword + "): " + page);
        }

        done();
    }
    loadPDF(callback);
});

QUnit.test("Keyword Test", function (assert) {
    var done = assert.async();
    callback = function() {
        for (keyword in keywords) {
            searchAndUpdate(keyword);
            page = keywords[keyword].page;
            assert.ok(page == currentPage,
                      "Check page load for keyword (" + keyword + "): " + page);
        }

        done();
    }
    loadPDF(callback);
});