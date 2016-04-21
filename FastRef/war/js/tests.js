QUnit.test("Init", function (assert) {
    assert.ok(currentPage === 1, "Page init: " + currentPage);
    assert.ok(typeof pdf_url === "string", "PDF URL Provided: " + pdf_url);
    assert.ok(typeof keywords !== "undefined", "Keywords Provided");
});

QUnit.test("Init", function (assert) {
    assert.ok(currentPage == 1, "Page init: " + currentPage);
    assert.ok(pdf_url, "PDF URL Provided: " + pdf_url);
});