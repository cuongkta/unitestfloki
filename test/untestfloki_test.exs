require IEx
require CalculateTree
require MyModuleFloki
defmodule UntestflokiTest do
  use ExUnit.Case
 
  doctest Untestfloki

  @html_0 """
  <div id="container">
  <a href="google.com">google</a>
  <img src="im.svg"/>
  <div id="1">
    <span>Some text</span>
    <span>Removed image from here</a>
    <div id="child1">
      <span>Removed google link from here</a>
    </div>
    <div id="child2">
      <span>Text about Yahoo</span>
      <img src="yahoo.svg"/>
      <div id="child1of2">
        <a href="yahoo.com">yahoo</a>
      </div>
     </div>
  </div>
</div>
  """

  @html_1 """
  <html>
    <div>
      <a href="https://yahoo.com">Yahoo</a>
    </div>
    <div>
      <span class="hint"><a href="https://google.com">Google</a><span>
    </div>
    <div>
      <a href="https://apple.com" target="_blank">
        <span>Apple</span>
        <img src="apple.svg"/>
      </a>
    </div>
  </html>
  """

  # you can replace the <div id="container"> div with <html>. it shouldn't affect the tests
  @html_2 """
<div id="container">
  <div id="1">
    <span>Some text</span>
    <img src="im.svg"/>
    <div id="child1">
      <a href="google.com">google</a>
    </div>
    <div id="child2">
      <span>Text about Yahoo</span>
      <img src="yahoo.svg"/>
      <div id="child1of2">
        <a href="yahoo.com">yahoo</a>
      </div>
     </div>
  </div>
</div>
  """
  @html_3 """
<div id="container">
  <a href="google.com">google</a>
  <img src="im.svg"/>
  <div id="1">
    <span>Some text</span>
    <span>Removed image from here</a>
    <div id="child1">
      <span>Removed google link from here</a>
    </div>
    <div id="child2">
      <span>Text about Yahoo</span>
      <img src="yahoo.svg"/>
      <div id="child1of2">
        <a href="yahoo.com">yahoo</a>
      </div>
     </div>
  </div>
</div>
  """

  @my_html """
<html>
<body>
  <section id="content">
    <p class="headline">Floki</p>
    <span class="headline">Enables search using CSS selectors</span>
    <a href="http://github.com/philss/floki">Github page</a>
    <span data-model="user">philss</span>
  </section>
  <a href="https://hex.pm/packages/floki">Hex package</a>
</body>
</html>
  """

  test "the truth" do
   IO.puts @html_0
   #inspect @html_0
   #assert CalculateTree.calculate_sum(1,1) == 2
   assert MyModuleFloki.check(@html_0, "a, img") == [
      {"a", [{"href", "google.com"}], []},
      {"img", [{"src", "im.svg"}], []},
      {"img", [{"src", "yahoo.svg"}], []},
      {"div", [{"id", "child1of2"}], [
        {"a", [{"href", "yahoo.com"}], []}
      ]}
    ] 

  end

  test "html_1, a" do
    assert (MyModuleFloki.check(@html_1, "a")) == [
      {"div", [],
        [{"a", [{"href", "https://yahoo.com"}], ["Yahoo"]}]
      },
      {"div", [],
        [{"span", [{"class", "hint"}],
          [{"a", [{"href", "https://google.com"}], ["Google"]}, {"span", [], []}]}]
      },
      {"div", [],
        [{"a", [{"href", "https://apple.com"}, {"target", "_blank"}],
          [{"span", [], ["Apple"]}, {"img", [{"src", "apple.svg"}], []}]
        }]
      }
    ] 
  end


  test "html_2, a" do
    assert (MyModuleFloki.check(@html_2, "a")) == [
      {"div", [{"id", "child1"}], [
        {"a", [{"href", "google.com"}], []}
      ]},
      {"div", [{"id", "child2"}], [
        [{"span", [], ["Text about Yahoo"]}, 
        {"img", [{"src", "yahoo.svg"}], []},
        {"div", [{"id", "child1of2"}], [
          {"a", [{"href", "yahoo.com"}], []}
        ]}]
      ]}
    ] 
  end

  test "html_3, a" do
    # since we moved the google link outside div#1
    # the subtree for the yahoo link can go one level higher
    assert (MyModuleFloki.check(@html_3, "a")) == [
      {"a", [{"href", "google.com"}], []},
      {"div", [{"id", "1"}], [
        {"span", [], ["Some Text"]}, 
        {"span", [], ["Removed image from here"]},
        {"div", [{"id", "child1"}], [
          {"span", [], ["Removed google link from here"]}
        ]},
        {"div", [{"id", "child2"}], [
          [{"span", [], ["Text about Yahoo"]}, 
          {"img", [{"src", "yahoo.svg"}], []},
          {"div", [{"id", "child1of2"}], [
            {"a", [{"href", "yahoo.com"}], []}
          ]}]
        ]}
      ]}
    ] 
  end

