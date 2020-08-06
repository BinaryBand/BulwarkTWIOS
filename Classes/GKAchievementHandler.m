


<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
        <title>GKAchievementHandler.m at master from typeoneerror/GKAchievementNotification - GitHub</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />

    
    

    <meta content="authenticity_token" name="csrf-param" />
<meta content="2jzqWY5/HxIfOENsY7EAiw2tJoZDp+rIC2+wKHltre4=" name="csrf-token" />

    <link href="https://a248.e.akamai.net/assets.github.com/stylesheets/bundles/github-011b202e2ecebec7efadd26adafdeb7b64a0bb2e.css" media="screen" rel="stylesheet" type="text/css" />
    

    <script src="https://a248.e.akamai.net/assets.github.com/javascripts/bundles/jquery-ed3a41259bdbf3be7ef7854020787d98a99b969f.js" type="text/javascript"></script>
    <script src="https://a248.e.akamai.net/assets.github.com/javascripts/bundles/github-1859d935d2b08fec4d07a5fcb16a161ade373779.js" type="text/javascript"></script>
    

      <link rel='permalink' href='/typeoneerror/GKAchievementNotification/blob/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511/GKAchievementHandler.m'>
    

    <meta name="description" content="GKAchievementNotification - Game Center styled UI notifications" />
  <link href="https://github.com/typeoneerror/GKAchievementNotification/commits/master.atom" rel="alternate" title="Recent Commits to GKAchievementNotification:master" type="application/atom+xml" />

  </head>


  <body class="logged_out page-blob  env-production ">
    


    

    <div id="main">
      <div id="header" class="true">
          <a class="logo" href="https://github.com">
            <img alt="github" class="default svg" height="45" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov6.svg?1315858552" />
            <img alt="github" class="default png" height="45" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov6.png?1315858552" />
            <!--[if (gt IE 8)|!(IE)]><!-->
            <img alt="github" class="hover svg" height="45" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov6-hover.svg?1315858552" />
            <img alt="github" class="hover png" height="45" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov6-hover.png?1315858552" />
            <!--<![endif]-->
          </a>

        <div class="topsearch">
    <!--
      make sure to use fully qualified URLs here since this nav
      is used on error pages on other domains
    -->
    <ul class="nav logged_out">
        <li class="pricing"><a href="https://github.com/plans">Signup and Pricing</a></li>
        <li class="explore"><a href="https://github.com/explore">Explore GitHub</a></li>
      <li class="features"><a href="https://github.com/features">Features</a></li>
        <li class="blog"><a href="https://github.com/blog">Blog</a></li>
      <li class="login"><a href="https://github.com/login?return_to=%2Ftypeoneerror%2FGKAchievementNotification%2Fblob%2Fmaster%2FGKAchievementHandler.m" rel="nofollow">Login</a></li>
    </ul>
</div>

      </div>

      
            <div class="site">
      <div class="pagehead repohead vis-public   instapaper_ignore readability-menu">


      <div class="title-actions-bar">
        <h1>
          <a href="/typeoneerror">typeoneerror</a> /
          <strong><a href="/typeoneerror/GKAchievementNotification" class="js-current-repository">GKAchievementNotification</a></strong>
        </h1>
        



            <ul class="pagehead-actions">

        <li class="js-toggler-container watch-button-container ">
          <a href="/typeoneerror/GKAchievementNotification/toggle_watch" class="minibutton btn-watch watch-button js-toggler-target" data-method="post" data-remote="true" rel="nofollow"><span><span class="icon"></span>Watch</span></a>
          <a href="/typeoneerror/GKAchievementNotification/toggle_watch" class="minibutton btn-watch unwatch-button js-toggler-target" data-method="post" data-remote="true" rel="nofollow"><span><span class="icon"></span>Unwatch</span></a>
        </li>
            <li><a href="/typeoneerror/GKAchievementNotification/fork" class="minibutton btn-fork fork-button" data-method="post"><span><span class="icon"></span>Fork</span></a></li>

      <li class="repostats">
        <ul class="repo-stats">
          <li class="watchers ">
            <a href="/typeoneerror/GKAchievementNotification/watchers" title="Watchers" class="tooltipped downwards">
              128
            </a>
          </li>
          <li class="forks">
            <a href="/typeoneerror/GKAchievementNotification/network" title="Forks" class="tooltipped downwards">
              23
            </a>
          </li>
        </ul>
      </li>
    </ul>

      </div>

        

  <ul class="tabs">
    <li><a href="/typeoneerror/GKAchievementNotification" class="selected" highlight="repo_sourcerepo_downloadsrepo_commitsrepo_tagsrepo_branches">Code</a></li>
    <li><a href="/typeoneerror/GKAchievementNotification/network" highlight="repo_networkrepo_fork_queue">Network</a>
    <li><a href="/typeoneerror/GKAchievementNotification/pulls" highlight="repo_pulls">Pull Requests <span class='counter'>1</span></a></li>

      <li><a href="/typeoneerror/GKAchievementNotification/issues" highlight="repo_issues">Issues <span class='counter'>2</span></a></li>


    <li><a href="/typeoneerror/GKAchievementNotification/graphs" highlight="repo_graphsrepo_contributors">Stats &amp; Graphs</a></li>

  </ul>

  
