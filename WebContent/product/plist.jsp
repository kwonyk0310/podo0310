<%@page import="utility.Paging"%>
<%@page import="DAO.ProductDAO"%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="./../common/nav.jsp"%>


<!DOCTYPE html>

<html>
	<head>

<style type="text/css">
	body {
	  background: #eecda3;
	  background: -webkit-linear-gradient(to bottom, #FAEBD7, #DEB887);
	  background: linear-gradient(to bottom, #FAEBD7, #DEB887);
	  min-height: 100vh;
	}
	section{
	padding-left: 130px;
	padding-right: 50px;
	}
	
</style>

	<script type="text/javascript">
		function writeForm(){
			location.href='<%=NoForm%>prInsert';
		}

	</script>
	<script>
		$(document).ready(function(){
		  $('[data-toggle="tooltip"]').tooltip();   
		});
	</script>
	
</head>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<body >


<div class="w3-sidebar w3-bar-block w3-yellow w3-xxlarge" style="width:70px; align-content: center;">

	
	<div class="container">
 		<a href="<%=NoForm%>pcategorylist&mode=eyes&${requestScope.parameters}"
 				 data-toggle="tooltip" title="눈!!!!!"> 
						<i class="fas fa-eye" style='font-size:36px;'></i>
					</a>
		</div>	
	<div class="container">
 		<a href="<%=NoForm%>pcategorylist&mode=bloodcirculation&${requestScope.parameters}"> 
							<i class='fas fa-retweet' style='font-size:36px'></i>
						</a>
		</div>	
	<div class="container">						 
		 <a href="<%=NoForm%>pcategorylist&mode=digestiveapparatus&${requestScope.parameters}"> 
					<i class='fas fa-lungs-virus' style='font-size:36px'></i>
						</a> 
		</div>	
	<div class="container">												
 		<a href="<%=NoForm%>pcategorylist&mode=skin&${requestScope.parameters}"> 
					<i class="far fa-smile-beam"></i>
						</a>
		</div>	
	<div class="container">						
 		<a href="<%=NoForm%>pcategorylist&mode=fatigue&${requestScope.parameters}"> 
					<i class='fas fa-child' style='font-size:36px'></i>
						</a>
		</div>	
	<div class="container">						 				
 		<a href="<%=NoForm%>pcategorylist&mode=joint&${requestScope.parameters}"> 
					<i class='fas fa-bone' style='font-size:36px'></i>
						</a>
		</div>	
	<div class="container">								
 		<a href="<%=NoForm%>pcategorylist&mode=hair&${requestScope.parameters}"> 
					<i class='fab fa-keybase' style='font-size:36px'></i>
						</a> 
		</div>	
	<div class="container">														
 		<a href="<%=NoForm%>pcategorylist&mode=immunity&${requestScope.parameters}"> 
					<i class="fas fa-street-view" style='font-size:36px'></i>
						</a> 
		</div>		
	<c:if test="${whologin == 2}">
		<div class="container" style="margin-top:20px;">														
	 		<a href="<%=NoForm%>pcategorylist&mode=immunity&${requestScope.parameters}"> 
						<i class='fas fa-barcode' style='font-size:36px'></i>
							</a> 
			</div>	
	</c:if>																								
  </div>	


  <div class="container text-#8B4513 py-5 text-center">
  	<h3>Product List</h3>
  </div>


<!--Section: Block Content-->
<section>
<div>
  <!-- Grid row -->
  <div class="row">
		<c:forEach var="bean" items="${requestScope.lists}">
		    <!-- Grid column -->
		    <div class="col-md-3 mb-3">
		      <!-- Card -->
		      <div class="">
		        <!-- <a href="#!"> -->
           		 <div class="mask">
            		<a href="<%=NoForm%>pdetail&productcode=${bean.productcode}&${requestScope.parameters}">		  	
            		<img src="${applicationScope.uploadedPath}/${bean.images}"
										class="img-fluid w-100" width="200" height="300"
										alt="${bean.images}" >
		         	 </a> 
		          </div> 
		        <div class="text-center pt-3">
		          <h5>${bean.productname}</h5>
		          <hr>
		          <h6 class="mb-3">
		            <span class="text-danger mr-1">
		            ￦<fmt:formatNumber value="${bean.productprice*0.8}" pattern="###,###"/>
		            </span>
		            <span class="text-grey"><s>
		            ￦<fmt:formatNumber value="${bean.productprice}" pattern="###,###"/>
		            </s></span>
		          </h6>
		          <%-- <h6 class="mb-3">${bean.productprice}</h6> --%>
		         		 <form class="form-inline" role="form" method="post" action="<%=YesForm%>">
								<div class="form-group">
									<input type="hidden" name="command" value="mallcartadd">
									<input type="hidden" name="productcode" value="${bean.productcode}">
									<input type="hidden" name="stock" value="${bean.stock}">
									<input type="hidden" name="qty" value="1">         
								</div>
								<button type="submit" class="btn btn-primary btn-sm mr-1 mb-2">Add to cart</button>
							</form>
					<form class="form-inline" role="form" name="myform" action="<%=YesForm%>" method="post">
					  <input type="hidden" name="command" value="pdetail">
						<a href="<%=NoForm%>pdetail&productcode=${bean.productcode}&${requestScope.parameters}">
							<button type="button" class="btn btn-light btn-sm mr-1 mb-2">
							<i class="fas fa-info-circle pr-2"></i>Details</button> 		
						</a>
		         </form>
		        </div>
		      </div>
		    <!-- Card -->
		   </div>
		  <!-- Grid column -->
	</c:forEach>	
</div>

	<table>
		<tr>
			<td colspan="12" align="center">
				<form class="form-inline" role="form" name="myform" action="<%=YesForm%>" method="get">
				<input type="hidden" name="command" value="plist">
					<div class="form-group">
						<input type="text" class="form-control btn-xs" name="keyword"
							id="keyword" placeholder="검색 키워드">
					</div>
				<button class="btn btn-default btn-warning" type="submit" onclick="search();">검색</button>
				<p class="form-control-static">${requestScope.pagingStatus}</p>
				</form>
			</td>
		</tr>
		<tr>
			<td>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<div align="center">
					<footer>${requestScope.pagingHtml}</footer>
				</div>		
			</td>	
		</tr>				
	</table>	

<br><br>
	<script type="text/javascript">
	   /* 방금 전 선택한 콤보 박스를 그대로 보여 주기 */ 
		$('#mode option').each(function (index){
			if( $(this).val() == '${requestScope.mode}' ){
				$(this).attr('selected', 'selected') ;
			}
		});	
		/* 이전에 넣었던 값 그대로 보존 */
		$('#keyword').val( '${requestScope.keyword}' ) ;		
	</script>	

</body>
</html>