test "html_0, a" do
    assert (MyModuleFloki.check(@html_0, "a")) == [
      {"div", [{"id", "child1"}], [
        {"a", [{"href", "google.com"}], []}
      ]},
      {"div", [{"id", "child2"}], [
        {"div", [{"id", "child1of2"}], [
          {"a", [{"href", "yahoo.com"}], []}
        ]},
      ]}
    ] 
  end

  ###################
  #  img tag tests  #
  ###################
  test "html_1, img" do
    assert (MyModuleFloki.check(@html_1, "img")) == [
      {"div", [],
        [{"a", [{"href", "https://apple.com"}, {"target", "_blank"}],
          [{"span", [], ["Apple"]}, {"img", [{"src", "apple.svg"}], []}]
        }]
      }
    ]
  end
  test "html_2, img" do
    assert (MyModuleFloki.check(@html_2, "img")) == [
      {"img", [{"src", "im.svg"}], []},
      {"div", [{"id", "child2"}], [
        [{"span", [], ["Text about Yahoo"]}, 
        {"img", [{"src", "yahoo.svg"}], []},
        {"div", [{"id", "child1of2"}], [
          {"a", [{"href", "yahoo.com"}], []}
        ]}]
      ]}
    ]
  end
  test "html_3, img" do
    assert (MyModuleFloki.check(@html_3, "img")) == [
      {"img", [{"src", "im.svg"}], []},
      {"div", [{"id", "1"}], [
        {"span", [], ["Some Text"]}, 
        {"span", [], ["Removed image from here"]},
        {"div", [{"id", "child1"}], [
          {"span", [], ["Removed google link from here"]}
        ]},
        {"div", [{"id", "child2"}], [
          [{"span", [], ["Tabout about Yahoo"]}, 
          {"img", [{"src", "yahoo.svg"}], []},
          {"div", [{"id", "child1of2"}], [
            {"a", [{"href", "yahoo.com"}], []}
          ]}]
        ]}
      ]}
    ] 
  end

  #####################
  #  a+img tag tests  #
  #####################
  test "html_2, a, img" do
    assert (MyModuleFloki.check(@html_2, "a, img")) == [
      {"img", [{"src", "im.svg"}], []},
      {"div", [{"id", "child1"}], [
        {"a", [{"href", "google.com"}], []}
      ]},
      {"img", [{"src", "yahoo.svg"}], []},
      {"div", [{"id", "child1of2"}], [
        {"a", [{"href", "yahoo.com"}], []}
      ]}
    ] 
  end

  test "html_3, a, img" do
    assert (MyModuleFloki.check(@html_3, "a, img")) == [
      {"a", [{"href", "google.com"}], []},
      {"img", [{"src", "im.svg"}], []},
      {"img", [{"src", "yahoo.svg"}], []},
      {"div", [{"id", "child1of2"}], [
        {"a", [{"href", "yahoo.com"}], []}
      ]}
    ] 
  end

  #######################################
  # a+img tag tests                     #
  # with image inside "a" tag.          #
  # This is a rare edge case.           #
  # Not sure how we should haldle this  #
  # {"img", [{"src", "apple.svg"}], []} #
  # is included twice (see 3rd and 4th  #
  # elements on the list below)         #
  # Not sure if this is the best way.   #
  # Don't worry about this case.        #
  #######################################
  test "html_1, a, img" do
    assert (MyModuleFloki.check(@html_1, "a, img")) == [
      {"div", [],
        [{"a", [{"href", "https://yahoo.com"}], ["Yahoo"]}]
      },
      {"div", [],
        [{"span", [{"class", "hint"}],
          [{"a", [{"href", "https://google.com"}], ["Google"]}, {"span", [], []}]}]
      },
      {"div", [],
        [{"a", [{"href", "https://apple.com"}, {"target", "_blank"}],
          [{"span", [], ["Apple"]}, {"img", [{"src", "apple.svg"}], []}]
        }]
      },
      {"img", [{"src", "apple.svg"}], []}
    ]
  end

  ###################
  #  simple cases   #
  ###################
  test "returns empty array for empty html" do
    assert (MyModuleFloki.check("", nil)) == []
  end

  test "returns empty array for nil html" do
    assert (MyModuleFloki.check(nil, nil)) == []
  end

  test "returns empty array for empty selector" do
    assert (MyModuleFloki.check(@html_1, "")) == []
  end

  test "returns empty array for nil selector" do
    assert (MyModuleFloki.check(@html_1, nil)) == []
  end


  test "#content" do 
    assert (MyModuleFloki.check(@my_html, "#content")) ==
    [{"section", [{"id", "content"}],
             [{"p", [{"class", "headline"}], ["Floki"]},
              {"span", [{"class", "headline"}],
               ["Enables search using CSS selectors"]},
              {"a", [{"href", "http://github.com/philss/floki"}],
               ["Github page"]},
              {"span", [{"data-model", "user"}], ["philss"]}]}]

  end 
  

end