<div class="frame frame-center tree-finder" style="display:none"
      data-tree-list-url="/typeoneerror/GKAchievementNotification/tree-list/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511"
      data-blob-url-prefix="/typeoneerror/GKAchievementNotification/blob/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511"
    >

  <div class="breadcrumb">
    <b><a href="/typeoneerror/GKAchievementNotification">GKAchievementNotification</a></b> /
    <input class="tree-finder-input js-navigation-enable" type="text" name="query" autocomplete="off" spellcheck="false">
  </div>

    <div class="octotip">
      <p>
        <a href="/typeoneerror/GKAchievementNotification/dismiss-tree-finder-help" class="dismiss js-dismiss-tree-list-help" title="Hide this notice forever">Dismiss</a>
        <strong>Octotip:</strong> You've activated the <em>file finder</em>
        by pressing <span class="kbd">t</span> Start typing to filter the
        file list. Use <span class="kbd badmono">↑</span> and
        <span class="kbd badmono">↓</span> to navigate,
        <span class="kbd">enter</span> to view files.
      </p>
    </div>

  <table class="tree-browser" cellpadding="0" cellspacing="0">
    <tr class="js-header"><th>&nbsp;</th><th>name</th></tr>
    <tr class="js-no-results no-results" style="display: none">
      <th colspan="2">No matching files</th>
    </tr>
    <tbody class="js-results-list js-navigation-container">
    </tbody>
  </table>
</div>

<div id="jump-to-line" style="display:none">
  <h2>Jump to Line</h2>
  <form>
    <input class="textfield" type="text">
    <div class="full-button">
      <button type="submit" class="classy">
        <span>Go</span>
      </button>
    </div>
  </form>
</div>


<div class="subnav-bar">

  <ul class="actions">
    
      <li class="switcher">

        <div class="context-menu-container js-menu-container">
          <span class="text">Current branch:</span>
          <a href="#"
             class="minibutton bigger switcher context-menu-button js-menu-target js-commitish-button btn-branch repo-tree"
             data-master-branch="master"
             data-ref="master">
            <span><span class="icon"></span>master</span>
          </a>

          <div class="context-pane commitish-context js-menu-content">
            <a href="javascript:;" class="close js-menu-close"></a>
            <div class="title">Switch Branches/Tags</div>
            <div class="body pane-selector commitish-selector js-filterable-commitishes">
              <div class="filterbar">
                <div class="placeholder-field js-placeholder-field">
                  <label class="placeholder" for="context-commitish-filter-field" data-placeholder-mode="sticky">Filter branches/tags</label>
                  <input type="text" id="context-commitish-filter-field" class="commitish-filter" />
                </div>

                <ul class="tabs">
                  <li><a href="#" data-filter="branches" class="selected">Branches</a></li>
                  <li><a href="#" data-filter="tags">Tags</a></li>
                </ul>
              </div>

                <div class="commitish-item branch-commitish selector-item">
                  <h4>
                      <a href="/typeoneerror/GKAchievementNotification/blob/master/GKAchievementHandler.m" data-name="master">master</a>
                  </h4>
                </div>


              <div class="no-results" style="display:none">Nothing to show</div>
            </div>
          </div><!-- /.commitish-context-context -->
        </div>

      </li>
  </ul>

  <ul class="subnav">
    <li><a href="/typeoneerror/GKAchievementNotification" class="selected" highlight="repo_source">Files</a></li>
    <li><a href="/typeoneerror/GKAchievementNotification/commits/master" highlight="repo_commits">Commits</a></li>
    <li><a href="/typeoneerror/GKAchievementNotification/branches" class="" highlight="repo_branches">Branches <span class="counter">1</span></a></li>
    <li><a href="/typeoneerror/GKAchievementNotification/tags" class="blank" highlight="repo_tags">Tags <span class="counter">0</span></a></li>
    <li><a href="/typeoneerror/GKAchievementNotification/downloads" class="blank" highlight="repo_downloads">Downloads <span class="counter">0</span></a></li>
  </ul>

</div>

  
  
  


        

      </div><!-- /.pagehead -->

      




  
  <p class="last-commit">Latest commit to the <strong>master</strong> branch</p>

<div class="commit commit-tease js-details-container">
  <p class="commit-title ">
      <a href="/typeoneerror/GKAchievementNotification/commit/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511" class="message">Merged pull request </a><a href="https://github.com/typeoneerror/GKAchievementNotification/issues/1" title="Added double parens to stop LLVM from complaining" class="issue-link">#1</a><a href="/typeoneerror/GKAchievementNotification/commit/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511" class="message"> from BlueFrogGaming/double_parens.</a>
      <a href="javascript:;" class="minibutton expander-minibutton js-details-target"><span>…</span></a>
  </p>
    <div class="commit-desc"><pre>Added double parens to stop LLVM from complaining</pre></div>
  <div class="commit-meta">
    <a href="/typeoneerror/GKAchievementNotification/commit/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511" class="sha-block">commit <span class="sha">1b2e60b9d5</span></a>

    <div class="authorship">
      <img class="gravatar" height="20" src="https://secure.gravatar.com/avatar/7f25eecbc1d0eed895a2809ce83ddf59?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png" width="20" />
      <span class="author-name"><a href="/typeoneerror">typeoneerror</a></span>
      authored <time class="js-relative-date" datetime="2011-04-29T11:16:05-07:00" title="2011-04-29 11:16:05">April 29, 2011</time>

    </div>
  </div>
