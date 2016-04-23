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

QUnit.test("Keyword Exists Test", function (assert) {
    kw = Object.keys(keywords)[0];
    notAKW = "doesNotExist";
    assert.ok(keywordExists(kw) === true, "Check keyword ("+kw+") exists");
    assert.ok(keywordExists(kw.toLowerCase()) === true, "Check keyword ("+kw+") lowercase exists");
    assert.ok(keywordExists(notAKW) === false, "Check keyword ("+notAKW+") doesn't exist");
});

QUnit.test("Panel Add Test", function (assert) {
    insertKeywordPanel("123abc", 50);
    assert.ok($("#kw-123abc").length !== 0, "Test keyword panel insertion");
    assert.ok($("#kw-123abc").children(".badge").text() === "Page 50", "Test keyword panel page");
});

QUnit.test("Update Page Test", function (assert) {
    updatePage(5);
    assert.ok(currentPage === 5, "Test page changing");
    assert.ok($("#page-num").text() === "5", "Test page indicator changing");
});

QUnit.test("Prev Page Test", function (assert) {
    updatePage(2);
    $("#page-less").click();
    assert.ok(currentPage === 1, "Test page decrease");
    
    $("#page-less").click();
    assert.ok(currentPage === 1, "Test page not changing at min");
});

QUnit.test("Next Page Test", function (assert) {
    var done = assert.async();
    callback = function() {
        max_page = PDFDoc.pdfInfo.numPages;
        updatePage(max_page - 1);
        $("#page-more").click();
        assert.ok(currentPage === max_page, "Test page increase");
        
        $("#page-more").click();
        assert.ok(currentPage === max_page, "Test page not changing at max");

        done();
    }
    loadPDF(callback);
});

QUnit.test("Update Current Test", function (assert) {
    insertKeywordPanel("updateCurrentTest", 50);
    updateCurrent("updateCurrentTest");
    assert.ok(currentKW === "updateCurrentTest", "Test current keyword updated");
    assert.ok($("#kw-updateCurrentTest").hasClass("bg-primary") === true, "Test keyword panel changed");
});

QUnit.test("Remove Current Test", function (assert) {
    insertKeywordPanel("removeCurrentTest1", 50);
    insertKeywordPanel("removeCurrentTest2", 50);
    updateCurrent("removeCurrentTest1");

    assert.ok(currentKW === "removeCurrentTest1", "Test updating current keyword");
    
    updateCurrent("removeCurrentTest2");
    assert.ok(currentKW !== "removeCurrentTest1", "Test updating removes old current keyword");
    assert.ok(currentKW === "removeCurrentTest2", "Test updating adds new current keyword");
    assert.ok($("#kw-removeCurrentTest1").hasClass("bg-primary") === false, "Test old keyword panel changed");
    assert.ok($("#kw-removeCurrentTest2").hasClass("bg-primary") === true, "Test new keyword panel changed");
    
    removeCurrent();
    assert.ok($("#kw-removeCurrentTest2").hasClass("bg-primary") === false, "Test only removing current keyword");
});

QUnit.test("Remove Keyword Test", function (assert) {
    new_keyword = "removeKeywordTest";
    new_page = 50;

    keywords[new_keyword] = {page: new_page};
    insertKeywordPanel(new_keyword, new_page);
    
    removeKeyword($("#kw-"+new_keyword).children(".click-remove"));
    assert.ok(keywordExists(new_keyword) === false, "Test keyword removal");
    assert.ok($("#kw-"+new_keyword).length === 0, "Test keyword panel removal");
});