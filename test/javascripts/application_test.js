ArrayTest = TestCase("ArrayTest");

ArrayTest.prototype.testMap = function() {
  var arr = ["foo","bar"];
  assertEquals("foos", arr.map(function(e){return e + "s"})[0]);
};

ArrayTest.prototype.testFilter = function() {
  var arr = ["foo", "bar"];
  result = arr.filter(function(el, i){
    return el != "bar"
  });
  assertEquals(["foo"], result);
}

ArrayTest.prototype.testMinAndMax = function() {
    var arr = [1,2,3];
    assertEquals(1, arr.min());
    assertEquals(3, arr.max());
    assertEquals(100, [1,"100","99",99].max());
}



StringTest = TestCase("String test");
StringTest.prototype.testIsBlank = function() {
  assertEquals(true, "".isBlank());
}

BookmarkableMergeRequestTest = TestCase("Bookmark merge requests",  {
  testShasOnly: function() {
    var shaSpec = Gitorious.ShaSpec.parseLocationHash("aab00199-bba00199");
    assertEquals("aab00199", shaSpec.firstSha().sha());
    assertEquals("bba00199", shaSpec.lastSha().sha());
    assertFalse(shaSpec.hasVersion());
  },
  
  testShasAndVersion: function() {
    var shaSpec = Gitorious.ShaSpec.parseLocationHash("aab00199-bba00199@2");
    assertTrue(shaSpec.hasVersion());
    assertEquals("2", shaSpec.getVersion());
  },

  testWithLeadingHash: function() {
    var shaSpec = Gitorious.ShaSpec.parseLocationHash("#aab00199-bba00199@2");
    assertEquals("aab00199", shaSpec.firstSha().sha());
  },
  
  testWithEmptyHash: function() {
    var shaSpec = Gitorious.ShaSpec.parseLocationHash("");
    assertNull(shaSpec);
  }

  /*
    TODO: 
    - query the current version from the location hash on load
    - set the current version on selection
    - extract the functionality for selecting commits, versions etc to a single, testable place
   */
})