</div>


  <div id="slider">

    <div class="breadcrumb" data-path="GKAchievementHandler.m/">
      <b><a href="/typeoneerror/GKAchievementNotification/tree/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511" class="js-rewrite-sha">GKAchievementNotification</a></b> / GKAchievementHandler.m       <span style="display:none" id="clippy_2616" class="clippy-text">GKAchievementHandler.m</span>
      
      <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
              width="110"
              height="14"
              class="clippy"
              id="clippy" >
      <param name="movie" value="https://a248.e.akamai.net/assets.github.com/flash/clippy.swf?1261951368?v5"/>
      <param name="allowScriptAccess" value="always" />
      <param name="quality" value="high" />
      <param name="scale" value="noscale" />
      <param NAME="FlashVars" value="id=clippy_2616&amp;copied=copied!&amp;copyto=copy to clipboard">
      <param name="bgcolor" value="#FFFFFF">
      <param name="wmode" value="opaque">
      <embed src="https://a248.e.akamai.net/assets.github.com/flash/clippy.swf?1261951368?v5"
             width="110"
             height="14"
             name="clippy"
             quality="high"
             allowScriptAccess="always"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer"
             FlashVars="id=clippy_2616&amp;copied=copied!&amp;copyto=copy to clipboard"
             bgcolor="#FFFFFF"
             wmode="opaque"
      />
      </object>
      

    </div>

    <div class="frames">
      <div class="frame frame-center" data-path="GKAchievementHandler.m/" data-permalink-url="/typeoneerror/GKAchievementNotification/blob/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511/GKAchievementHandler.m" data-title="GKAchievementHandler.m at master from typeoneerror/GKAchievementNotification - GitHub" data-type="blob">
          <ul class="big-actions">
            <li><a class="file-edit-link minibutton js-rewrite-sha" href="/typeoneerror/GKAchievementNotification/edit/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511/GKAchievementHandler.m" data-method="post"><span>Edit this file</span></a></li>
          </ul>

        <div id="files">
          <div class="file">
            <div class="meta">
              <div class="info">
                <span class="icon"><img alt="Txt" height="16" src="https://a248.e.akamai.net/assets.github.com/images/icons/txt.png?1252203928" width="16" /></span>
                <span class="mode" title="File Mode">100644</span>
                  <span>118 lines (91 sloc)</span>
                <span>2.607 kb</span>
              </div>
              <ul class="actions">
                <li><a href="/typeoneerror/GKAchievementNotification/raw/master/GKAchievementHandler.m" id="raw-url">raw</a></li>
                  <li><a href="/typeoneerror/GKAchievementNotification/blame/master/GKAchievementHandler.m">blame</a></li>
                <li><a href="/typeoneerror/GKAchievementNotification/commits/master/GKAchievementHandler.m" rel="nofollow">history</a></li>
              </ul>
            </div>
              <div class="data type-objective-c">
      <table cellpadding="0" cellspacing="0" class="lines">
        <tr>
          <td>
            <pre class="line_numbers"><span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>
