QUnit.test("First Test", function (assert) {
    assert.ok(2 == "1", "Hurray");
});

QUnit.test("Init", function (assert) {
    assert.ok(currentPage == 1, "Page init: " + currentPage);
    assert.ok(pdf_url, "PDF URL Provided: " + pdf_url);
});