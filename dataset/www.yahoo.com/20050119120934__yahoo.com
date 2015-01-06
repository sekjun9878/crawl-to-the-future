













<!DOCTYPE html>



<!-- HEADER -->
<html>
	<head>
		<title>Internet Archive Wayback Machine</title>
		<script type="text/javascript" src="/static/js/analytics.js"></script>
		<script type="text/javascript">archive_analytics.values.server_name="wwwb-app11.us.archive.org";archive_analytics.values.server_ms=1687;</script>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="/static/css/styles.css" />
		<base target="_top" />
				
		<link rel="stylesheet" type="text/css" href="//archive.org/includes/bootstrap.min.css">
		<link rel="stylesheet" type="text/css" href="//archive.org/includes/archive.css">
		<script src="/includes/jquery-1.7.1.min.js"></script>
		<script src="/includes/bootstrap.min.js"></script>
		
	</head>
	<body>
        
          
        

<script type="text/javascript">
$(document).ready(function(){try{if(window.top===window)return}catch(e){}$('#donate,.navbar-static-top').hide()});
</script>
<!-- /HEADER -->

<script type="text/javascript">
function SetCookie(cookieName,cookieValue,nDays) {
  var today = new Date();
  var expire = new Date();
  if (nDays==null || nDays==0) nDays=1;
  expire.setTime(today.getTime() + 86400000*nDays);
  document.cookie = cookieName+"="+escape(cookieValue)
    + ";expires="+expire.toGMTString() + ";path=/";
}
function SetAnchorDate(date) {
  SetCookie("request.anchordate",date,365);
}
function SetAnchorWindow(maxSeconds) {
  SetCookie("request.anchorwindow",maxSeconds,365);
}
</script>




<script type="text/javascript" src="/static/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/static/js/excanvas.compiled.js"></script>
<script type="text/javascript" src="/static/js/jquery.bt.min.js" charset="utf-8"></script>
<script type="text/javascript" src="/static/js/jquery.hoverIntent.minified.js" charset="utf-8"></script>
<script type="text/javascript" src="/static/js/graph-calc.js" ></script>
<!-- More ugly JS to manage the highlight over the graph -->
<script type="text/javascript">
var wbCurrentUrl = "http:\/\/yahoo.com";

var firstYear = 1996;
var curYear = -1;
var startYear = 2005 - firstYear;
var imgWidth = 980;
var yearImgWidth = 49;
var monthImgWidth = 5;