<span id="L53" rel="#L53">53</span>
<span id="L54" rel="#L54">54</span>
<span id="L55" rel="#L55">55</span>
<span id="L56" rel="#L56">56</span>
<span id="L57" rel="#L57">57</span>
<span id="L58" rel="#L58">58</span>
<span id="L59" rel="#L59">59</span>
<span id="L60" rel="#L60">60</span>
<span id="L61" rel="#L61">61</span>
<span id="L62" rel="#L62">62</span>
<span id="L63" rel="#L63">63</span>
<span id="L64" rel="#L64">64</span>
<span id="L65" rel="#L65">65</span>
<span id="L66" rel="#L66">66</span>
<span id="L67" rel="#L67">67</span>
<span id="L68" rel="#L68">68</span>
<span id="L69" rel="#L69">69</span>
<span id="L70" rel="#L70">70</span>
<span id="L71" rel="#L71">71</span>
<span id="L72" rel="#L72">72</span>
<span id="L73" rel="#L73">73</span>
<span id="L74" rel="#L74">74</span>
<span id="L75" rel="#L75">75</span>
<span id="L76" rel="#L76">76</span>
<span id="L77" rel="#L77">77</span>
<span id="L78" rel="#L78">78</span>
<span id="L79" rel="#L79">79</span>
<span id="L80" rel="#L80">80</span>
<span id="L81" rel="#L81">81</span>
<span id="L82" rel="#L82">82</span>
<span id="L83" rel="#L83">83</span>
<span id="L84" rel="#L84">84</span>
<span id="L85" rel="#L85">85</span>
<span id="L86" rel="#L86">86</span>
<span id="L87" rel="#L87">87</span>
<span id="L88" rel="#L88">88</span>
<span id="L89" rel="#L89">89</span>
<span id="L90" rel="#L90">90</span>
<span id="L91" rel="#L91">91</span>
<span id="L92" rel="#L92">92</span>
<span id="L93" rel="#L93">93</span>
<span id="L94" rel="#L94">94</span>
<span id="L95" rel="#L95">95</span>
<span id="L96" rel="#L96">96</span>
<span id="L97" rel="#L97">97</span>
<span id="L98" rel="#L98">98</span>
<span id="L99" rel="#L99">99</span>
<span id="L100" rel="#L100">100</span>
<span id="L101" rel="#L101">101</span>
<span id="L102" rel="#L102">102</span>
<span id="L103" rel="#L103">103</span>
<span id="L104" rel="#L104">104</span>
<span id="L105" rel="#L105">105</span>
<span id="L106" rel="#L106">106</span>
<span id="L107" rel="#L107">107</span>
<span id="L108" rel="#L108">108</span>
<span id="L109" rel="#L109">109</span>
<span id="L110" rel="#L110">110</span>
<span id="L111" rel="#L111">111</span>
<span id="L112" rel="#L112">112</span>
<span id="L113" rel="#L113">113</span>
<span id="L114" rel="#L114">114</span>
<span id="L115" rel="#L115">115</span>
<span id="L116" rel="#L116">116</span>
<span id="L117" rel="#L117">117</span>
<span id="L118" rel="#L118">118</span>
</pre>
          </td>
          <td width="100%">
                <div class="highlight"><pre><div class='line' id='LC1'><span class="cp">//</span></div><div class='line' id='LC2'><span class="cp">//  GKAchievementHandler.m</span></div><div class='line' id='LC3'><span class="cp">//</span></div><div class='line' id='LC4'><span class="cp">//  Created by Benjamin Borowski on 9/30/10.</span></div><div class='line' id='LC5'><span class="cp">//  Copyright 2010 Typeoneerror Studios. All rights reserved.</span></div><div class='line' id='LC6'><span class="cp">//  $Id$</span></div><div class='line' id='LC7'><span class="cp">//</span></div><div class='line' id='LC8'><br/></div><div class='line' id='LC9'><span class="cp">#import &lt;GameKit/GameKit.h&gt;</span></div><div class='line' id='LC10'><span class="cp">#import &quot;GKAchievementHandler.h&quot;</span></div><div class='line' id='LC11'><span class="cp">#import &quot;GKAchievementNotification.h&quot;</span></div><div class='line' id='LC12'><br/></div><div class='line' id='LC13'><span class="k">static</span> <span class="n">GKAchievementHandler</span> <span class="o">*</span><span class="n">defaultHandler</span> <span class="o">=</span> <span class="nb">nil</span><span class="p">;</span></div><div class='line' id='LC14'><br/></div><div class='line' id='LC15'><span class="cp">#pragma mark -</span></div><div class='line' id='LC16'><br/></div><div class='line' id='LC17'><span class="k">@interface</span> <span class="nc">GKAchievementHandler</span><span class="nl">(private)</span></div><div class='line' id='LC18'><br/></div><div class='line' id='LC19'><span class="k">-</span> <span class="p">(</span><span class="kt">void</span><span class="p">)</span><span class="nf">displayNotification:</span><span class="p">(</span><span class="n">GKAchievementNotification</span> <span class="o">*</span><span class="p">)</span><span class="nv">notification</span><span class="p">;</span></div><div class='line' id='LC20'><br/></div><div class='line' id='LC21'><span class="k">@end</span></div><div class='line' id='LC22'><br/></div><div class='line' id='LC23'><span class="cp">#pragma mark -</span></div><div class='line' id='LC24'><br/></div><div class='line' id='LC25'><span class="k">@implementation</span> <span class="nc">GKAchievementHandler</span><span class="nl">(private)</span></div><div class='line' id='LC26'><br/></div><div class='line' id='LC27'><span class="k">-</span> <span class="p">(</span><span class="kt">void</span><span class="p">)</span><span class="nf">displayNotification:</span><span class="p">(</span><span class="n">GKAchievementNotification</span> <span class="o">*</span><span class="p">)</span><span class="nv">notification</span></div><div class='line' id='LC28'><span class="p">{</span></div><div class='line' id='LC29'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">self</span><span class="p">.</span><span class="n">image</span> <span class="o">!=</span> <span class="nb">nil</span><span class="p">)</span></div><div class='line' id='LC30'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC31'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">notification</span> <span class="nl">setImage:</span><span class="n">self</span><span class="p">.</span><span class="n">image</span><span class="p">];</span></div><div class='line' id='LC32'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC33'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC34'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC35'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">notification</span> <span class="nl">setImage:</span><span class="nb">nil</span><span class="p">];</span></div><div class='line' id='LC36'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC37'><br/></div><div class='line' id='LC38'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">_topView</span> <span class="nl">addSubview:</span><span class="n">notification</span><span class="p">];</span></div><div class='line' id='LC39'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">notification</span> <span class="n">animateIn</span><span class="p">];</span></div><div class='line' id='LC40'><span class="p">}</span></div><div class='line' id='LC41'><br/></div><div class='line' id='LC42'><span class="k">@end</span></div><div class='line' id='LC43'><br/></div><div class='line' id='LC44'><span class="cp">#pragma mark -</span></div><div class='line' id='LC45'><br/></div><div class='line' id='LC46'><span class="k">@implementation</span> <span class="nc">GKAchievementHandler</span></div><div class='line' id='LC47'><br/></div><div class='line' id='LC48'><span class="k">@synthesize</span> <span class="n">image</span><span class="o">=</span><span class="n">_image</span><span class="p">;</span></div><div class='line' id='LC49'><br/></div><div class='line' id='LC50'><span class="cp">#pragma mark -</span></div><div class='line' id='LC51'><br/></div><div class='line' id='LC52'><span class="k">+</span> <span class="p">(</span><span class="n">GKAchievementHandler</span> <span class="o">*</span><span class="p">)</span><span class="nf">defaultHandler</span></div><div class='line' id='LC53'><span class="p">{</span></div><div class='line' id='LC54'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="o">!</span><span class="n">defaultHandler</span><span class="p">)</span> <span class="n">defaultHandler</span> <span class="o">=</span> <span class="p">[[</span><span class="n">self</span> <span class="n">alloc</span><span class="p">]</span> <span class="n">init</span><span class="p">];</span></div><div class='line' id='LC55'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="n">defaultHandler</span><span class="p">;</span></div><div class='line' id='LC56'><span class="p">}</span></div><div class='line' id='LC57'><br/></div><div class='line' id='LC58'><span class="k">-</span> <span class="p">(</span><span class="kt">id</span><span class="p">)</span><span class="nf">init</span></div><div class='line' id='LC59'><span class="p">{</span></div><div class='line' id='LC60'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">self</span> <span class="o">=</span> <span class="p">[</span><span class="n">super</span> <span class="n">init</span><span class="p">];</span></div><div class='line' id='LC61'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">self</span> <span class="o">!=</span> <span class="nb">nil</span><span class="p">)</span></div><div class='line' id='LC62'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC63'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">_topView</span> <span class="o">=</span> <span class="p">[[</span><span class="n">UIApplication</span> <span class="n">sharedApplication</span><span class="p">]</span> <span class="n">keyWindow</span><span class="p">];</span></div><div class='line' id='LC64'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">_queue</span> <span class="o">=</span> <span class="p">[[</span><span class="n">NSMutableArray</span> <span class="n">alloc</span><span class="p">]</span> <span class="nl">initWithCapacity:</span><span class="mi">0</span><span class="p">];</span></div><div class='line' id='LC65'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">self</span><span class="p">.</span><span class="n">image</span> <span class="o">=</span> <span class="p">[</span><span class="n">UIImage</span> <span class="nl">imageNamed:</span><span class="s">@&quot;gk-icon.png&quot;</span><span class="p">];</span></div><div class='line' id='LC66'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC67'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="n">self</span><span class="p">;</span></div><div class='line' id='LC68'><span class="p">}</span></div><div class='line' id='LC69'><br/></div><div class='line' id='LC70'><span class="k">-</span> <span class="p">(</span><span class="kt">void</span><span class="p">)</span><span class="nf">dealloc</span></div><div class='line' id='LC71'><span class="p">{</span></div><div class='line' id='LC72'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">_queue</span> <span class="n">release</span><span class="p">];</span></div><div class='line' id='LC73'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">_image</span> <span class="n">release</span><span class="p">];</span></div><div class='line' id='LC74'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">super</span> <span class="n">dealloc</span><span class="p">];</span></div><div class='line' id='LC75'><span class="p">}</span></div><div class='line' id='LC76'><br/></div><div class='line' id='LC77'><span class="cp">#pragma mark -</span></div><div class='line' id='LC78'><br/></div><div class='line' id='LC79'><span class="k">-</span> <span class="p">(</span><span class="kt">void</span><span class="p">)</span><span class="nf">notifyAchievement:</span><span class="p">(</span><span class="n">GKAchievementDescription</span> <span class="o">*</span><span class="p">)</span><span class="nv">achievement</span></div><div class='line' id='LC80'><span class="p">{</span></div><div class='line' id='LC81'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">GKAchievementNotification</span> <span class="o">*</span><span class="n">notification</span> <span class="o">=</span> <span class="p">[[[</span><span class="n">GKAchievementNotification</span> <span class="n">alloc</span><span class="p">]</span> <span class="nl">initWithAchievementDescription:</span><span class="n">achievement</span><span class="p">]</span> <span class="n">autorelease</span><span class="p">];</span></div><div class='line' id='LC82'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">notification</span><span class="p">.</span><span class="n">frame</span> <span class="o">=</span> <span class="n">kGKAchievementFrameStart</span><span class="p">;</span></div><div class='line' id='LC83'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">notification</span><span class="p">.</span><span class="n">handlerDelegate</span> <span class="o">=</span> <span class="n">self</span><span class="p">;</span></div><div class='line' id='LC84'><br/></div><div class='line' id='LC85'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">_queue</span> <span class="nl">addObject:</span><span class="n">notification</span><span class="p">];</span></div><div class='line' id='LC86'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">([</span><span class="n">_queue</span> <span class="n">count</span><span class="p">]</span> <span class="o">==</span> <span class="mi">1</span><span class="p">)</span></div><div class='line' id='LC87'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC88'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">self</span> <span class="nl">displayNotification:</span><span class="n">notification</span><span class="p">];</span></div><div class='line' id='LC89'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC90'><span class="p">}</span></div><div class='line' id='LC91'><br/></div><div class='line' id='LC92'><span class="k">-</span> <span class="p">(</span><span class="kt">void</span><span class="p">)</span><span class="nf">notifyAchievementTitle:</span><span class="p">(</span><span class="n">NSString</span> <span class="o">*</span><span class="p">)</span><span class="nv">title</span> <span class="nf">andMessage:</span><span class="p">(</span><span class="n">NSString</span> <span class="o">*</span><span class="p">)</span><span class="nv">message</span></div><div class='line' id='LC93'><span class="p">{</span></div><div class='line' id='LC94'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">GKAchievementNotification</span> <span class="o">*</span><span class="n">notification</span> <span class="o">=</span> <span class="p">[[[</span><span class="n">GKAchievementNotification</span> <span class="n">alloc</span><span class="p">]</span> <span class="nl">initWithTitle:</span><span class="n">title</span> <span class="nl">andMessage:</span><span class="n">message</span><span class="p">]</span> <span class="n">autorelease</span><span class="p">];</span></div><div class='line' id='LC95'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">notification</span><span class="p">.</span><span class="n">frame</span> <span class="o">=</span> <span class="n">kGKAchievementFrameStart</span><span class="p">;</span></div><div class='line' id='LC96'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">notification</span><span class="p">.</span><span class="n">handlerDelegate</span> <span class="o">=</span> <span class="n">self</span><span class="p">;</span></div><div class='line' id='LC97'><br/></div><div class='line' id='LC98'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">_queue</span> <span class="nl">addObject:</span><span class="n">notification</span><span class="p">];</span></div><div class='line' id='LC99'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">([</span><span class="n">_queue</span> <span class="n">count</span><span class="p">]</span> <span class="o">==</span> <span class="mi">1</span><span class="p">)</span></div><div class='line' id='LC100'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC101'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">self</span> <span class="nl">displayNotification:</span><span class="n">notification</span><span class="p">];</span></div><div class='line' id='LC102'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC103'><span class="p">}</span></div><div class='line' id='LC104'><br/></div><div class='line' id='LC105'><span class="cp">#pragma mark -</span></div><div class='line' id='LC106'><span class="cp">#pragma mark GKAchievementHandlerDelegate implementation</span></div><div class='line' id='LC107'><br/></div><div class='line' id='LC108'><span class="k">-</span> <span class="p">(</span><span class="kt">void</span><span class="p">)</span><span class="nf">didHideAchievementNotification:</span><span class="p">(</span><span class="n">GKAchievementNotification</span> <span class="o">*</span><span class="p">)</span><span class="nv">notification</span></div><div class='line' id='LC109'><span class="p">{</span></div><div class='line' id='LC110'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">_queue</span> <span class="nl">removeObjectAtIndex:</span><span class="mi">0</span><span class="p">];</span></div><div class='line' id='LC111'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">([</span><span class="n">_queue</span> <span class="n">count</span><span class="p">])</span></div><div class='line' id='LC112'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC113'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">[</span><span class="n">self</span> <span class="nl">displayNotification:</span><span class="p">(</span><span class="n">GKAchievementNotification</span> <span class="o">*</span><span class="p">)[</span><span class="n">_queue</span> <span class="nl">objectAtIndex:</span><span class="mi">0</span><span class="p">]];</span></div><div class='line' id='LC114'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC115'><span class="p">}</span></div><div class='line' id='LC116'><br/></div><div class='line' id='LC117'><span class="k">@end</span></div><div class='line' id='LC118'><br/></div></pre></div>
          </td>
        </tr>
      </table>
  </div>

          </div>
        </div>
      </div>
    </div>

  </div>

