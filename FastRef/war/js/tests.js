QUnit.test("Init", function (assert) {
    assert.ok(currentPage === 1, "Page init: " + currentPage);
    assert.ok(typeof pdf_url === "string", "PDF URL Provided: " + pdf_url);
    assert.ok(typeof keywords !== "undefined", "Keywords Provided");
});

QUnit.test("Load Document", function (assert) {
    var done = assert.async();
    callback = function() {
        assert.ok(PDFDoc !== false, "Loading PDF at url " + pdf_url);
        done();
    };
    loadPDF(callback);
});