function showTrackers(val) {
    $('#wbMouseTrackYearImg').css('display', val);
}
function setActiveYear(year) {
    if (curYear != year) {
        var yrOff = year * yearImgWidth;
	$('#wbMouseTrackYearImg').css('left', yrOff + "px");
	if (curYear != -1) {
	    $('#year-labels a:nth('+curYear+')').removeClass('activeHighlight');
	}
	$('#year-labels a:nth('+year+')').addClass('activeHighlight');
        curYear = year;
    }
}
function mouseOnYear(ev) {
    var y = $(ev.target).data('year');
    showTrackers('inline');
    setActiveYear(y - firstYear);
}
function trackMouseMove(event) {
    var element = event.target;
    var eventX = event.pageX;
    var elementX = Math.round($(element).offset().left);
    var xOff = Math.min(Math.max(0, eventX - elementX), imgWidth);

    var monthOff = xOff % yearImgWidth;
    var year = Math.floor(xOff / yearImgWidth);
    var monthOfYear = Math.min(Math.floor(monthOff / monthImgWidth), 11);
    var month = (year * 12) + monthOfYear;
    var dayOff = monthOff % monthImgWidth;
    var day = dayOff > (monthImgWidth / 2) ? 15 : 1;
    var dateString = 
	    zeroPad(year + firstYear) + 
	    zeroPad(monthOfYear+1,2) +
	    zeroPad(day,2) + "000000";

    var url = "/web/" + dateString + '*/' +  wbCurrentUrl;
    $('#wm-graph-anchor').attr('href', url);
    setActiveYear(year);
}
</script>
<script type="text/javascript">
$().ready(function(){
    $("#year-labels").on('mouseover', 'a', mouseOnYear);
    //$(".wbChartThisContainer div").mouseover(mouseOnYear);
    $("#wbChart").mouseout(function(){
        showTrackers('none'); setActiveYear(startYear);
    });
    $("#sparklineImgId").mousemove(trackMouseMove).mouseover(function(){
        showTrackers('inline');
    });
    $(".date").each(function(i){
	var actualsize = $(this).attr("count");
        var size = (Math.min(actualsize, 10) - 1) * 10 + 30; //* 12;
        var offset = -size / 2;
        $(this).find("img").attr("src","/static/images/blueblob-dk.png");
        $(this).find(".measure").css({width:size+'px',height:size+'px',top:offset+'px',left:offset+'px'});
    });
    $(".day a").each(function(i){
        var dateClass = $(this).attr("class");
        var dateId = "#"+dateClass;
        $(this).hover(
            function(){$(dateId).removeClass("opacity20");},
            function(){$(dateId).addClass("opacity20");}
        );
    });
    $(".captures").bt({
        positions: ['top','right','left','bottom'],
        contentSelector: "$(this).find('.pop').html()",
        padding: 0, width: '130px', overlap: 0, cornerRadius: 5,
        spikeGirth: 8, spikeLength: 8,
        fill: '#efefef',
        strokeWidth: 1, strokeStyle: '#efefef',
        shadow: true, shadowColor: '#333', shadowBlur: 5,
        shadowOffsetX: 0, shadowOffsetY: 0, 
        noShadowOpts: {strokeStyle:'#ccc'},
        hoverIntentOpts: {interval:60,timeout:2000},
        clickAnywhereToClose: true,
        closeWhenOthersOpen: true,
        windowMargin: 30,
        cssStyles: {
            fontSize: '12px',
            fontFamily: '"Arial","Helvetica Neue","Helvetica",sans-serif',
            lineHeight: 'normal',
            padding: '10px',
            color: '#333'
        }
    });
});
</script>
<div id="position">
  <div id="wbSearch">
    <a href="/web/"><img src="/static/images/logo_WM.png" alt="logo: Internet Archive's Wayback Machine" width="183" height="65" /></a>
    <form name="form" method="get" action="/web/query" onsubmit="if (''==$('#query_url').val()){$('#query_url').attr('placeholder', 'enter a web address')} else {document.location.href='/web/*/'+$('#query_url').val();} return false;">
      <input type="hidden" name="type" value="urlquery">
      <input id="query_url" type="text" name="url" value="http://yahoo.com" placeholder="http://" size="40" maxlength="256">
      <input class="web_button" type="submit" name="Submit" value="BROWSE HISTORY"/>
    </form>
    <div id="wbMeta">
      <p class="wbUrl"><a href="http://yahoo.com"><strong>http://yahoo.com</strong></a></p>
      <p>Saved <strong>40805 times</strong>
      
      
      
      
      
        between
	<a href="/web/19961017235908/http://www2.yahoo.com/">Thu Oct 17 23:59:08 UTC 1996</a>
	and
	<a href="/web/20150106063116/https://www.yahoo.com/">Tue Jan 06 06:31:16 UTC 2015</a>.
      
      
      </p>
      <p style="margin-top:2ex;"><a href="//archive.org/donate" target="_blank"><strong>PLEASE DONATE TODAY.</strong> Your generosity preserves knowledge for future generations. Thank you.</a></p>
    </div>
  </div>
  <div id="wbChart">
    <div id="wbChartThis" style="width:980px">
      <a href="/web/" id="wm-graph-anchor">
      <div id="wm-ipp-sparkline" style="height:76px" title="Explore captures for this URL">
        <img id="sparklineImgId" alt="sparklines"
	  style="position:absolute;z-index:9012;top:-1px;left:0;border:none;"
	  width="980" height="75"
	  src="/web/jsp/graph.jsp?nomonth=1&graphdata=980_75_1996:-1:000000000314_1997:-1:121223210300_1998:-1:030001300001_1999:-1:243510001210_2000:-1:037587577803_2001:-1:2036cc9a9a97_2002:-1:100153666794_2003:-1:354545223646_2004:-1:555677767565_2005:0:576666678889_2006:-1:876856876677_2007:-1:878888788867_2008:-1:777887666777_2009:-1:878887777877_2010:-1:778888888889_2011:-1:999999999bbc_2012:-1:cccbcbbbbcbc_2013:-1:ccddddddccdd_2014:-1:eeeeeeefeeee_2015:-1:b00000000000"></img>
	<div id="wbMouseTrackYearImg" style="display:none;position:absolute;z-index:9010;width:48px;height:74px;border:none;background-color:#ffff00;"></div>
      </div>
      </a>
      <div id="year-labels">
      
	
	<a class="year-label " href="/web/199602010000000*/http://yahoo.com" data-year="1996">1996</a>
      
	
	<a class="year-label " href="/web/199702010000000*/http://yahoo.com" data-year="1997">1997</a>
      
	
	<a class="year-label " href="/web/199802010000000*/http://yahoo.com" data-year="1998">1998</a>
      
	
	<a class="year-label " href="/web/199902010000000*/http://yahoo.com" data-year="1999">1999</a>
      
	
	<a class="year-label " href="/web/200002010000000*/http://yahoo.com" data-year="2000">2000</a>
      
	
	<a class="year-label " href="/web/200102010000000*/http://yahoo.com" data-year="2001">2001</a>
      
	
	<a class="year-label " href="/web/200202010000000*/http://yahoo.com" data-year="2002">2002</a>
      
	
	<a class="year-label " href="/web/200302010000000*/http://yahoo.com" data-year="2003">2003</a>
      
	
	<a class="year-label " href="/web/200402010000000*/http://yahoo.com" data-year="2004">2004</a>
      
	
	<a class="year-label activeHighlight" href="/web/200502010000000*/http://yahoo.com" data-year="2005">2005</a>
      
	
	<a class="year-label " href="/web/200602010000000*/http://yahoo.com" data-year="2006">2006</a>
      
	
	<a class="year-label " href="/web/200702010000000*/http://yahoo.com" data-year="2007">2007</a>
      
	
	<a class="year-label " href="/web/200802010000000*/http://yahoo.com" data-year="2008">2008</a>
      
	
	<a class="year-label " href="/web/200902010000000*/http://yahoo.com" data-year="2009">2009</a>
      
	
	<a class="year-label " href="/web/201002010000000*/http://yahoo.com" data-year="2010">2010</a>
      
	
	<a class="year-label " href="/web/201102010000000*/http://yahoo.com" data-year="2011">2011</a>
      
	
	<a class="year-label " href="/web/201202010000000*/http://yahoo.com" data-year="2012">2012</a>
      
	
	<a class="year-label " href="/web/201302010000000*/http://yahoo.com" data-year="2013">2013</a>
      
	
	<a class="year-label " href="/web/201402010000000*/http://yahoo.com" data-year="2014">2014</a>
      
	
	<a class="year-label " href="/web/201502010000000*/http://yahoo.com" data-year="2015">2015</a>
      
      </div>
    </div>
  </div>
  <div class="clearfix"></div>
  <div id="wbCalendar">
  <div id="calUnder" class="calPosition">

  
    
    <div class="month" id="2005-0">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Jan 10 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Tue Jan 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Jan 12 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Jan 14 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Jan 16 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Jan 17 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Wed Jan 19 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Jan 22 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Jan 23 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Jan 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Wed Jan 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Jan 30 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-1">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Feb 02 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Thu Feb 03 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Fri Feb 04 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Feb 05 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Sun Feb 06 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Mon Feb 07 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Tue Feb 08 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed Feb 09 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Thu Feb 10 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Fri Feb 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Sat Feb 12 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Feb 13 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Mon Feb 14 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Tue Feb 15 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Feb 17 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Feb 18 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Feb 19 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Tue Feb 22 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Feb 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Feb 28 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-2">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Tue Mar 01 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Mar 02 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Mar 04 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Mon Mar 07 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Mar 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Mar 12 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Tue Mar 15 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed Mar 16 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Mar 17 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Mar 21 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Tue Mar 22 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Mar 23 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Mar 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Mar 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Mar 28 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Tue Mar 29 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed Mar 30 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-3">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Apr 01 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Apr 07 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Fri Apr 08 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Apr 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Apr 13 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Apr 14 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Apr 15 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Apr 17 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Apr 18 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Apr 20 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Apr 21 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Fri Apr 22 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Apr 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Tue Apr 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Apr 27 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Apr 28 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-4">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon May 02 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu May 05 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat May 07 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon May 09 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed May 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu May 12 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat May 14 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Mon May 16 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed May 18 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu May 19 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri May 20 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun May 22 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Tue May 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Wed May 25 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu May 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Fri May 27 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-5">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Jun 02 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Jun 04 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Jun 05 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Jun 06 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Tue Jun 07 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed Jun 08 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Jun 09 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Jun 10 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Sat Jun 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Jun 13 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed Jun 15 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Jun 16 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Jun 19 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Jun 20 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Tue Jun 21 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed Jun 22 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Jun 23 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Jun 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Jun 25 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Jun 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Tue Jun 28 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Jun 30 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-6">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Jul 02 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Jul 03 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Jul 04 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed Jul 06 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Thu Jul 07 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Jul 08 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Jul 10 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Jul 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed Jul 13 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Jul 14 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Jul 18 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Tue Jul 19 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Jul 21 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Sun Jul 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Tue Jul 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Jul 27 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Jul 28 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Jul 29 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Jul 31 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-7">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Aug 01 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Aug 04 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Aug 08 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Tue Aug 09 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed Aug 10 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Aug 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Aug 12 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Aug 13 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Aug 15 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Aug 20 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Aug 22 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Tue Aug 23 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Aug 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Thu Aug 25 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Fri Aug 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Aug 27 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Aug 28 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Mon Aug 29 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="5">
		  <div class="position">
		    <div class="hidden">5</div>
		    <div class="measure opacity20" id="Tue Aug 30 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-8">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Sep 01 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Sep 02 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Sep 04 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Mon Sep 05 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Tue Sep 06 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Wed Sep 07 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Sep 08 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Fri Sep 09 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Sat Sep 10 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Sep 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Sep 12 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Tue Sep 13 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Wed Sep 14 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Sep 15 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Sat Sep 17 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Mon Sep 19 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Tue Sep 20 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Sep 22 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Fri Sep 23 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="12">
		  <div class="position">
		    <div class="hidden">12</div>
		    <div class="measure opacity20" id="Sat Sep 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sun Sep 25 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Mon Sep 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Wed Sep 28 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Sep 29 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Fri Sep 30 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-9">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="7">
		  <div class="position">
		    <div class="hidden">7</div>
		    <div class="measure opacity20" id="Sat Oct 01 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Oct 03 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Oct 07 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Oct 08 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Tue Oct 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Wed Oct 12 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="7">
		  <div class="position">
		    <div class="hidden">7</div>
		    <div class="measure opacity20" id="Thu Oct 13 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Fri Oct 14 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Sat Oct 15 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Sun Oct 16 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Mon Oct 17 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="5">
		  <div class="position">
		    <div class="hidden">5</div>
		    <div class="measure opacity20" id="Tue Oct 18 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Oct 19 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Fri Oct 21 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Oct 22 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Sun Oct 23 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Mon Oct 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="6">
		  <div class="position">
		    <div class="hidden">6</div>
		    <div class="measure opacity20" id="Tue Oct 25 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="5">
		  <div class="position">
		    <div class="hidden">5</div>
		    <div class="measure opacity20" id="Wed Oct 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Oct 27 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="6">
		  <div class="position">
		    <div class="hidden">6</div>
		    <div class="measure opacity20" id="Fri Oct 28 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Sat Oct 29 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Sun Oct 30 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Mon Oct 31 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-10">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Tue Nov 01 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Wed Nov 02 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Nov 03 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="6">
		  <div class="position">
		    <div class="hidden">6</div>
		    <div class="measure opacity20" id="Fri Nov 04 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Sat Nov 05 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Sun Nov 06 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Mon Nov 07 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Tue Nov 08 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Wed Nov 09 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Thu Nov 10 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Fri Nov 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Sat Nov 12 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Sun Nov 13 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Tue Nov 15 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Thu Nov 17 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Nov 18 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Sat Nov 19 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"></div></td>
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Nov 23 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="7">
		  <div class="position">
		    <div class="hidden">7</div>
		    <div class="measure opacity20" id="Thu Nov 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="7">
		  <div class="position">
		    <div class="hidden">7</div>
		    <div class="measure opacity20" id="Fri Nov 25 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="8">
		  <div class="position">
		    <div class="hidden">8</div>
		    <div class="measure opacity20" id="Sat Nov 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Sun Nov 27 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="7">
		  <div class="position">
		    <div class="hidden">7</div>
		    <div class="measure opacity20" id="Mon Nov 28 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Tue Nov 29 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Wed Nov 30 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-11">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label"></span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Thu Dec 01 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Fri Dec 02 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Sat Dec 03 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Sun Dec 04 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Mon Dec 05 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Tue Dec 06 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Dec 07 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Thu Dec 08 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="1">
		  <div class="position">
		    <div class="hidden">1</div>
		    <div class="measure opacity20" id="Fri Dec 09 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="5">
		  <div class="position">
		    <div class="hidden">5</div>
		    <div class="measure opacity20" id="Sat Dec 10 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Sun Dec 11 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="9">
		  <div class="position">
		    <div class="hidden">9</div>
		    <div class="measure opacity20" id="Mon Dec 12 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Tue Dec 13 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Wed Dec 14 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="6">
		  <div class="position">
		    <div class="hidden">6</div>
		    <div class="measure opacity20" id="Thu Dec 15 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Fri Dec 16 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="5">
		  <div class="position">
		    <div class="hidden">5</div>
		    <div class="measure opacity20" id="Sat Dec 17 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Sun Dec 18 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="4">
		  <div class="position">
		    <div class="hidden">4</div>
		    <div class="measure opacity20" id="Mon Dec 19 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Tue Dec 20 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Wed Dec 21 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Thu Dec 22 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Fri Dec 23 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="2">
		  <div class="position">
		    <div class="hidden">2</div>
		    <div class="measure opacity20" id="Sat Dec 24 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="6">
		  <div class="position">
		    <div class="hidden">6</div>
		    <div class="measure opacity20" id="Sun Dec 25 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="5">
		  <div class="position">
		    <div class="hidden">5</div>
		    <div class="measure opacity20" id="Mon Dec 26 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="5">
		  <div class="position">
		    <div class="hidden">5</div>
		    <div class="measure opacity20" id="Tue Dec 27 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Wed Dec 28 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Thu Dec 29 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Fri Dec 30 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      
	      <td>
		<div class="date" count="3">
		  <div class="position">
		    <div class="hidden">3</div>
		    <div class="measure opacity20" id="Sat Dec 31 00:00:00 UTC 2005"><img width="100%" height="100%"/></div>
		  </div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
  </div>
  <div id="calOver" class="calPosition">
  
    
    <div class="month" id="2005-0">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Sat Jan 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Jan 01 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Jan 02 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Jan 03 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Jan 04 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Jan 05 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Thu Jan 06 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Jan 07 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Jan 08 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Jan 09 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Jan 10 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050110084732/http://yahoo.com/">Mon Jan 10 08:47:32 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050110084732/http://yahoo.com/" title="1 snapshots" class="Mon Jan 10 00:00:00 UTC 2005">Mon Jan 10 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Jan 11 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050111085125/http://www.yahoo.com/">Tue Jan 11 08:51:25 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050111131408/http://yahoo.com">Tue Jan 11 13:14:08 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050111085125/http://www.yahoo.com/" title="2 snapshots" class="Tue Jan 11 00:00:00 UTC 2005">Tue Jan 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Jan 12 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050112132622/http://www.yahoo.com">Wed Jan 12 13:26:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050112190601/http://www.yahoo.com/">Wed Jan 12 19:06:01 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050112132622/http://www.yahoo.com" title="2 snapshots" class="Wed Jan 12 00:00:00 UTC 2005">Wed Jan 12 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Thu Jan 13 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Jan 14 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050114200308/http://www.yahoo.com/">Fri Jan 14 20:03:08 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050114200308/http://www.yahoo.com/" title="1 snapshots" class="Fri Jan 14 00:00:00 UTC 2005">Fri Jan 14 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Jan 15 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Jan 16 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050116090105/http://www.yahoo.com">Sun Jan 16 09:01:05 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050116090105/http://www.yahoo.com" title="1 snapshots" class="Sun Jan 16 00:00:00 UTC 2005">Sun Jan 16 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Jan 17 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050117201006/http://www.yahoo.com/">Mon Jan 17 20:10:06 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050117201006/http://www.yahoo.com/" title="1 snapshots" class="Mon Jan 17 00:00:00 UTC 2005">Mon Jan 17 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Jan 18 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Jan 19 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050119052420/http://yahoo.com/">Wed Jan 19 05:24:20 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050119120934/http://yahoo.com">Wed Jan 19 12:09:34 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050119221800/http://www.yahoo.com/">Wed Jan 19 22:18:00 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050119052420/http://yahoo.com/" title="3 snapshots" class="Wed Jan 19 00:00:00 UTC 2005">Wed Jan 19 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Thu Jan 20 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Jan 21 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Jan 22 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050122210045/http://www.yahoo.com">Sat Jan 22 21:00:45 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050122210045/http://www.yahoo.com" title="1 snapshots" class="Sat Jan 22 00:00:00 UTC 2005">Sat Jan 22 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Jan 23 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050123033527/http://www.yahoo.com/">Sun Jan 23 03:35:27 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050123033527/http://www.yahoo.com/" title="1 snapshots" class="Sun Jan 23 00:00:00 UTC 2005">Sun Jan 23 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Jan 24 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050124085007/http://yahoo.com/">Mon Jan 24 08:50:07 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050124085007/http://yahoo.com/" title="1 snapshots" class="Mon Jan 24 00:00:00 UTC 2005">Mon Jan 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Jan 25 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Jan 26 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050126034029/http://www.yahoo.com/">Wed Jan 26 03:40:29 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050126080057/http://www.yahoo.com/">Wed Jan 26 08:00:57 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050126201220/http://www.yahoo.com">Wed Jan 26 20:12:20 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050126034029/http://www.yahoo.com/" title="3 snapshots" class="Wed Jan 26 00:00:00 UTC 2005">Wed Jan 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Thu Jan 27 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Jan 28 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Jan 29 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Jan 30 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050130013612/http://yahoo.com">Sun Jan 30 01:36:12 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050130013612/http://yahoo.com" title="1 snapshots" class="Sun Jan 30 00:00:00 UTC 2005">Sun Jan 30 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Jan 31 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-1">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Tue Feb 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Feb 01 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Feb 02 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050202185600/http://www.yahoo.com/">Wed Feb 02 18:56:00 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050202230038/http://www12.yahoo.com/">Wed Feb 02 23:00:38 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050202185600/http://www.yahoo.com/" title="2 snapshots" class="Wed Feb 02 00:00:00 UTC 2005">Wed Feb 02 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Feb 03 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050203003132/http://www.yahoo.com/">Thu Feb 03 00:31:32 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050203025839/http://www.yahoo.com/">Thu Feb 03 02:58:39 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050203103817/http://www11.yahoo.com/">Thu Feb 03 10:38:17 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050203232614/http://www7.yahoo.com/">Thu Feb 03 23:26:14 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050203003132/http://www.yahoo.com/" title="4 snapshots" class="Thu Feb 03 00:00:00 UTC 2005">Thu Feb 03 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Feb 04 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050204005735/http://www5.yahoo.com/">Fri Feb 04 00:57:35 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050204173228/http://www8.yahoo.com/">Fri Feb 04 17:32:28 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050204005735/http://www5.yahoo.com/" title="2 snapshots" class="Fri Feb 04 00:00:00 UTC 2005">Fri Feb 04 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Feb 05 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050205092651/http://www.yahoo.com/">Sat Feb 05 09:26:51 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050205092651/http://www.yahoo.com/" title="1 snapshots" class="Sat Feb 05 00:00:00 UTC 2005">Sat Feb 05 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Feb 06 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050206095052/http://www.yahoo.com/">Sun Feb 06 09:50:52 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050206183952/http://www4.yahoo.com/">Sun Feb 06 18:39:52 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050206095052/http://www.yahoo.com/" title="2 snapshots" class="Sun Feb 06 00:00:00 UTC 2005">Sun Feb 06 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Feb 07 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050207000305/http://www3.yahoo.com/">Mon Feb 07 00:03:05 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050207054308/http://yahoo.com/">Mon Feb 07 05:43:08 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050207083327/http://www.yahoo.com/">Mon Feb 07 08:33:27 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050207000305/http://www3.yahoo.com/" title="3 snapshots" class="Mon Feb 07 00:00:00 UTC 2005">Mon Feb 07 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Feb 08 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050208014043/http://yahoo.com/">Tue Feb 08 01:40:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050208184153/http://www.yahoo.com/">Tue Feb 08 18:41:53 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050208194543/http://yahoo.com/">Tue Feb 08 19:45:43 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050208014043/http://yahoo.com/" title="3 snapshots" class="Tue Feb 08 00:00:00 UTC 2005">Tue Feb 08 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Feb 09 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050209063853/http://www4.yahoo.com/">Wed Feb 09 06:38:53 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050209063853/http://www4.yahoo.com/" title="1 snapshots" class="Wed Feb 09 00:00:00 UTC 2005">Wed Feb 09 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Feb 10 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050210052916/http://www2.yahoo.com/">Thu Feb 10 05:29:16 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050210091441/http://www.yahoo.com/">Thu Feb 10 09:14:41 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050210100355/http://www5.yahoo.com/">Thu Feb 10 10:03:55 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050210230332/http://www.yahoo.com/">Thu Feb 10 23:03:32 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050210052916/http://www2.yahoo.com/" title="4 snapshots" class="Thu Feb 10 00:00:00 UTC 2005">Thu Feb 10 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Feb 11 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050211084820/http://www.yahoo.com/">Fri Feb 11 08:48:20 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050211092016/http://www.yahoo.com/">Fri Feb 11 09:20:16 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050211084820/http://www.yahoo.com/" title="2 snapshots" class="Fri Feb 11 00:00:00 UTC 2005">Fri Feb 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Feb 12 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050212043520/http://www4.yahoo.com/">Sat Feb 12 04:35:20 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050212083919/http://www.yahoo.com/">Sat Feb 12 08:39:19 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050212221001/http://www10.yahoo.com/">Sat Feb 12 22:10:01 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050212043520/http://www4.yahoo.com/" title="3 snapshots" class="Sat Feb 12 00:00:00 UTC 2005">Sat Feb 12 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Feb 13 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050213090923/http://www.yahoo.com/">Sun Feb 13 09:09:23 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050213090923/http://www.yahoo.com/" title="1 snapshots" class="Sun Feb 13 00:00:00 UTC 2005">Sun Feb 13 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Feb 14 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050214022031/http://yahoo.com/">Mon Feb 14 02:20:31 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050214091553/http://www.yahoo.com/">Mon Feb 14 09:15:53 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050214211214/http://www.yahoo.com/">Mon Feb 14 21:12:14 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050214022031/http://yahoo.com/" title="3 snapshots" class="Mon Feb 14 00:00:00 UTC 2005">Mon Feb 14 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Feb 15 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050215010043/http://yahoo.com/">Tue Feb 15 01:00:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050215175524/http://www.yahoo.com">Tue Feb 15 17:55:24 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050215010043/http://yahoo.com/" title="2 snapshots" class="Tue Feb 15 00:00:00 UTC 2005">Tue Feb 15 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Feb 16 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Feb 17 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050217091427/http://www.yahoo.com/">Thu Feb 17 09:14:27 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050217091427/http://www.yahoo.com/" title="1 snapshots" class="Thu Feb 17 00:00:00 UTC 2005">Thu Feb 17 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Feb 18 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050218124941/http://www.yahoo.com">Fri Feb 18 12:49:41 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050218124941/http://www.yahoo.com" title="1 snapshots" class="Fri Feb 18 00:00:00 UTC 2005">Fri Feb 18 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Feb 19 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050219095215/http://www.yahoo.com/">Sat Feb 19 09:52:15 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050219095215/http://www.yahoo.com/" title="1 snapshots" class="Sat Feb 19 00:00:00 UTC 2005">Sat Feb 19 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Feb 20 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Feb 21 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Feb 22 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050222092959/http://www.yahoo.com/">Tue Feb 22 09:29:59 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050222231901/http://www.yahoo.com/">Tue Feb 22 23:19:01 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050222092959/http://www.yahoo.com/" title="2 snapshots" class="Tue Feb 22 00:00:00 UTC 2005">Tue Feb 22 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Feb 23 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Feb 24 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050224024726/http://www.yahoo.com/">Thu Feb 24 02:47:26 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050224090216/http://www.yahoo.com/">Thu Feb 24 09:02:16 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050224024726/http://www.yahoo.com/" title="2 snapshots" class="Thu Feb 24 00:00:00 UTC 2005">Thu Feb 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Feb 25 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Feb 26 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Feb 27 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Feb 28 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050228093543/http://www.yahoo.com/">Mon Feb 28 09:35:43 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050228093543/http://www.yahoo.com/" title="1 snapshots" class="Mon Feb 28 00:00:00 UTC 2005">Mon Feb 28 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-2">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Tue Mar 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Mar 01 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050301072338/http://www.yahoo.com/">Tue Mar 01 07:23:38 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050301085030/http://www.yahoo.com/">Tue Mar 01 08:50:30 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050301194357/http://www.yahoo.com/">Tue Mar 01 19:43:57 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050301072338/http://www.yahoo.com/" title="3 snapshots" class="Tue Mar 01 00:00:00 UTC 2005">Tue Mar 01 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Mar 02 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050302090818/http://www.yahoo.com/">Wed Mar 02 09:08:18 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050302233912/http://www.yahoo.com/">Wed Mar 02 23:39:12 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050302090818/http://www.yahoo.com/" title="2 snapshots" class="Wed Mar 02 00:00:00 UTC 2005">Wed Mar 02 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Thu Mar 03 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Mar 04 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050304043630/http://www.yahoo.com/">Fri Mar 04 04:36:30 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050304043630/http://www.yahoo.com/" title="1 snapshots" class="Fri Mar 04 00:00:00 UTC 2005">Fri Mar 04 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Mar 05 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Mar 06 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Mar 07 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050307033256/http://yahoo.com/">Mon Mar 07 03:32:56 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050307191745/http://www.yahoo.com/">Mon Mar 07 19:17:45 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050307212714/http://yahoo.com">Mon Mar 07 21:27:14 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050307033256/http://yahoo.com/" title="3 snapshots" class="Mon Mar 07 00:00:00 UTC 2005">Mon Mar 07 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Mar 08 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Mar 09 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Thu Mar 10 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Mar 11 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050311092607/http://www.yahoo.com/">Fri Mar 11 09:26:07 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050311092607/http://www.yahoo.com/" title="1 snapshots" class="Fri Mar 11 00:00:00 UTC 2005">Fri Mar 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Mar 12 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050312093838/http://www.yahoo.com/">Sat Mar 12 09:38:38 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050312093838/http://www.yahoo.com/" title="1 snapshots" class="Sat Mar 12 00:00:00 UTC 2005">Sat Mar 12 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Mar 13 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Mar 14 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Mar 15 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050315200428/http://www.yahoo.com/">Tue Mar 15 20:04:28 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050315200428/http://www.yahoo.com/" title="1 snapshots" class="Tue Mar 15 00:00:00 UTC 2005">Tue Mar 15 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Mar 16 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050316094712/http://www.yahoo.com/">Wed Mar 16 09:47:12 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050316094712/http://www.yahoo.com/" title="1 snapshots" class="Wed Mar 16 00:00:00 UTC 2005">Wed Mar 16 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Mar 17 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050317093916/http://www.yahoo.com/">Thu Mar 17 09:39:16 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050317093916/http://www.yahoo.com/" title="1 snapshots" class="Thu Mar 17 00:00:00 UTC 2005">Thu Mar 17 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Mar 18 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Mar 19 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Mar 20 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Mar 21 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050321021705/http://www.yahoo.com/">Mon Mar 21 02:17:05 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050321101746/http://www.yahoo.com/">Mon Mar 21 10:17:46 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050321021705/http://www.yahoo.com/" title="2 snapshots" class="Mon Mar 21 00:00:00 UTC 2005">Mon Mar 21 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Mar 22 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050322085234/http://yahoo.com/">Tue Mar 22 08:52:34 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050322092952/http://www.yahoo.com/">Tue Mar 22 09:29:52 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050322085234/http://yahoo.com/" title="2 snapshots" class="Tue Mar 22 00:00:00 UTC 2005">Tue Mar 22 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Mar 23 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050323094706/http://www.yahoo.com/">Wed Mar 23 09:47:06 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050323134828/http://www.yahoo.com/">Wed Mar 23 13:48:28 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050323094706/http://www.yahoo.com/" title="2 snapshots" class="Wed Mar 23 00:00:00 UTC 2005">Wed Mar 23 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Mar 24 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050324094447/http://www.yahoo.com/">Thu Mar 24 09:44:47 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050324094447/http://www.yahoo.com/" title="1 snapshots" class="Thu Mar 24 00:00:00 UTC 2005">Thu Mar 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Mar 25 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Mar 26 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050326094522/http://www.yahoo.com/">Sat Mar 26 09:45:22 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050326094522/http://www.yahoo.com/" title="1 snapshots" class="Sat Mar 26 00:00:00 UTC 2005">Sat Mar 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Mar 27 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Mar 28 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050328085519/http://www.yahoo.com/">Mon Mar 28 08:55:19 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050328203753/http://www.yahoo.com/">Mon Mar 28 20:37:53 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050328085519/http://www.yahoo.com/" title="2 snapshots" class="Mon Mar 28 00:00:00 UTC 2005">Mon Mar 28 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Mar 29 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050329042245/http://www.yahoo.com/">Tue Mar 29 04:22:45 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050329042245/http://www.yahoo.com/" title="1 snapshots" class="Tue Mar 29 00:00:00 UTC 2005">Tue Mar 29 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Mar 30 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050330201519/http://www.yahoo.com/">Wed Mar 30 20:15:19 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050330201519/http://www.yahoo.com/" title="1 snapshots" class="Wed Mar 30 00:00:00 UTC 2005">Wed Mar 30 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Thu Mar 31 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-3">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Fri Apr 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Apr 01 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050401084551/http://www.yahoo.com/">Fri Apr 01 08:45:51 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050401084551/http://www.yahoo.com/" title="1 snapshots" class="Fri Apr 01 00:00:00 UTC 2005">Fri Apr 01 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Apr 02 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Apr 03 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Apr 04 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Apr 05 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Apr 06 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Apr 07 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050407111526/http://www.yahoo.com">Thu Apr 07 11:15:26 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050407111526/http://www.yahoo.com" title="1 snapshots" class="Thu Apr 07 00:00:00 UTC 2005">Thu Apr 07 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Apr 08 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050408054747/http://yahoo.com">Fri Apr 08 05:47:47 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050408084421/http://www.yahoo.com/">Fri Apr 08 08:44:21 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050408054747/http://yahoo.com" title="2 snapshots" class="Fri Apr 08 00:00:00 UTC 2005">Fri Apr 08 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Apr 09 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Apr 10 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Apr 11 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050411082419/http://www.yahoo.com/">Mon Apr 11 08:24:19 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050411210442/http://www.yahoo.com">Mon Apr 11 21:04:42 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050411082419/http://www.yahoo.com/" title="2 snapshots" class="Mon Apr 11 00:00:00 UTC 2005">Mon Apr 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Apr 12 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Apr 13 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050413075400/http://www.yahoo.com/">Wed Apr 13 07:54:00 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050413083504/http://www.yahoo.com/">Wed Apr 13 08:35:04 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050413075400/http://www.yahoo.com/" title="2 snapshots" class="Wed Apr 13 00:00:00 UTC 2005">Wed Apr 13 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Apr 14 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050414073649/http://www.yahoo.com/">Thu Apr 14 07:36:49 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050414073649/http://www.yahoo.com/" title="1 snapshots" class="Thu Apr 14 00:00:00 UTC 2005">Thu Apr 14 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Apr 15 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050415075552/http://www.yahoo.com/">Fri Apr 15 07:55:52 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050415075552/http://www.yahoo.com/" title="1 snapshots" class="Fri Apr 15 00:00:00 UTC 2005">Fri Apr 15 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Apr 16 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Apr 17 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050417070927/http://www.yahoo.com/">Sun Apr 17 07:09:27 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050417070927/http://www.yahoo.com/" title="1 snapshots" class="Sun Apr 17 00:00:00 UTC 2005">Sun Apr 17 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Apr 18 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050418041857/http://yahoo.com/">Mon Apr 18 04:18:57 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050418162211/http://www.yahoo.com/">Mon Apr 18 16:22:11 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050418041857/http://yahoo.com/" title="2 snapshots" class="Mon Apr 18 00:00:00 UTC 2005">Mon Apr 18 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Apr 19 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Apr 20 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050420061638/http://www.yahoo.com/">Wed Apr 20 06:16:38 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050420083652/http://www.yahoo.com/">Wed Apr 20 08:36:52 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050420061638/http://www.yahoo.com/" title="2 snapshots" class="Wed Apr 20 00:00:00 UTC 2005">Wed Apr 20 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Apr 21 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050421083009/http://www.yahoo.com/">Thu Apr 21 08:30:09 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050421083009/http://www.yahoo.com/" title="1 snapshots" class="Thu Apr 21 00:00:00 UTC 2005">Thu Apr 21 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Apr 22 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050422002010/http://yahoo.com/">Fri Apr 22 00:20:10 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050422031958/http://www.yahoo.com/">Fri Apr 22 03:19:58 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050422082459/http://www.yahoo.com/">Fri Apr 22 08:24:59 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050422002010/http://yahoo.com/" title="3 snapshots" class="Fri Apr 22 00:00:00 UTC 2005">Fri Apr 22 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Apr 23 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Apr 24 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050424084143/http://www.yahoo.com/">Sun Apr 24 08:41:43 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050424084143/http://www.yahoo.com/" title="1 snapshots" class="Sun Apr 24 00:00:00 UTC 2005">Sun Apr 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Apr 25 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Apr 26 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050426103727/http://www.yahoo.com/">Tue Apr 26 10:37:27 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050426103727/http://www.yahoo.com/" title="1 snapshots" class="Tue Apr 26 00:00:00 UTC 2005">Tue Apr 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Apr 27 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050427084732/http://www.yahoo.com/">Wed Apr 27 08:47:32 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050427104422/http://www.yahoo.com/">Wed Apr 27 10:44:22 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050427084732/http://www.yahoo.com/" title="2 snapshots" class="Wed Apr 27 00:00:00 UTC 2005">Wed Apr 27 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Apr 28 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050428090005/http://www.yahoo.com/">Thu Apr 28 09:00:05 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050428090005/http://www.yahoo.com/" title="1 snapshots" class="Thu Apr 28 00:00:00 UTC 2005">Thu Apr 28 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Apr 29 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Apr 30 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-4">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Sun May 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun May 01 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon May 02 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050502230708/http://www.yahoo.com/">Mon May 02 23:07:08 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050502230708/http://www.yahoo.com/" title="1 snapshots" class="Mon May 02 00:00:00 UTC 2005">Mon May 02 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue May 03 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed May 04 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu May 05 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050505202618/http://yahoo.com">Thu May 05 20:26:18 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050505202618/http://yahoo.com" title="1 snapshots" class="Thu May 05 00:00:00 UTC 2005">Thu May 05 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri May 06 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat May 07 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050507142929/http://yahoo.com/">Sat May 07 14:29:29 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050507142929/http://yahoo.com/" title="1 snapshots" class="Sat May 07 00:00:00 UTC 2005">Sat May 07 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun May 08 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon May 09 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050509084300/http://www.yahoo.com/">Mon May 09 08:43:00 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050509084300/http://www.yahoo.com/" title="1 snapshots" class="Mon May 09 00:00:00 UTC 2005">Mon May 09 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue May 10 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed May 11 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050511090054/http://www.yahoo.com/">Wed May 11 09:00:54 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050511090054/http://www.yahoo.com/" title="1 snapshots" class="Wed May 11 00:00:00 UTC 2005">Wed May 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu May 12 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050512081421/http://www.yahoo.com/">Thu May 12 08:14:21 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050512081421/http://www.yahoo.com/" title="1 snapshots" class="Thu May 12 00:00:00 UTC 2005">Thu May 12 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri May 13 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat May 14 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050514074451/http://www.yahoo.com/">Sat May 14 07:44:51 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050514074451/http://www.yahoo.com/" title="1 snapshots" class="Sat May 14 00:00:00 UTC 2005">Sat May 14 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun May 15 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon May 16 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050516003153/http://yahoo.com/">Mon May 16 00:31:53 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050516075820/http://www.yahoo.com/">Mon May 16 07:58:20 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050516231905/http://yahoo.com/">Mon May 16 23:19:05 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050516003153/http://yahoo.com/" title="3 snapshots" class="Mon May 16 00:00:00 UTC 2005">Mon May 16 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue May 17 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed May 18 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050518075308/http://yahoo.com/">Wed May 18 07:53:08 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050518080245/http://www.yahoo.com/">Wed May 18 08:02:45 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050518075308/http://yahoo.com/" title="2 snapshots" class="Wed May 18 00:00:00 UTC 2005">Wed May 18 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu May 19 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050519063323/http://www.yahoo.com/">Thu May 19 06:33:23 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050519063323/http://www.yahoo.com/" title="1 snapshots" class="Thu May 19 00:00:00 UTC 2005">Thu May 19 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri May 20 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050520083331/http://www.yahoo.com/">Fri May 20 08:33:31 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050520083331/http://www.yahoo.com/" title="1 snapshots" class="Fri May 20 00:00:00 UTC 2005">Fri May 20 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat May 21 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun May 22 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050522075254/http://yahoo.com/">Sun May 22 07:52:54 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050522075254/http://yahoo.com/" title="1 snapshots" class="Sun May 22 00:00:00 UTC 2005">Sun May 22 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon May 23 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue May 24 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050524081052/http://www.yahoo.com/">Tue May 24 08:10:52 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050524081052/http://www.yahoo.com/" title="1 snapshots" class="Tue May 24 00:00:00 UTC 2005">Tue May 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed May 25 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050525075423/http://yahoo.com/">Wed May 25 07:54:23 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050525081125/http://www.yahoo.com/">Wed May 25 08:11:25 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050525143411/http://www.yahoo.com">Wed May 25 14:34:11 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050525075423/http://yahoo.com/" title="3 snapshots" class="Wed May 25 00:00:00 UTC 2005">Wed May 25 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu May 26 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050526032652/http://www.yahoo.com/">Thu May 26 03:26:52 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050526075257/http://www.yahoo.com/">Thu May 26 07:52:57 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050526032652/http://www.yahoo.com/" title="2 snapshots" class="Thu May 26 00:00:00 UTC 2005">Thu May 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri May 27 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050527015817/http://yahoo.com/">Fri May 27 01:58:17 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050527202006/http://www.yahoo.com/">Fri May 27 20:20:06 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050527230510/http://www.yahoo.com/">Fri May 27 23:05:10 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050527015817/http://yahoo.com/" title="3 snapshots" class="Fri May 27 00:00:00 UTC 2005">Fri May 27 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat May 28 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun May 29 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon May 30 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue May 31 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-5">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Wed Jun 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Jun 01 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Jun 02 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050602041622/http://www.yahoo.com/">Thu Jun 02 04:16:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050602080210/http://www.yahoo.com/">Thu Jun 02 08:02:10 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050602041622/http://www.yahoo.com/" title="2 snapshots" class="Thu Jun 02 00:00:00 UTC 2005">Thu Jun 02 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Jun 03 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Jun 04 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050604081210/http://www.yahoo.com/">Sat Jun 04 08:12:10 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050604081210/http://www.yahoo.com/" title="1 snapshots" class="Sat Jun 04 00:00:00 UTC 2005">Sat Jun 04 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Jun 05 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050605020019/http://yahoo.com/">Sun Jun 05 02:00:19 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050605020019/http://yahoo.com/" title="1 snapshots" class="Sun Jun 05 00:00:00 UTC 2005">Sun Jun 05 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Jun 06 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050606220013/http://yahoo.com/">Mon Jun 06 22:00:13 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050606220013/http://yahoo.com/" title="1 snapshots" class="Mon Jun 06 00:00:00 UTC 2005">Mon Jun 06 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Jun 07 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050607011802/http://www.yahoo.com/">Tue Jun 07 01:18:02 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050607011802/http://www.yahoo.com/" title="1 snapshots" class="Tue Jun 07 00:00:00 UTC 2005">Tue Jun 07 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Jun 08 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050608085140/http://www.yahoo.com/">Wed Jun 08 08:51:40 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050608085140/http://www.yahoo.com/" title="1 snapshots" class="Wed Jun 08 00:00:00 UTC 2005">Wed Jun 08 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Jun 09 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050609001217/http://www.yahoo.com/">Thu Jun 09 00:12:17 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050609001217/http://www.yahoo.com/" title="1 snapshots" class="Thu Jun 09 00:00:00 UTC 2005">Thu Jun 09 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Jun 10 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050610005631/http://www.yahoo.com/">Fri Jun 10 00:56:31 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050610005631/http://www.yahoo.com/" title="1 snapshots" class="Fri Jun 10 00:00:00 UTC 2005">Fri Jun 10 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Jun 11 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050611000102/http://www.yahoo.com/">Sat Jun 11 00:01:02 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050611083427/http://www.yahoo.com/">Sat Jun 11 08:34:27 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050611000102/http://www.yahoo.com/" title="2 snapshots" class="Sat Jun 11 00:00:00 UTC 2005">Sat Jun 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Jun 12 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Jun 13 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050613002310/http://www.yahoo.com/">Mon Jun 13 00:23:10 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050613081436/http://www.yahoo.com/">Mon Jun 13 08:14:36 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050613002310/http://www.yahoo.com/" title="2 snapshots" class="Mon Jun 13 00:00:00 UTC 2005">Mon Jun 13 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Jun 14 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Jun 15 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050615130515/http://www.yahoo.com/">Wed Jun 15 13:05:15 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050615130515/http://www.yahoo.com/" title="1 snapshots" class="Wed Jun 15 00:00:00 UTC 2005">Wed Jun 15 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Jun 16 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050616074345/http://www.yahoo.com/">Thu Jun 16 07:43:45 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050616111951/http://www.yahoo.com/">Thu Jun 16 11:19:51 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050616074345/http://www.yahoo.com/" title="2 snapshots" class="Thu Jun 16 00:00:00 UTC 2005">Thu Jun 16 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Jun 17 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Jun 18 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Jun 19 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050619235424/http://yahoo.com/">Sun Jun 19 23:54:24 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050619235424/http://yahoo.com/" title="1 snapshots" class="Sun Jun 19 00:00:00 UTC 2005">Sun Jun 19 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Jun 20 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050620084145/http://www.yahoo.com/">Mon Jun 20 08:41:45 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050620084145/http://www.yahoo.com/" title="1 snapshots" class="Mon Jun 20 00:00:00 UTC 2005">Mon Jun 20 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Jun 21 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050621080835/http://www.yahoo.com/">Tue Jun 21 08:08:35 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050621080835/http://www.yahoo.com/" title="1 snapshots" class="Tue Jun 21 00:00:00 UTC 2005">Tue Jun 21 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Jun 22 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050622050236/http://www.yahoo.com">Wed Jun 22 05:02:36 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050622050236/http://www.yahoo.com" title="1 snapshots" class="Wed Jun 22 00:00:00 UTC 2005">Wed Jun 22 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Jun 23 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050623084428/http://www.yahoo.com/">Thu Jun 23 08:44:28 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050623223100/http://www.yahoo.com/">Thu Jun 23 22:31:00 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050623084428/http://www.yahoo.com/" title="2 snapshots" class="Thu Jun 23 00:00:00 UTC 2005">Thu Jun 23 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Jun 24 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050624133054/http://yahoo.com">Fri Jun 24 13:30:54 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050624133054/http://yahoo.com" title="1 snapshots" class="Fri Jun 24 00:00:00 UTC 2005">Fri Jun 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Jun 25 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050625053654/http://www.yahoo.com/">Sat Jun 25 05:36:54 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050625053654/http://www.yahoo.com/" title="1 snapshots" class="Sat Jun 25 00:00:00 UTC 2005">Sat Jun 25 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Jun 26 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050626080519/http://www.yahoo.com/">Sun Jun 26 08:05:19 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050626080519/http://www.yahoo.com/" title="1 snapshots" class="Sun Jun 26 00:00:00 UTC 2005">Sun Jun 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Jun 27 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Jun 28 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050628010801/http://yahoo.com/">Tue Jun 28 01:08:01 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050628083018/http://www.yahoo.com/">Tue Jun 28 08:30:18 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050628010801/http://yahoo.com/" title="2 snapshots" class="Tue Jun 28 00:00:00 UTC 2005">Tue Jun 28 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Jun 29 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Jun 30 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050630030117/http://www.yahoo.com/">Thu Jun 30 03:01:17 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050630084522/http://www.yahoo.com/">Thu Jun 30 08:45:22 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050630030117/http://www.yahoo.com/" title="2 snapshots" class="Thu Jun 30 00:00:00 UTC 2005">Thu Jun 30 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-6">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Fri Jul 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Jul 01 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Jul 02 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050702074908/http://www.yahoo.com/">Sat Jul 02 07:49:08 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050702074908/http://www.yahoo.com/" title="1 snapshots" class="Sat Jul 02 00:00:00 UTC 2005">Sat Jul 02 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Jul 03 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050703083156/http://www.yahoo.com/">Sun Jul 03 08:31:56 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050703083156/http://www.yahoo.com/" title="1 snapshots" class="Sun Jul 03 00:00:00 UTC 2005">Sun Jul 03 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Jul 04 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050704074926/http://www.yahoo.com/">Mon Jul 04 07:49:26 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050704074926/http://www.yahoo.com/" title="1 snapshots" class="Mon Jul 04 00:00:00 UTC 2005">Mon Jul 04 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Jul 05 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Jul 06 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050706055743/http://yahoo.com/">Wed Jul 06 05:57:43 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050706055743/http://yahoo.com/" title="1 snapshots" class="Wed Jul 06 00:00:00 UTC 2005">Wed Jul 06 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Jul 07 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050707062222/http://www.yahoo.com">Thu Jul 07 06:22:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050707080828/http://www.yahoo.com/">Thu Jul 07 08:08:28 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050707212904/http://www.yahoo.com/">Thu Jul 07 21:29:04 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050707062222/http://www.yahoo.com" title="3 snapshots" class="Thu Jul 07 00:00:00 UTC 2005">Thu Jul 07 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Jul 08 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050708090349/http://www.yahoo.com/">Fri Jul 08 09:03:49 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050708090349/http://www.yahoo.com/" title="1 snapshots" class="Fri Jul 08 00:00:00 UTC 2005">Fri Jul 08 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Jul 09 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Jul 10 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050710080020/http://www.yahoo.com/">Sun Jul 10 08:00:20 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050710080020/http://www.yahoo.com/" title="1 snapshots" class="Sun Jul 10 00:00:00 UTC 2005">Sun Jul 10 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Jul 11 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050711091819/http://www.yahoo.com">Mon Jul 11 09:18:19 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050711091819/http://www.yahoo.com" title="1 snapshots" class="Mon Jul 11 00:00:00 UTC 2005">Mon Jul 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Jul 12 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Jul 13 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050713062554/http://www.yahoo.com">Wed Jul 13 06:25:54 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050713062554/http://www.yahoo.com" title="1 snapshots" class="Wed Jul 13 00:00:00 UTC 2005">Wed Jul 13 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Jul 14 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050714084729/http://www.yahoo.com/">Thu Jul 14 08:47:29 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050714124211/http://www.yahoo.com/">Thu Jul 14 12:42:11 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050714084729/http://www.yahoo.com/" title="2 snapshots" class="Thu Jul 14 00:00:00 UTC 2005">Thu Jul 14 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Jul 15 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Jul 16 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Jul 17 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Jul 18 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050718081700/http://www.yahoo.com/">Mon Jul 18 08:17:00 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050718232608/http://yahoo.com/">Mon Jul 18 23:26:08 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050718081700/http://www.yahoo.com/" title="2 snapshots" class="Mon Jul 18 00:00:00 UTC 2005">Mon Jul 18 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Jul 19 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050719081807/http://www.yahoo.com/">Tue Jul 19 08:18:07 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050719081807/http://www.yahoo.com/" title="1 snapshots" class="Tue Jul 19 00:00:00 UTC 2005">Tue Jul 19 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Jul 20 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Jul 21 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050721235141/http://www.yahoo.com/">Thu Jul 21 23:51:41 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050721235141/http://www.yahoo.com/" title="1 snapshots" class="Thu Jul 21 00:00:00 UTC 2005">Thu Jul 21 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Jul 22 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Jul 23 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Jul 24 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050724181249/http://www.yahoo.com/">Sun Jul 24 18:12:49 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050724190432/http://www.yahoo.com/">Sun Jul 24 19:04:32 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050724181249/http://www.yahoo.com/" title="2 snapshots" class="Sun Jul 24 00:00:00 UTC 2005">Sun Jul 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Jul 25 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Jul 26 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050726003356/http://yahoo.com/">Tue Jul 26 00:33:56 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050726073543/http://www.yahoo.com/">Tue Jul 26 07:35:43 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050726003356/http://yahoo.com/" title="2 snapshots" class="Tue Jul 26 00:00:00 UTC 2005">Tue Jul 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Jul 27 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050727085348/http://www.yahoo.com">Wed Jul 27 08:53:48 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050727215821/http://www.yahoo.com/">Wed Jul 27 21:58:21 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050727085348/http://www.yahoo.com" title="2 snapshots" class="Wed Jul 27 00:00:00 UTC 2005">Wed Jul 27 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Jul 28 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050728012017/http://www.yahoo.com/">Thu Jul 28 01:20:17 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050728012017/http://www.yahoo.com/" title="1 snapshots" class="Thu Jul 28 00:00:00 UTC 2005">Thu Jul 28 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Jul 29 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050729225204/http://www.yahoo.com">Fri Jul 29 22:52:04 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050729225204/http://www.yahoo.com" title="1 snapshots" class="Fri Jul 29 00:00:00 UTC 2005">Fri Jul 29 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Jul 30 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Jul 31 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050731091526/http://www.yahoo.com/">Sun Jul 31 09:15:26 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050731091526/http://www.yahoo.com/" title="1 snapshots" class="Sun Jul 31 00:00:00 UTC 2005">Sun Jul 31 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-7">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Mon Aug 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Aug 01 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050801004224/http://yahoo.com/">Mon Aug 01 00:42:24 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050801004224/http://yahoo.com/" title="1 snapshots" class="Mon Aug 01 00:00:00 UTC 2005">Mon Aug 01 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Aug 02 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Aug 03 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Aug 04 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050804085628/http://www.yahoo.com/">Thu Aug 04 08:56:28 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050804204433/http://www.yahoo.com/">Thu Aug 04 20:44:33 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050804085628/http://www.yahoo.com/" title="2 snapshots" class="Thu Aug 04 00:00:00 UTC 2005">Thu Aug 04 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Aug 05 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Aug 06 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Aug 07 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Aug 08 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050808003019/http://yahoo.com/">Mon Aug 08 00:30:19 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050808080632/http://www.yahoo.com/">Mon Aug 08 08:06:32 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050808003019/http://yahoo.com/" title="2 snapshots" class="Mon Aug 08 00:00:00 UTC 2005">Mon Aug 08 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Aug 09 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050809013345/http://yahoo.com/">Tue Aug 09 01:33:45 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050809013345/http://yahoo.com/" title="1 snapshots" class="Tue Aug 09 00:00:00 UTC 2005">Tue Aug 09 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Aug 10 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050810162420/http://yahoo.com">Wed Aug 10 16:24:20 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050810162420/http://yahoo.com" title="1 snapshots" class="Wed Aug 10 00:00:00 UTC 2005">Wed Aug 10 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Aug 11 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050811005151/http://yahoo.com/">Thu Aug 11 00:51:51 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050811005151/http://yahoo.com/" title="1 snapshots" class="Thu Aug 11 00:00:00 UTC 2005">Thu Aug 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Aug 12 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050812020646/http://www.yahoo.com/">Fri Aug 12 02:06:46 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050812020646/http://www.yahoo.com/" title="1 snapshots" class="Fri Aug 12 00:00:00 UTC 2005">Fri Aug 12 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Aug 13 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050813004256/http://yahoo.com/">Sat Aug 13 00:42:56 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050813004256/http://yahoo.com/" title="1 snapshots" class="Sat Aug 13 00:00:00 UTC 2005">Sat Aug 13 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Aug 14 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Aug 15 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050815012043/http://yahoo.com/">Mon Aug 15 01:20:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050815073456/http://www.yahoo.com/">Mon Aug 15 07:34:56 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050815012043/http://yahoo.com/" title="2 snapshots" class="Mon Aug 15 00:00:00 UTC 2005">Mon Aug 15 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Aug 16 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Aug 17 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Thu Aug 18 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Aug 19 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Aug 20 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050820013359/http://www.yahoo.com/">Sat Aug 20 01:33:59 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050820013359/http://www.yahoo.com/" title="1 snapshots" class="Sat Aug 20 00:00:00 UTC 2005">Sat Aug 20 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Aug 21 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Aug 22 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050822072954/http://www.yahoo.com/">Mon Aug 22 07:29:54 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050822172130/http://www.yahoo.com/">Mon Aug 22 17:21:30 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050822072954/http://www.yahoo.com/" title="2 snapshots" class="Mon Aug 22 00:00:00 UTC 2005">Mon Aug 22 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Aug 23 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050823081539/http://www.yahoo.com/">Tue Aug 23 08:15:39 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050823081539/http://www.yahoo.com/" title="1 snapshots" class="Tue Aug 23 00:00:00 UTC 2005">Tue Aug 23 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Aug 24 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050824013415/http://www.yahoo.com/">Wed Aug 24 01:34:15 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050824181954/http://www.yahoo.com/">Wed Aug 24 18:19:54 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050824013415/http://www.yahoo.com/" title="2 snapshots" class="Wed Aug 24 00:00:00 UTC 2005">Wed Aug 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Aug 25 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050825142911/http://www.yahoo.com/">Thu Aug 25 14:29:11 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050825160443/http://www.yahoo.com/">Thu Aug 25 16:04:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050825203359/http://www.yahoo.com/">Thu Aug 25 20:33:59 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050825142911/http://www.yahoo.com/" title="3 snapshots" class="Thu Aug 25 00:00:00 UTC 2005">Thu Aug 25 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Aug 26 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050826094919/http://www.yahoo.com/">Fri Aug 26 09:49:19 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050826105626/http://www.yahoo.com/">Fri Aug 26 10:56:26 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050826152333/http://www.yahoo.com/">Fri Aug 26 15:23:33 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050826230526/http://www.yahoo.com/">Fri Aug 26 23:05:26 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050826094919/http://www.yahoo.com/" title="4 snapshots" class="Fri Aug 26 00:00:00 UTC 2005">Fri Aug 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Aug 27 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050827134659/http://www.yahoo.com/">Sat Aug 27 13:46:59 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050827134659/http://www.yahoo.com/" title="1 snapshots" class="Sat Aug 27 00:00:00 UTC 2005">Sat Aug 27 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Aug 28 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050828030923/http://www.yahoo.com/">Sun Aug 28 03:09:23 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050828030923/http://www.yahoo.com/" title="1 snapshots" class="Sun Aug 28 00:00:00 UTC 2005">Sun Aug 28 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Aug 29 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050829073247/http://www.yahoo.com/">Mon Aug 29 07:32:47 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050829193452/http://www.yahoo.com/">Mon Aug 29 19:34:52 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050829213126/http://www.yahoo.com/">Mon Aug 29 21:31:26 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050829235501/http://www.yahoo.com/">Mon Aug 29 23:55:01 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050829073247/http://www.yahoo.com/" title="4 snapshots" class="Mon Aug 29 00:00:00 UTC 2005">Mon Aug 29 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Aug 30 00:00:00 UTC 2005</h3>
		    <p>5 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050830012638/http://www.yahoo.com/">Tue Aug 30 01:26:38 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050830023354/http://www.yahoo.com/">Tue Aug 30 02:33:54 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050830050643/http://www.yahoo.com/">Tue Aug 30 05:06:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050830063212/http://www.yahoo.com">Tue Aug 30 06:32:12 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050830080325/http://www.yahoo.com/">Tue Aug 30 08:03:25 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050830012638/http://www.yahoo.com/" title="5 snapshots" class="Tue Aug 30 00:00:00 UTC 2005">Tue Aug 30 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Aug 31 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-8">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Thu Sep 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Sep 01 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050901074054/http://www.yahoo.com/">Thu Sep 01 07:40:54 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050901115253/http://www.yahoo.com/">Thu Sep 01 11:52:53 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050901074054/http://www.yahoo.com/" title="2 snapshots" class="Thu Sep 01 00:00:00 UTC 2005">Thu Sep 01 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Sep 02 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050902114934/http://www.yahoo.com">Fri Sep 02 11:49:34 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050902114934/http://www.yahoo.com" title="1 snapshots" class="Fri Sep 02 00:00:00 UTC 2005">Fri Sep 02 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sat Sep 03 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Sep 04 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050904044006/http://www.yahoo.com/">Sun Sep 04 04:40:06 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050904044006/http://www.yahoo.com/" title="1 snapshots" class="Sun Sep 04 00:00:00 UTC 2005">Sun Sep 04 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Sep 05 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050905000047/http://www.yahoo.com/">Mon Sep 05 00:00:47 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050905012041/http://www.yahoo.com/">Mon Sep 05 01:20:41 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050905074430/http://www.yahoo.com/">Mon Sep 05 07:44:30 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050905000047/http://www.yahoo.com/" title="3 snapshots" class="Mon Sep 05 00:00:00 UTC 2005">Mon Sep 05 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Sep 06 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050906215318/http://www.yahoo.com/">Tue Sep 06 21:53:18 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050906215318/http://www.yahoo.com/" title="1 snapshots" class="Tue Sep 06 00:00:00 UTC 2005">Tue Sep 06 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Sep 07 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050907023318/http://www.yahoo.com/">Wed Sep 07 02:33:18 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050907052158/http://www.yahoo.com/">Wed Sep 07 05:21:58 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050907075230/http://www.yahoo.com/">Wed Sep 07 07:52:30 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050907184835/http://www.yahoo.com/">Wed Sep 07 18:48:35 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050907023318/http://www.yahoo.com/" title="4 snapshots" class="Wed Sep 07 00:00:00 UTC 2005">Wed Sep 07 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Sep 08 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050908030608/http://www.yahoo.com/">Thu Sep 08 03:06:08 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050908051652/http://www.yahoo.com/">Thu Sep 08 05:16:52 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050908030608/http://www.yahoo.com/" title="2 snapshots" class="Thu Sep 08 00:00:00 UTC 2005">Thu Sep 08 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Sep 09 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050909013631/http://www.yahoo.com/">Fri Sep 09 01:36:31 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050909092155/http://www.yahoo.com/">Fri Sep 09 09:21:55 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050909221714/http://www.yahoo.com/">Fri Sep 09 22:17:14 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050909234955/http://www.yahoo.com/">Fri Sep 09 23:49:55 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050909013631/http://www.yahoo.com/" title="4 snapshots" class="Fri Sep 09 00:00:00 UTC 2005">Fri Sep 09 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Sep 10 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050910011144/http://www.yahoo.com/">Sat Sep 10 01:11:44 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050910082740/http://www.yahoo.com/">Sat Sep 10 08:27:40 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050910011144/http://www.yahoo.com/" title="2 snapshots" class="Sat Sep 10 00:00:00 UTC 2005">Sat Sep 10 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Sep 11 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050911012644/http://www.yahoo.com/">Sun Sep 11 01:26:44 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050911012644/http://www.yahoo.com/" title="1 snapshots" class="Sun Sep 11 00:00:00 UTC 2005">Sun Sep 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Sep 12 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050912154201/http://www.yahoo.com/">Mon Sep 12 15:42:01 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050912154201/http://www.yahoo.com/" title="1 snapshots" class="Mon Sep 12 00:00:00 UTC 2005">Mon Sep 12 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Sep 13 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050913100218/http://www.yahoo.com/">Tue Sep 13 10:02:18 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050913141339/http://www.yahoo.com/">Tue Sep 13 14:13:39 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050913100218/http://www.yahoo.com/" title="2 snapshots" class="Tue Sep 13 00:00:00 UTC 2005">Tue Sep 13 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Sep 14 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050914055107/http://www.yahoo.com/">Wed Sep 14 05:51:07 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050914082744/http://www.yahoo.com/">Wed Sep 14 08:27:44 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050914143605/http://www.yahoo.com/">Wed Sep 14 14:36:05 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050914165930/http://www.yahoo.com/">Wed Sep 14 16:59:30 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050914055107/http://www.yahoo.com/" title="4 snapshots" class="Wed Sep 14 00:00:00 UTC 2005">Wed Sep 14 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Sep 15 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050915124324/http://www.yahoo.com/">Thu Sep 15 12:43:24 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050915124324/http://www.yahoo.com/" title="1 snapshots" class="Thu Sep 15 00:00:00 UTC 2005">Thu Sep 15 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Fri Sep 16 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Sep 17 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050917023015/http://www.yahoo.com/">Sat Sep 17 02:30:15 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050917125010/http://www.yahoo.com/">Sat Sep 17 12:50:10 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050917023015/http://www.yahoo.com/" title="2 snapshots" class="Sat Sep 17 00:00:00 UTC 2005">Sat Sep 17 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Sep 18 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Sep 19 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050919184057/http://www.yahoo.com/">Mon Sep 19 18:40:57 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050919184057/http://www.yahoo.com/" title="1 snapshots" class="Mon Sep 19 00:00:00 UTC 2005">Mon Sep 19 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Sep 20 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050920102249/http://www.yahoo.com/">Tue Sep 20 10:22:49 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050920215322/http://www.yahoo.com">Tue Sep 20 21:53:22 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050920102249/http://www.yahoo.com/" title="2 snapshots" class="Tue Sep 20 00:00:00 UTC 2005">Tue Sep 20 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Sep 21 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Sep 22 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050922153324/http://www.yahoo.com/">Thu Sep 22 15:33:24 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050922153324/http://www.yahoo.com/" title="1 snapshots" class="Thu Sep 22 00:00:00 UTC 2005">Thu Sep 22 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Sep 23 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050923130041/http://yahoo.com/">Fri Sep 23 13:00:41 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050923142210/http://www.yahoo.com/">Fri Sep 23 14:22:10 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050923213602/http://yahoo.com/">Fri Sep 23 21:36:02 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050923232623/http://yahoo.com/">Fri Sep 23 23:26:23 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050923130041/http://yahoo.com/" title="4 snapshots" class="Fri Sep 23 00:00:00 UTC 2005">Fri Sep 23 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Sep 24 00:00:00 UTC 2005</h3>
		    <p>12 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050924002543/http://yahoo.com/">Sat Sep 24 00:25:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924011034/http://yahoo.com/">Sat Sep 24 01:10:34 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924021351/http://yahoo.com/">Sat Sep 24 02:13:51 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924033246/http://yahoo.com/">Sat Sep 24 03:32:46 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924054652/http://yahoo.com/">Sat Sep 24 05:46:52 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924094435/http://www.yahoo.com/">Sat Sep 24 09:44:35 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924123727/http://www.yahoo.com/">Sat Sep 24 12:37:27 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924151636/http://yahoo.com/">Sat Sep 24 15:16:36 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924170031/http://yahoo.com/">Sat Sep 24 17:00:31 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924183223/http://yahoo.com/">Sat Sep 24 18:32:23 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924225714/http://yahoo.com/?">Sat Sep 24 22:57:14 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050924232344/http://yahoo.com/">Sat Sep 24 23:23:44 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050924002543/http://yahoo.com/" title="12 snapshots" class="Sat Sep 24 00:00:00 UTC 2005">Sat Sep 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Sep 25 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050925215924/http://yahoo.com">Sun Sep 25 21:59:24 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050925215924/http://yahoo.com" title="1 snapshots" class="Sun Sep 25 00:00:00 UTC 2005">Sun Sep 25 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Sep 26 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050926182714/http://www.yahoo.com/">Mon Sep 26 18:27:14 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050926201038/http://yahoo.com/">Mon Sep 26 20:10:38 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050926202559/http://www.yahoo.com/">Mon Sep 26 20:25:59 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050926182714/http://www.yahoo.com/" title="3 snapshots" class="Mon Sep 26 00:00:00 UTC 2005">Mon Sep 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Sep 27 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Sep 28 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050928171257/http://www.yahoo.com/">Wed Sep 28 17:12:57 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050928171257/http://www.yahoo.com/" title="1 snapshots" class="Wed Sep 28 00:00:00 UTC 2005">Wed Sep 28 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Sep 29 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050929231506/http://www.yahoo.com/">Thu Sep 29 23:15:06 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050929231506/http://www.yahoo.com/" title="1 snapshots" class="Thu Sep 29 00:00:00 UTC 2005">Thu Sep 29 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Sep 30 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20050930031700/http://www.yahoo.com/">Fri Sep 30 03:17:00 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20050930235039/http://yahoo.com/">Fri Sep 30 23:50:39 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20050930031700/http://www.yahoo.com/" title="2 snapshots" class="Fri Sep 30 00:00:00 UTC 2005">Fri Sep 30 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-9">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Sat Oct 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Oct 01 00:00:00 UTC 2005</h3>
		    <p>7 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051001005002/http://yahoo.com/">Sat Oct 01 00:50:02 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051001014606/http://yahoo.com/">Sat Oct 01 01:46:06 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051001055040/http://yahoo.com/">Sat Oct 01 05:50:40 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051001060823/http://www.yahoo.com/">Sat Oct 01 06:08:23 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051001070056/http://yahoo.com/">Sat Oct 01 07:00:56 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051001101209/http://yahoo.com/">Sat Oct 01 10:12:09 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051001120149/http://www.yahoo.com/">Sat Oct 01 12:01:49 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051001005002/http://yahoo.com/" title="7 snapshots" class="Sat Oct 01 00:00:00 UTC 2005">Sat Oct 01 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Oct 02 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Oct 03 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051003220040/http://yahoo.com/">Mon Oct 03 22:00:40 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051003220045/http://www.yahoo.com/">Mon Oct 03 22:00:45 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051003220040/http://yahoo.com/" title="2 snapshots" class="Mon Oct 03 00:00:00 UTC 2005">Mon Oct 03 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Oct 04 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Oct 05 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Thu Oct 06 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Oct 07 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051007064220/http://www.yahoo.com/">Fri Oct 07 06:42:20 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051007064220/http://www.yahoo.com/" title="1 snapshots" class="Fri Oct 07 00:00:00 UTC 2005">Fri Oct 07 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Oct 08 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051008151620/http://www.yahoo.com/">Sat Oct 08 15:16:20 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051008151620/http://www.yahoo.com/" title="1 snapshots" class="Sat Oct 08 00:00:00 UTC 2005">Sat Oct 08 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Oct 09 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Oct 10 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Oct 11 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051011020022/http://yahoo.com/">Tue Oct 11 02:00:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051011020042/http://www.yahoo.com/">Tue Oct 11 02:00:42 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051011153730/http://www.yahoo.com/">Tue Oct 11 15:37:30 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051011020022/http://yahoo.com/" title="3 snapshots" class="Tue Oct 11 00:00:00 UTC 2005">Tue Oct 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Oct 12 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051012123018/http://www.yahoo.com/">Wed Oct 12 12:30:18 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051012142243/http://www.yahoo.com/">Wed Oct 12 14:22:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051012214221/http://yahoo.com/">Wed Oct 12 21:42:21 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051012123018/http://www.yahoo.com/" title="3 snapshots" class="Wed Oct 12 00:00:00 UTC 2005">Wed Oct 12 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Oct 13 00:00:00 UTC 2005</h3>
		    <p>7 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051013072222/http://www.yahoo.com/">Thu Oct 13 07:22:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051013080330/http://yahoo.com/">Thu Oct 13 08:03:30 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051013082754/http://www.yahoo.com/">Thu Oct 13 08:27:54 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051013090927/http://www.yahoo.com/.">Thu Oct 13 09:09:27 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051013173743/http://www.yahoo.com/">Thu Oct 13 17:37:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051013184921/http://www.yahoo.com/">Thu Oct 13 18:49:21 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051013194048/http://yahoo.com/">Thu Oct 13 19:40:48 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051013072222/http://www.yahoo.com/" title="7 snapshots" class="Thu Oct 13 00:00:00 UTC 2005">Thu Oct 13 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Oct 14 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051014000658/http://www.yahoo.com/?">Fri Oct 14 00:06:58 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051014203443/http://yahoo.com/">Fri Oct 14 20:34:43 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051014000658/http://www.yahoo.com/?" title="2 snapshots" class="Fri Oct 14 00:00:00 UTC 2005">Fri Oct 14 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Oct 15 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051015185735/http://www.yahoo.com">Sat Oct 15 18:57:35 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051015225609/http://yahoo.com/">Sat Oct 15 22:56:09 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051015185735/http://www.yahoo.com" title="2 snapshots" class="Sat Oct 15 00:00:00 UTC 2005">Sat Oct 15 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Oct 16 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051016023908/http://yahoo.com/">Sun Oct 16 02:39:08 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051016024138/http://www.yahoo.com/">Sun Oct 16 02:41:38 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051016190549/http://www.yahoo.com/">Sun Oct 16 19:05:49 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051016232026/http://www.yahoo.com/">Sun Oct 16 23:20:26 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051016023908/http://yahoo.com/" title="4 snapshots" class="Sun Oct 16 00:00:00 UTC 2005">Sun Oct 16 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Oct 17 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051017170056/http://www.yahoo.com">Mon Oct 17 17:00:56 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051017194724/http://yahoo.com/">Mon Oct 17 19:47:24 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051017170056/http://www.yahoo.com" title="2 snapshots" class="Mon Oct 17 00:00:00 UTC 2005">Mon Oct 17 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Oct 18 00:00:00 UTC 2005</h3>
		    <p>5 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051018024640/http://www.yahoo.com/">Tue Oct 18 02:46:40 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051018031227/http://yahoo.com/">Tue Oct 18 03:12:27 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051018032437/http://www.yahoo.com/?">Tue Oct 18 03:24:37 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051018183609/http://www.yahoo.com/">Tue Oct 18 18:36:09 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051018200902/http://yahoo.com/">Tue Oct 18 20:09:02 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051018024640/http://www.yahoo.com/" title="5 snapshots" class="Tue Oct 18 00:00:00 UTC 2005">Tue Oct 18 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Oct 19 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051019194424/http://yahoo.com/">Wed Oct 19 19:44:24 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051019203442/http://www.yahoo.com/">Wed Oct 19 20:34:42 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051019194424/http://yahoo.com/" title="2 snapshots" class="Wed Oct 19 00:00:00 UTC 2005">Wed Oct 19 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Thu Oct 20 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Oct 21 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051021065227/http://yahoo.com/">Fri Oct 21 06:52:27 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051021084842/http://www.yahoo.com/">Fri Oct 21 08:48:42 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051021134951/http://yahoo.com/">Fri Oct 21 13:49:51 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051021170530/http://www.yahoo.com/">Fri Oct 21 17:05:30 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051021065227/http://yahoo.com/" title="4 snapshots" class="Fri Oct 21 00:00:00 UTC 2005">Fri Oct 21 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Oct 22 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051022193212/http://yahoo.com/">Sat Oct 22 19:32:12 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051022193212/http://yahoo.com/" title="1 snapshots" class="Sat Oct 22 00:00:00 UTC 2005">Sat Oct 22 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Oct 23 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051023015033/http://www.yahoo.com/?">Sun Oct 23 01:50:33 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051023195213/http://www.yahoo.com/">Sun Oct 23 19:52:13 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051023202147/http://www.yahoo.com/">Sun Oct 23 20:21:47 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051023015033/http://www.yahoo.com/?" title="3 snapshots" class="Sun Oct 23 00:00:00 UTC 2005">Sun Oct 23 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Oct 24 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051024002823/http://www.yahoo.com/">Mon Oct 24 00:28:23 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051024075732/http://www.yahoo.com/">Mon Oct 24 07:57:32 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051024080957/http://www.yahoo.com/?">Mon Oct 24 08:09:57 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051024215055/http://www.yahoo.com">Mon Oct 24 21:50:55 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051024002823/http://www.yahoo.com/" title="4 snapshots" class="Mon Oct 24 00:00:00 UTC 2005">Mon Oct 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Oct 25 00:00:00 UTC 2005</h3>
		    <p>6 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051025004108/http://yahoo.com/">Tue Oct 25 00:41:08 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051025010820/http://yahoo.com/">Tue Oct 25 01:08:20 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051025010822/http://www.yahoo.com/">Tue Oct 25 01:08:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051025081518/http://www.yahoo.com/">Tue Oct 25 08:15:18 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051025142502/http://www.yahoo.com/">Tue Oct 25 14:25:02 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051025232233/http://yahoo.com/">Tue Oct 25 23:22:33 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051025004108/http://yahoo.com/" title="6 snapshots" class="Tue Oct 25 00:00:00 UTC 2005">Tue Oct 25 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Oct 26 00:00:00 UTC 2005</h3>
		    <p>5 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051026082438/http://www.yahoo.com/?">Wed Oct 26 08:24:38 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051026104616/http://www.yahoo.com/">Wed Oct 26 10:46:16 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051026121629/http://www.yahoo.com/">Wed Oct 26 12:16:29 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051026133028/http://www.yahoo.com/">Wed Oct 26 13:30:28 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051026171017/http://yahoo.com/">Wed Oct 26 17:10:17 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051026082438/http://www.yahoo.com/?" title="5 snapshots" class="Wed Oct 26 00:00:00 UTC 2005">Wed Oct 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Oct 27 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051027000628/http://www.yahoo.com/">Thu Oct 27 00:06:28 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051027223340/http://www.yahoo.com/">Thu Oct 27 22:33:40 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051027000628/http://www.yahoo.com/" title="2 snapshots" class="Thu Oct 27 00:00:00 UTC 2005">Thu Oct 27 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Oct 28 00:00:00 UTC 2005</h3>
		    <p>6 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051028001044/http://yahoo.com/">Fri Oct 28 00:10:44 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051028012321/http://www.yahoo.com/?">Fri Oct 28 01:23:21 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051028045551/http://yahoo.com/">Fri Oct 28 04:55:51 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051028045940/http://www.yahoo.com/">Fri Oct 28 04:59:40 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051028050333/http://www.yahoo.com/?">Fri Oct 28 05:03:33 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051028235942/http://www.yahoo.com/">Fri Oct 28 23:59:42 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051028001044/http://yahoo.com/" title="6 snapshots" class="Fri Oct 28 00:00:00 UTC 2005">Fri Oct 28 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Oct 29 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051029000656/http://yahoo.com/">Sat Oct 29 00:06:56 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051029091131/http://www.yahoo.com/">Sat Oct 29 09:11:31 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051029174959/http://www.yahoo.com/?">Sat Oct 29 17:49:59 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051029180434/http://www.yahoo.com/">Sat Oct 29 18:04:34 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051029000656/http://yahoo.com/" title="4 snapshots" class="Sat Oct 29 00:00:00 UTC 2005">Sat Oct 29 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Oct 30 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051030002225/http://yahoo.com/">Sun Oct 30 00:22:25 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051030024359/http://www.yahoo.com/">Sun Oct 30 02:43:59 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051030082021/http://www.yahoo.com/">Sun Oct 30 08:20:21 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051030002225/http://yahoo.com/" title="3 snapshots" class="Sun Oct 30 00:00:00 UTC 2005">Sun Oct 30 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Oct 31 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051031023705/http://www.yahoo.com/">Mon Oct 31 02:37:05 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051031084553/http://www.yahoo.com/?">Mon Oct 31 08:45:53 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051031091538/http://www.yahoo.com/">Mon Oct 31 09:15:38 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051031235711/http://www.yahoo.com/">Mon Oct 31 23:57:11 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051031023705/http://www.yahoo.com/" title="4 snapshots" class="Mon Oct 31 00:00:00 UTC 2005">Mon Oct 31 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-10">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Tue Nov 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Nov 01 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051101005822/http://www.yahoo.com/">Tue Nov 01 00:58:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051101093013/http://yahoo.com/">Tue Nov 01 09:30:13 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051101095050/http://www.yahoo.com/?">Tue Nov 01 09:50:50 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051101005822/http://www.yahoo.com/" title="3 snapshots" class="Tue Nov 01 00:00:00 UTC 2005">Tue Nov 01 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Nov 02 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051102010613/http://www.yahoo.com/">Wed Nov 02 01:06:13 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051102085637/http://www.yahoo.com/?">Wed Nov 02 08:56:37 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051102093731/http://www.yahoo.com/">Wed Nov 02 09:37:31 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051102010613/http://www.yahoo.com/" title="3 snapshots" class="Wed Nov 02 00:00:00 UTC 2005">Wed Nov 02 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Nov 03 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051103012513/http://www.yahoo.com/">Thu Nov 03 01:25:13 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051103205237/http://yahoo.com/">Thu Nov 03 20:52:37 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051103012513/http://www.yahoo.com/" title="2 snapshots" class="Thu Nov 03 00:00:00 UTC 2005">Thu Nov 03 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Nov 04 00:00:00 UTC 2005</h3>
		    <p>6 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051104014654/http://yahoo.com/">Fri Nov 04 01:46:54 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051104015519/http://www.yahoo.com/?">Fri Nov 04 01:55:19 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051104021627/http://www.yahoo.com/">Fri Nov 04 02:16:27 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051104094816/http://www.yahoo.com/">Fri Nov 04 09:48:16 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051104100737/http://www.yahoo.com/?">Fri Nov 04 10:07:37 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051104204941/http://yahoo.com/">Fri Nov 04 20:49:41 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051104014654/http://yahoo.com/" title="6 snapshots" class="Fri Nov 04 00:00:00 UTC 2005">Fri Nov 04 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Nov 05 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051105015703/http://www.yahoo.com/">Sat Nov 05 01:57:03 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051105091056/http://www.yahoo.com/">Sat Nov 05 09:10:56 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051105205640/http://yahoo.com/">Sat Nov 05 20:56:40 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051105015703/http://www.yahoo.com/" title="3 snapshots" class="Sat Nov 05 00:00:00 UTC 2005">Sat Nov 05 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Nov 06 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051106011416/http://www.yahoo.com">Sun Nov 06 01:14:16 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051106033536/http://www.yahoo.com/">Sun Nov 06 03:35:36 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051106092234/http://www.yahoo.com/">Sun Nov 06 09:22:34 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051106104828/http://yahoo.com/">Sun Nov 06 10:48:28 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051106011416/http://www.yahoo.com" title="4 snapshots" class="Sun Nov 06 00:00:00 UTC 2005">Sun Nov 06 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Nov 07 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051107004224/http://www.yahoo.com/">Mon Nov 07 00:42:24 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051107091300/http://www.yahoo.com/?">Mon Nov 07 09:13:00 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051107103622/http://www.yahoo.com">Mon Nov 07 10:36:22 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051107004224/http://www.yahoo.com/" title="3 snapshots" class="Mon Nov 07 00:00:00 UTC 2005">Mon Nov 07 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Nov 08 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051108001639/http://yahoo.com/">Tue Nov 08 00:16:39 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051108004309/http://www.yahoo.com/">Tue Nov 08 00:43:09 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051108010058/http://www.yahoo.com/">Tue Nov 08 01:00:58 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051108001639/http://yahoo.com/" title="3 snapshots" class="Tue Nov 08 00:00:00 UTC 2005">Tue Nov 08 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Nov 09 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051109002356/http://yahoo.com/">Wed Nov 09 00:23:56 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051109011126/http://www.yahoo.com/">Wed Nov 09 01:11:26 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051109104640/http://www.yahoo.com">Wed Nov 09 10:46:40 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051109002356/http://yahoo.com/" title="3 snapshots" class="Wed Nov 09 00:00:00 UTC 2005">Wed Nov 09 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Nov 10 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051110031347/http://yahoo.com/">Thu Nov 10 03:13:47 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051110104144/http://www.yahoo.com/">Thu Nov 10 10:41:44 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051110123054/http://yahoo.com/">Thu Nov 10 12:30:54 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051110150855/http://www.yahoo.com/">Thu Nov 10 15:08:55 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051110031347/http://yahoo.com/" title="4 snapshots" class="Thu Nov 10 00:00:00 UTC 2005">Thu Nov 10 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Nov 11 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051111004150/http://yahoo.com">Fri Nov 11 00:41:50 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051111222227/http://yahoo.com/">Fri Nov 11 22:22:27 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051111004150/http://yahoo.com" title="2 snapshots" class="Fri Nov 11 00:00:00 UTC 2005">Fri Nov 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Nov 12 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051112174934/http://yahoo.com">Sat Nov 12 17:49:34 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051112174934/http://yahoo.com" title="1 snapshots" class="Sat Nov 12 00:00:00 UTC 2005">Sat Nov 12 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Nov 13 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051113004802/http://www.yahoo.com">Sun Nov 13 00:48:02 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051113065518/http://www.yahoo.com/">Sun Nov 13 06:55:18 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051113004802/http://www.yahoo.com" title="2 snapshots" class="Sun Nov 13 00:00:00 UTC 2005">Sun Nov 13 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Nov 14 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Nov 15 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051115002225/http://www.yahoo.com/">Tue Nov 15 00:22:25 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051115053215/http://yahoo.com/">Tue Nov 15 05:32:15 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051115002225/http://www.yahoo.com/" title="2 snapshots" class="Tue Nov 15 00:00:00 UTC 2005">Tue Nov 15 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Wed Nov 16 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Nov 17 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051117124759/http://www.yahoo.com">Thu Nov 17 12:47:59 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051117124759/http://www.yahoo.com" title="1 snapshots" class="Thu Nov 17 00:00:00 UTC 2005">Thu Nov 17 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Nov 18 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051118155514/http://www.yahoo.com/">Fri Nov 18 15:55:14 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051118155514/http://www.yahoo.com/" title="1 snapshots" class="Fri Nov 18 00:00:00 UTC 2005">Fri Nov 18 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Nov 19 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051119154500/http://www.yahoo.com">Sat Nov 19 15:45:00 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051119173654/http://yahoo.com">Sat Nov 19 17:36:54 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051119154500/http://www.yahoo.com" title="2 snapshots" class="Sat Nov 19 00:00:00 UTC 2005">Sat Nov 19 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Sun Nov 20 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Mon Nov 21 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	    
	      <td><div class="date"><div class="day">
	        <span>Tue Nov 22 00:00:00 UTC 2005</span>
	      </div></td>
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Nov 23 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051123175901/http://www.yahoo.com">Wed Nov 23 17:59:01 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051123210218/http://www.yahoo.com/">Wed Nov 23 21:02:18 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051123175901/http://www.yahoo.com" title="2 snapshots" class="Wed Nov 23 00:00:00 UTC 2005">Wed Nov 23 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Nov 24 00:00:00 UTC 2005</h3>
		    <p>7 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051124030036/http://www.yahoo.com/">Thu Nov 24 03:00:36 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051124040803/http://www.yahoo.com/?">Thu Nov 24 04:08:03 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051124121934/http://www.yahoo.com/">Thu Nov 24 12:19:34 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051124152245/http://www.yahoo.com/?">Thu Nov 24 15:22:45 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051124194735/http://www.yahoo.com/.">Thu Nov 24 19:47:35 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051124200016/http://www.yahoo.com/">Thu Nov 24 20:00:16 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051124230839/http://www.yahoo.com/">Thu Nov 24 23:08:39 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051124030036/http://www.yahoo.com/" title="7 snapshots" class="Thu Nov 24 00:00:00 UTC 2005">Thu Nov 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Nov 25 00:00:00 UTC 2005</h3>
		    <p>7 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051125052159/http://www.yahoo.com/?">Fri Nov 25 05:21:59 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051125072222/http://www.yahoo.com/?">Fri Nov 25 07:22:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051125093035/http://www.yahoo.com/">Fri Nov 25 09:30:35 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051125100331/http://www.yahoo.com/">Fri Nov 25 10:03:31 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051125141043/http://www.yahoo.com/">Fri Nov 25 14:10:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051125170321/http://www.yahoo.com/">Fri Nov 25 17:03:21 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051125213824/http://www.yahoo.com/?">Fri Nov 25 21:38:24 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051125052159/http://www.yahoo.com/?" title="7 snapshots" class="Fri Nov 25 00:00:00 UTC 2005">Fri Nov 25 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Nov 26 00:00:00 UTC 2005</h3>
		    <p>8 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051126052244/http://www.yahoo.com/?">Sat Nov 26 05:22:44 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051126060551/http://www.yahoo.com/?">Sat Nov 26 06:05:51 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051126090727/http://www.yahoo.com/">Sat Nov 26 09:07:27 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051126120402/http://www.yahoo.com/?">Sat Nov 26 12:04:02 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051126153730/http://yahoo.com/">Sat Nov 26 15:37:30 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051126154608/http://www.yahoo.com/?">Sat Nov 26 15:46:08 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051126173754/http://www.yahoo.com/?">Sat Nov 26 17:37:54 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051126194132/http://www.yahoo.com/">Sat Nov 26 19:41:32 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051126052244/http://www.yahoo.com/?" title="8 snapshots" class="Sat Nov 26 00:00:00 UTC 2005">Sat Nov 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Nov 27 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051127035358/http://yahoo.com/">Sun Nov 27 03:53:58 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051127040124/http://www.yahoo.com/">Sun Nov 27 04:01:24 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051127142606/http://www.yahoo.com">Sun Nov 27 14:26:06 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051127035358/http://yahoo.com/" title="3 snapshots" class="Sun Nov 27 00:00:00 UTC 2005">Sun Nov 27 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Nov 28 00:00:00 UTC 2005</h3>
		    <p>7 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051128024925/http://www.yahoo.com/?">Mon Nov 28 02:49:25 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051128030517/http://yahoo.com/?">Mon Nov 28 03:05:17 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051128030734/http://www.yahoo.com/">Mon Nov 28 03:07:34 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051128085640/http://www.yahoo.com/">Mon Nov 28 08:56:40 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051128141209/http://www.yahoo.com/">Mon Nov 28 14:12:09 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051128172012/http://www.yahoo.com/">Mon Nov 28 17:20:12 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051128193252/http://yahoo.com/">Mon Nov 28 19:32:52 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051128024925/http://www.yahoo.com/?" title="7 snapshots" class="Mon Nov 28 00:00:00 UTC 2005">Mon Nov 28 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Nov 29 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051129032958/http://www.yahoo.com/">Tue Nov 29 03:29:58 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051129090932/http://www.yahoo.com/">Tue Nov 29 09:09:32 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051129150719/http://yahoo.com/">Tue Nov 29 15:07:19 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051129032958/http://www.yahoo.com/" title="3 snapshots" class="Tue Nov 29 00:00:00 UTC 2005">Tue Nov 29 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Nov 30 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051130031206/http://yahoo.com/">Wed Nov 30 03:12:06 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051130041622/http://yahoo.com/">Wed Nov 30 04:16:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051130041909/http://www.yahoo.com/">Wed Nov 30 04:19:09 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051130093812/http://www.yahoo.com/">Wed Nov 30 09:38:12 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051130031206/http://yahoo.com/" title="4 snapshots" class="Wed Nov 30 00:00:00 UTC 2005">Wed Nov 30 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
    
    <div class="month" id="2005-11">
      <table>
        <thead>
          <tr><th colspan="7"><span class="month-label">Thu Dec 01 00:00:00 UTC 2005</span></th></tr>
	</thead>
        <tbody>
	  
	  <tr>
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    <td></td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Dec 01 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051201070753/http://www.yahoo.com/?">Thu Dec 01 07:07:53 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051201085951/http://www.yahoo.com/">Thu Dec 01 08:59:51 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051201111151/http://www.yahoo.com/">Thu Dec 01 11:11:51 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051201070753/http://www.yahoo.com/?" title="3 snapshots" class="Thu Dec 01 00:00:00 UTC 2005">Thu Dec 01 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Dec 02 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051202061227/http://yahoo.com/">Fri Dec 02 06:12:27 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051202080924/http://yahoo.com/">Fri Dec 02 08:09:24 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051202081841/http://www.yahoo.com/?">Fri Dec 02 08:18:41 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051202110747/http://www.yahoo.com/">Fri Dec 02 11:07:47 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051202061227/http://yahoo.com/" title="4 snapshots" class="Fri Dec 02 00:00:00 UTC 2005">Fri Dec 02 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Dec 03 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051203063237/http://www.yahoo.com/">Sat Dec 03 06:32:37 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051203090755/http://www.yahoo.com/">Sat Dec 03 09:07:55 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051203063237/http://www.yahoo.com/" title="2 snapshots" class="Sat Dec 03 00:00:00 UTC 2005">Sat Dec 03 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Dec 04 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051204032014/http://www.yahoo.com/">Sun Dec 04 03:20:14 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051204040632/http://www.yahoo.com/">Sun Dec 04 04:06:32 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051204094747/http://www.yahoo.com/">Sun Dec 04 09:47:47 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051204032014/http://www.yahoo.com/" title="3 snapshots" class="Sun Dec 04 00:00:00 UTC 2005">Sun Dec 04 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Dec 05 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051205030037/http://www.yahoo.com/">Mon Dec 05 03:00:37 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051205094036/http://www.yahoo.com/">Mon Dec 05 09:40:36 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051205122651/http://yahoo.com">Mon Dec 05 12:26:51 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051205163225/http://yahoo.com">Mon Dec 05 16:32:25 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051205030037/http://www.yahoo.com/" title="4 snapshots" class="Mon Dec 05 00:00:00 UTC 2005">Mon Dec 05 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Dec 06 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051206021327/http://www.yahoo.com">Tue Dec 06 02:13:27 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051206040103/http://www.yahoo.com/">Tue Dec 06 04:01:03 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051206102501/http://www.yahoo.com/">Tue Dec 06 10:25:01 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051206021327/http://www.yahoo.com" title="3 snapshots" class="Tue Dec 06 00:00:00 UTC 2005">Tue Dec 06 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Dec 07 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051207044433/http://www.yahoo.com/?">Wed Dec 07 04:44:33 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051207102808/http://www.yahoo.com/">Wed Dec 07 10:28:08 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051207044433/http://www.yahoo.com/?" title="2 snapshots" class="Wed Dec 07 00:00:00 UTC 2005">Wed Dec 07 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Dec 08 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051208063103/http://www.yahoo.com/?">Thu Dec 08 06:31:03 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051208092140/http://www.yahoo.com/">Thu Dec 08 09:21:40 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051208063103/http://www.yahoo.com/?" title="2 snapshots" class="Thu Dec 08 00:00:00 UTC 2005">Thu Dec 08 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Dec 09 00:00:00 UTC 2005</h3>
		    <p>1 snapshot</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051209192813/http://www.yahoo.com">Fri Dec 09 19:28:13 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051209192813/http://www.yahoo.com" title="1 snapshots" class="Fri Dec 09 00:00:00 UTC 2005">Fri Dec 09 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Dec 10 00:00:00 UTC 2005</h3>
		    <p>5 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051210021211/http://www.yahoo.com/">Sat Dec 10 02:12:11 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051210030434/http://www.yahoo.com/?">Sat Dec 10 03:04:34 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051210184748/http://www.yahoo.com/">Sat Dec 10 18:47:48 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051210190316/http://www.yahoo.com/?">Sat Dec 10 19:03:16 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051210203757/http://www.yahoo.com/">Sat Dec 10 20:37:57 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051210021211/http://www.yahoo.com/" title="5 snapshots" class="Sat Dec 10 00:00:00 UTC 2005">Sat Dec 10 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Dec 11 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051211075259/http://www.yahoo.com/">Sun Dec 11 07:52:59 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051211081114/http://www.yahoo.com/?">Sun Dec 11 08:11:14 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051211101529/http://yahoo.com/">Sun Dec 11 10:15:29 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051211133524/http://www.yahoo.com/">Sun Dec 11 13:35:24 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051211075259/http://www.yahoo.com/" title="4 snapshots" class="Sun Dec 11 00:00:00 UTC 2005">Sun Dec 11 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Dec 12 00:00:00 UTC 2005</h3>
		    <p>9 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051212003552/http://yahoo.com">Mon Dec 12 00:35:52 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051212040632/http://www.yahoo.com/">Mon Dec 12 04:06:32 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051212065502/http://www.yahoo.com/">Mon Dec 12 06:55:02 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051212070825/http://www.yahoo.com/?">Mon Dec 12 07:08:25 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051212082435/http://www.yahoo.com">Mon Dec 12 08:24:35 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051212173357/http://www.yahoo.com/">Mon Dec 12 17:33:57 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051212212252/http://yahoo.com/">Mon Dec 12 21:22:52 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051212230518/http://yahoo.com/">Mon Dec 12 23:05:18 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051212231756/http://www.yahoo.com/">Mon Dec 12 23:17:56 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051212003552/http://yahoo.com" title="9 snapshots" class="Mon Dec 12 00:00:00 UTC 2005">Mon Dec 12 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Dec 13 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051213011754/http://www.yahoo.com/?">Tue Dec 13 01:17:54 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051213021122/http://www.yahoo.com/">Tue Dec 13 02:11:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051213084704/http://www.yahoo.com/">Tue Dec 13 08:47:04 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051213220543/http://www.yahoo.com/">Tue Dec 13 22:05:43 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051213011754/http://www.yahoo.com/?" title="4 snapshots" class="Tue Dec 13 00:00:00 UTC 2005">Tue Dec 13 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Dec 14 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051214064337/http://www.yahoo.com/?">Wed Dec 14 06:43:37 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051214070639/http://www.yahoo.com/">Wed Dec 14 07:06:39 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051214202825/http://www.yahoo.com/">Wed Dec 14 20:28:25 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051214064337/http://www.yahoo.com/?" title="3 snapshots" class="Wed Dec 14 00:00:00 UTC 2005">Wed Dec 14 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Dec 15 00:00:00 UTC 2005</h3>
		    <p>6 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051215034818/http://yahoo.com/">Thu Dec 15 03:48:18 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051215055506/http://yahoo.com/">Thu Dec 15 05:55:06 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051215080139/http://www.yahoo.com/?">Thu Dec 15 08:01:39 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051215134753/http://yahoo.com">Thu Dec 15 13:47:53 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051215193907/http://yahoo.com">Thu Dec 15 19:39:07 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051215213812/http://www.yahoo.com/">Thu Dec 15 21:38:12 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051215034818/http://yahoo.com/" title="6 snapshots" class="Thu Dec 15 00:00:00 UTC 2005">Thu Dec 15 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Dec 16 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051216015855/http://yahoo.com/">Fri Dec 16 01:58:55 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051216095512/http://yahoo.com/">Fri Dec 16 09:55:12 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051216110956/http://www.yahoo.com/">Fri Dec 16 11:09:56 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051216015855/http://yahoo.com/" title="3 snapshots" class="Fri Dec 16 00:00:00 UTC 2005">Fri Dec 16 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Dec 17 00:00:00 UTC 2005</h3>
		    <p>5 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051217082459/http://www.yahoo.com">Sat Dec 17 08:24:59 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051217102739/http://yahoo.com/">Sat Dec 17 10:27:39 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051217123014/http://www.yahoo.com/?">Sat Dec 17 12:30:14 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051217135202/http://www.yahoo.com/">Sat Dec 17 13:52:02 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051217143236/http://www.yahoo.com/">Sat Dec 17 14:32:36 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051217082459/http://www.yahoo.com" title="5 snapshots" class="Sat Dec 17 00:00:00 UTC 2005">Sat Dec 17 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Dec 18 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051218062015/http://www.yahoo.com/?">Sun Dec 18 06:20:15 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051218071643/http://yahoo.com/">Sun Dec 18 07:16:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051218082409/http://yahoo.com/">Sun Dec 18 08:24:09 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051218201713/http://www.yahoo.com/">Sun Dec 18 20:17:13 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051218062015/http://www.yahoo.com/?" title="4 snapshots" class="Sun Dec 18 00:00:00 UTC 2005">Sun Dec 18 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Dec 19 00:00:00 UTC 2005</h3>
		    <p>4 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051219083844/http://www.yahoo.com/">Mon Dec 19 08:38:44 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051219090925/http://www.yahoo.com/?">Mon Dec 19 09:09:25 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051219164843/http://yahoo.com/">Mon Dec 19 16:48:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051219233948/http://www.yahoo.com/">Mon Dec 19 23:39:48 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051219083844/http://www.yahoo.com/" title="4 snapshots" class="Mon Dec 19 00:00:00 UTC 2005">Mon Dec 19 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Dec 20 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051220084247/http://yahoo.com/">Tue Dec 20 08:42:47 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051220150236/http://www.yahoo.com/">Tue Dec 20 15:02:36 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051220084247/http://yahoo.com/" title="2 snapshots" class="Tue Dec 20 00:00:00 UTC 2005">Tue Dec 20 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Dec 21 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051221034218/http://www.yahoo.com/#">Wed Dec 21 03:42:18 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051221041614/http://www.yahoo.com/?">Wed Dec 21 04:16:14 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051221034218/http://www.yahoo.com/#" title="2 snapshots" class="Wed Dec 21 00:00:00 UTC 2005">Wed Dec 21 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Dec 22 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051222034132/http://www.yahoo.com/">Thu Dec 22 03:41:32 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051222073039/http://www.yahoo.com">Thu Dec 22 07:30:39 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051222171302/http://www.yahoo.com/">Thu Dec 22 17:13:02 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051222034132/http://www.yahoo.com/" title="3 snapshots" class="Thu Dec 22 00:00:00 UTC 2005">Thu Dec 22 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Dec 23 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051223064158/http://www.yahoo.com/?">Fri Dec 23 06:41:58 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051223074043/http://www.yahoo.com/#">Fri Dec 23 07:40:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051223183650/http://www.yahoo.com/">Fri Dec 23 18:36:50 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051223064158/http://www.yahoo.com/?" title="3 snapshots" class="Fri Dec 23 00:00:00 UTC 2005">Fri Dec 23 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Dec 24 00:00:00 UTC 2005</h3>
		    <p>2 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051224071308/http://www.yahoo.com/?">Sat Dec 24 07:13:08 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051224162654/http://www.yahoo.com/">Sat Dec 24 16:26:54 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051224071308/http://www.yahoo.com/?" title="2 snapshots" class="Sat Dec 24 00:00:00 UTC 2005">Sat Dec 24 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
	  <tr>
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sun Dec 25 00:00:00 UTC 2005</h3>
		    <p>6 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051225034351/http://www.yahoo.com/?">Sun Dec 25 03:43:51 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051225043619/http://www.yahoo.com/#">Sun Dec 25 04:36:19 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051225083220/http://www.yahoo.com/">Sun Dec 25 08:32:20 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051225090930/http://www.yahoo.com/?">Sun Dec 25 09:09:30 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051225112344/http://www.yahoo.com">Sun Dec 25 11:23:44 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051225184709/http://www.yahoo.com/">Sun Dec 25 18:47:09 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051225034351/http://www.yahoo.com/?" title="6 snapshots" class="Sun Dec 25 00:00:00 UTC 2005">Sun Dec 25 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Mon Dec 26 00:00:00 UTC 2005</h3>
		    <p>5 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051226045341/http://www.yahoo.com/">Mon Dec 26 04:53:41 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051226051649/http://www.yahoo.com/?">Mon Dec 26 05:16:49 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051226142040/http://www.yahoo.com/">Mon Dec 26 14:20:40 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051226165454/http://www.yahoo.com">Mon Dec 26 16:54:54 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051226234534/http://www.yahoo.com/">Mon Dec 26 23:45:34 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051226045341/http://www.yahoo.com/" title="5 snapshots" class="Mon Dec 26 00:00:00 UTC 2005">Mon Dec 26 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Tue Dec 27 00:00:00 UTC 2005</h3>
		    <p>5 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051227033325/http://yahoo.com/">Tue Dec 27 03:33:25 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051227034748/http://www.yahoo.com/">Tue Dec 27 03:47:48 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051227042525/http://www.yahoo.com/?">Tue Dec 27 04:25:25 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051227113643/http://www.yahoo.com/">Tue Dec 27 11:36:43 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051227180629/http://www.yahoo.com/">Tue Dec 27 18:06:29 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051227033325/http://yahoo.com/" title="5 snapshots" class="Tue Dec 27 00:00:00 UTC 2005">Tue Dec 27 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Wed Dec 28 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051228045837/http://www.yahoo.com/?">Wed Dec 28 04:58:37 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051228052811/http://www.yahoo.com/">Wed Dec 28 05:28:11 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051228101537/http://www.yahoo.com/">Wed Dec 28 10:15:37 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051228045837/http://www.yahoo.com/?" title="3 snapshots" class="Wed Dec 28 00:00:00 UTC 2005">Wed Dec 28 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Thu Dec 29 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051229163606/http://www.yahoo.com/?">Thu Dec 29 16:36:06 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051229172837/http://www.yahoo.com/">Thu Dec 29 17:28:37 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051229213346/http://www.yahoo.com/">Thu Dec 29 21:33:46 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051229163606/http://www.yahoo.com/?" title="3 snapshots" class="Thu Dec 29 00:00:00 UTC 2005">Thu Dec 29 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Fri Dec 30 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051230043725/http://www.yahoo.com/">Fri Dec 30 04:37:25 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051230061822/http://www.yahoo.com/?">Fri Dec 30 06:18:22 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051230175410/http://www.yahoo.com/">Fri Dec 30 17:54:10 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051230043725/http://www.yahoo.com/" title="3 snapshots" class="Fri Dec 30 00:00:00 UTC 2005">Fri Dec 30 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
	    
	    
	    
	      <td>
		<div class="date captures">
		  <div class="pop">
		    <h3>Sat Dec 31 00:00:00 UTC 2005</h3>
		    <p>3 snapshots</p>
		    <ul>
		    
		    
		    <li><a href="/web/20051231051831/http://www.yahoo.com/">Sat Dec 31 05:18:31 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051231061411/http://www.yahoo.com/?">Sat Dec 31 06:14:11 UTC 2005</a></li>
		    
		    
		    <li><a href="/web/20051231122406/http://www.yahoo.com/">Sat Dec 31 12:24:06 UTC 2005</a></li>
		    
		    </ul>
		  </div>
		  <div class="day">
		    
		    <a href="/web/20051231051831/http://www.yahoo.com/" title="3 snapshots" class="Sat Dec 31 00:00:00 UTC 2005">Sat Dec 31 00:00:00 UTC 2005</a>
                  <div>
		</div>
	      </td>
	    
	    
   	    
	  
          </tr>
	  
  	</tbody>
      </table>
    </div>
  
  </div>
  </div>
  <div id="wbCalNote">
    <h2>Note</h2>
    <p>This calendar view maps the number of times http://yahoo.com was crawled by the Wayback Machine, <em>not</em> how many times the site was actually updated. More info in the <a href="//archive.org/about/faqs.php#The_Wayback_Machine">FAQ</a>.</p>
  </div>
</div>

<!-- FOOTER -->
            <footer>
            <div id="footerHome">
                <p>The Wayback Machine is an initiative of the <a href="//archive.org/">Internet Archive</a>, a 501(c)(3) non-profit, building a digital library of Internet sites and other cultural artifacts in digital form.<br/>Other <a href="//archive.org/projects/">projects</a> include <a href="https://openlibrary.org/">Open Library</a> &amp; <a href="https://archive-it.org">archive-it.org</a>.</p>
                <p>Your use of the Wayback Machine is subject to the Internet Archive's <a href="//archive.org/about/terms.php">Terms of Use</a>.</p>
            </div>
            </footer>
        </div>
    </body>
</html>
<!-- /FOOTER -->