<div class="frame frame-loading" style="display:none;" data-tree-list-url="/typeoneerror/GKAchievementNotification/tree-list/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511" data-blob-url-prefix="/typeoneerror/GKAchievementNotification/blob/1b2e60b9d562136ea6f9ea0c0cfe6c2e490aa511">
  <img src="https://a248.e.akamai.net/assets.github.com/images/modules/ajax/big_spinner_336699.gif?1310104853" height="32" width="32">
</div>

    </div>

    </div>

    <!-- footer -->
    <div id="footer" >
      
  <div class="upper_footer">
     <div class="site" class="clearfix">

       <!--[if IE]><h4 id="blacktocat_ie">GitHub Links</h4><![endif]-->
       <![if !IE]><h4 id="blacktocat">GitHub Links</h4><![endif]>

       <ul class="footer_nav">
         <h4>GitHub</h4>
         <li><a href="https://github.com/about">About</a></li>
         <li><a href="https://github.com/blog">Blog</a></li>
         <li><a href="https://github.com/features">Features</a></li>
         <li><a href="https://github.com/contact">Contact &amp; Support</a></li>
         <li><a href="https://github.com/training">Training</a></li>
         <li><a href="http://status.github.com/">Site Status</a></li>
       </ul>

       <ul class="footer_nav">
         <h4>Tools</h4>
         <li><a href="http://mac.github.com/">GitHub for Mac</a></li>
         <li><a href="http://mobile.github.com/">Issues for iPhone</a></li>
         <li><a href="https://gist.github.com">Gist: Code Snippets</a></li>
         <li><a href="http://enterprise.github.com/">GitHub Enterprise</a></li>
         <li><a href="http://jobs.github.com/">Job Board</a></li>
       </ul>

       <ul class="footer_nav">
         <h4>Extras</h4>
         <li><a href="http://shop.github.com/">GitHub Shop</a></li>
         <li><a href="http://octodex.github.com/">The Octodex</a></li>
       </ul>

       <ul class="footer_nav">
         <h4>Documentation</h4>
         <li><a href="http://help.github.com/">GitHub Help</a></li>
         <li><a href="http://developer.github.com/">Developer API</a></li>
         <li><a href="http://github.github.com/github-flavored-markdown/">GitHub Flavored Markdown</a></li>
         <li><a href="http://pages.github.com/">GitHub Pages</a></li>
       </ul>

     </div><!-- /.site -->
  </div><!-- /.upper_footer -->

<div class="lower_footer">
  <div class="site" class="clearfix">
    <!--[if IE]><div id="legal_ie"><![endif]-->
    <![if !IE]><div id="legal"><![endif]>
      <ul>
          <li><a href="https://github.com/site/terms">Terms of Service</a></li>
          <li><a href="https://github.com/site/privacy">Privacy</a></li>
          <li><a href="https://github.com/security">Security</a></li>
      </ul>

      <p>&copy; 2011 <span id="_rrt" title="0.16853s from fe8.rs.github.com">GitHub</span> Inc. All rights reserved.</p>
    </div><!-- /#legal or /#legal_ie-->

      <div class="sponsor">
        <a href="http://www.rackspace.com" class="logo">
          <img alt="Dedicated Server" height="36" src="https://a248.e.akamai.net/assets.github.com/images/modules/footer/rackspace_logo.png?v2" width="38" />
        </a>
        Powered by the <a href="http://www.rackspace.com ">Dedicated
        Servers</a> and<br/> <a href="http://www.rackspacecloud.com">Cloud
        Computing</a> of Rackspace Hosting<span>&reg;</span>
      </div>
  </div><!-- /.site -->
</div><!-- /.lower_footer -->

    </div><!-- /#footer -->

    

<div id="keyboard_shortcuts_pane" class="instapaper_ignore readability-extra" style="display:none">
  <h2>Keyboard Shortcuts <small><a href="#" class="js-see-all-keyboard-shortcuts">(see all)</a></small></h2>

  <div class="columns threecols">
    <div class="column first">
      <h3>Site wide shortcuts</h3>
      <dl class="keyboard-mappings">
        <dt>s</dt>
        <dd>Focus site search</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>?</dt>
        <dd>Bring up this help dialog</dd>
      </dl>
    </div><!-- /.column.first -->

    <div class="column middle" style='display:none'>
      <h3>Commit list</h3>
      <dl class="keyboard-mappings">
        <dt>j</dt>
        <dd>Move selection down</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>k</dt>
        <dd>Move selection up</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>c <em>or</em> o <em>or</em> enter</dt>
        <dd>Open commit</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>y</dt>
        <dd>Expand URL to its canonical form</dd>
      </dl>
    </div><!-- /.column.first -->

    <div class="column last" style='display:none'>
      <h3>Pull request list</h3>
      <dl class="keyboard-mappings">
        <dt>j</dt>
        <dd>Move selection down</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>k</dt>
        <dd>Move selection up</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>o <em>or</em> enter</dt>
        <dd>Open issue</dd>
      </dl>
    </div><!-- /.columns.last -->

  </div><!-- /.columns.equacols -->

  <div style='display:none'>
    <div class="rule"></div>

    <h3>Issues</h3>

    <div class="columns threecols">
      <div class="column first">
        <dl class="keyboard-mappings">
          <dt>j</dt>
          <dd>Move selection down</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>k</dt>
          <dd>Move selection up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>x</dt>
          <dd>Toggle selection</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>o <em>or</em> enter</dt>
          <dd>Open issue</dd>
        </dl>
      </div><!-- /.column.first -->
      <div class="column middle">
        <dl class="keyboard-mappings">
          <dt>I</dt>
          <dd>Mark selection as read</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>U</dt>
          <dd>Mark selection as unread</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>e</dt>
          <dd>Close selection</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>y</dt>
          <dd>Remove selection from view</dd>
        </dl>
      </div><!-- /.column.middle -->
      <div class="column last">
        <dl class="keyboard-mappings">
          <dt>c</dt>
          <dd>Create issue</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>l</dt>
          <dd>Create label</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>i</dt>
          <dd>Back to inbox</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>u</dt>
          <dd>Back to issues</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>/</dt>
          <dd>Focus issues search</dd>
        </dl>
      </div>
    </div>
  </div>

  <div style='display:none'>
    <div class="rule"></div>

    <h3>Issues Dashboard</h3>

    <div class="columns threecols">
      <div class="column first">
        <dl class="keyboard-mappings">
          <dt>j</dt>
          <dd>Move selection down</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>k</dt>
          <dd>Move selection up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>o <em>or</em> enter</dt>
          <dd>Open issue</dd>
        </dl>
      </div><!-- /.column.first -->
    </div>
  </div>

  <div style='display:none'>
    <div class="rule"></div>

    <h3>Network Graph</h3>
    <div class="columns equacols">
      <div class="column first">
        <dl class="keyboard-mappings">
          <dt><span class="badmono">←</span> <em>or</em> h</dt>
          <dd>Scroll left</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt><span class="badmono">→</span> <em>or</em> l</dt>
          <dd>Scroll right</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt><span class="badmono">↑</span> <em>or</em> k</dt>
          <dd>Scroll up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt><span class="badmono">↓</span> <em>or</em> j</dt>
          <dd>Scroll down</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>t</dt>
          <dd>Toggle visibility of head labels</dd>
        </dl>
      </div><!-- /.column.first -->
      <div class="column last">
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">←</span> <em>or</em> shift h</dt>
          <dd>Scroll all the way left</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">→</span> <em>or</em> shift l</dt>
          <dd>Scroll all the way right</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">↑</span> <em>or</em> shift k</dt>
          <dd>Scroll all the way up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">↓</span> <em>or</em> shift j</dt>
          <dd>Scroll all the way down</dd>
        </dl>
      </div><!-- /.column.last -->
    </div>
  </div>

  <div >
    <div class="rule"></div>
    <div class="columns threecols">
      <div class="column first" >
        <h3>Source Code Browsing</h3>
        <dl class="keyboard-mappings">
          <dt>t</dt>
          <dd>Activates the file finder</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>l</dt>
          <dd>Jump to line</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>w</dt>
          <dd>Switch branch/tag</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>y</dt>
          <dd>Expand URL to its canonical form</dd>
        </dl>
      </div>
    </div>
  </div>
</div>

    <div id="markdown-help" class="instapaper_ignore readability-extra">
  <h2>Markdown Cheat Sheet</h2>

  <div class="cheatsheet-content">

  <div class="mod">
    <div class="col">
      <h3>Format Text</h3>
      <p>Headers</p>
      <pre>
# This is an &lt;h1&gt; tag
## This is an &lt;h2&gt; tag
###### This is an &lt;h6&gt; tag</pre>
     <p>Text styles</p>
     <pre>
*This text will be italic*
_This will also be italic_
**This text will be bold**
__This will also be bold__

*You **can** combine them*
</pre>
    </div>
    <div class="col">
      <h3>Lists</h3>
      <p>Unordered</p>
      <pre>
* Item 1
* Item 2
  * Item 2a
  * Item 2b</pre>
     <p>Ordered</p>
     <pre>
1. Item 1
2. Item 2
3. Item 3
   * Item 3a
   * Item 3b</pre>
    </div>
    <div class="col">
      <h3>Miscellaneous</h3>
      <p>Images</p>
      <pre>
![GitHub Logo](/images/logo.png)
Format: ![Alt Text](url)
</pre>
     <p>Links</p>
     <pre>
http://github.com - automatic!
[GitHub](http://github.com)</pre>
<p>Blockquotes</p>
     <pre>
As Kanye West said:
> We're living the future so
> the present is our past.
</pre>
    </div>
  </div>
  <div class="rule"></div>

  <h3>Code Examples in Markdown</h3>
  <div class="col">
      <p>Syntax highlighting with <a href="http://github.github.com/github-flavored-markdown/" title="GitHub Flavored Markdown" target="_blank">GFM</a></p>
      <pre>
```javascript
function fancyAlert(arg) {
  if(arg) {
    $.facebox({div:'#foo'})
  }
}
```</pre>
    </div>
    <div class="col">
      <p>Or, indent your code 4 spaces</p>
      <pre>
Here is a Python code example
without syntax highlighting:

    def foo:
      if not bar:
        return true</pre>
    </div>
    <div class="col">
      <p>Inline code for comments</p>
      <pre>
I think you should use an
`&lt;addr&gt;` element here instead.</pre>
    </div>
  </div>

  </div>
</div>

    <div class="context-overlay"></div>

    <div class="ajax-error-message">
      <p><span class="icon"></span> Something went wrong with that request. Please try again. <a href="javascript:;" class="ajax-error-dismiss">Dismiss</a></p>
    </div>

    
    
    
  </body>
</html>

