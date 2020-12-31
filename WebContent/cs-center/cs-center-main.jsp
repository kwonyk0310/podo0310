<%@ page language="java" contentType="text/html;charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int twelve = 12;
	int myoffset = 2;
	int mywidth = twelve - 2 * myoffset;
	int formleft = 3;
	int formright = twelve - formleft;
	int mysearch = 2;
	//int label = 3 ; //양식의 왼쪽에 보여지는 라벨의 너비 
	//int content = twelve - label ; //우측의 내용 입력(input, select, textarea)의 너비
%>
<!DOCTYPE html>
<html>
<head>
	<title>cs-center</title>
	<meta charset="UTF-8">
	<%@ include file="../common/nav.jsp" %>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$('#mode option').each(function (index){
			if ($(this).val() == '${requestScope.mode}') {
				$(this).attr('selected','selected') ;
			}
		});
		$('#keyword').val('${requestScope.keyword}') ;
	</script>
	<style type="text/css">
		.bold {
			font-weight: bold;
		}
	</style>
</head>
<body>
<div class="container mt-3">
  <h2 align="center">고객 센터</h2>
  <br>
  <!-- Nav tabs -->
  <ul class="nav nav-tabs">
    <li class="nav-item">
      <a class="nav-link active" data-toggle="tab" href="#home">공지사항</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" data-toggle="tab" href="#menu1">자주 묻는 질문</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" data-toggle="tab" href="#menu2">이용약관 및 방침</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" data-toggle="tab" href="#menu3">추가 문의</a>
    </li>
  </ul>
  <!-- Tab panes -->
  <div class="tab-content">
    <div id="home" class="container tab-pane active"><br>
      <table class="table table-striped table-hover">
			<thead>
				<tr>
					<td align="center">제목</td>
					<td align="right">작성 일자</td>
				</tr>
			</thead>
			<tr>
				<td colspan="2" align="center">
					<form action="<%=YesForm%>" class="form-inline" name="myform" method="get">
						<input type="hidden" name="command" value="cs-center-main">
						<div class="form-group">
							<select class="form-control" name="mode" id="mode">
								<option value="all" selected="selected">-- 선택하세요 --
								<option value="subject">제목
								<option value="content">글 내용
							</select>
						</div>
						<div class="form-group">
							<input type="text" class="form-control btn-xs" name="keyword"
								id="keyword" placeholder="검색 키워드">
						</div>
						<button class="btn btn-default btn-warning" type="submit" onclick="search();">검색</button>
						<button class="btn btn-default btn-warning" type="button" onclick="searchAll();">전체 검색</button>
						<button class="btn btn-default btn-warning" type="button"
							 onclick="writeForm();">글 쓰기</button> <!-- 운영자만 글 쓰기 가능으로 hidden처리해야함-->
							 <p class="form-control-static">${requestScope.pagingStatus}</p>
					</form>
				</td>
			</tr>
			<c:forEach var="bean" items="${requestScope.lists}">
				<tr>
					<td>
						<c:forEach var="cnt" begin="1" end="${bean.depth}">
							<span class="badge re">re</span>
						</c:forEach>
						<a href="<%=NoForm%>cs-detailView&no=${bean.no}&${requestScope.parameters}">
							${bean.subject}
						</a>
					</td>
					<td>${bean.writer}</td>
					<td>${bean.content}</td>
					<td>${bean.regdate}</td>
					<td>
						<c:if test="${sessionScope.loginfo.id == bean.writer}">
							<a href="<%=NoForm%>cs-update&no=${bean.no}&${requestScope.parameters}">
								수정
							</a>
						</c:if>
						<c:if test="${sessionScope.loginfo.id != bean.writer}">
								수정
						</c:if>
					</td>
					<td>
						<c:if test="${sessionScope.loginfo.id == bean.writer}">
							<a href="<%=NoForm %>cs-delete&no=${bean.no}&${requestScope.parameters}">
								삭제
							</a>
						</c:if>
						<c:if test="${sessionScope.loginfo.id != bean.writer}">
							삭제
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</table>
		<form class="form-horizontal" role="form" action="<%=YesForm%>"
			method="post">
			<input type="hidden" name="command" value="cs-center-insert">
			<div class="row">
				<div class="form-group col-sm-6">
					<label class="control-label col-sm-<%=formleft%>" for="writer">작성자</label>
					<div class="col-sm-12">
						<input type="text" class="form-control" name="fakewriter" id="fakewriter"
							placeholder="작성자" value="${sessionScope.loginfo.name}(${sessionScope.loginfo.id})" disabled="disabled">
						<input type="hidden" name="writer" id="writer"
							value="${sessionScope.loginfo.id}">
					</div>
					<label class="control-label col-sm-12" for="subject">
					</label>
					<div class="col-sm-12">
						<input type="text" class="form-control" name="subject"
							id="subject" placeholder="글 제목" value="${bean.subject}"> 
						<span class="err">${errsubject}</span>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-<%=formleft%>"
							for="image"></label>
						<div class="col-sm-<%=formright%>">
							<input type="file" class="form-control" name="image"
								id="image" placeholder="이미지를 넣어 주셔용^^"><span
								class="err form-control-static">${errimage}</span>
						</div>
					</div>
					<label class="control-label col-sm-<%=formleft%>" for="regdate">
					</label>
				<%-- 	<div class="col-sm-12">
						<input type="datetime" class="form-control" name="regdate"
							id="regdate" placeholder="작성 일자" value="${bean.regdate}"> <span
							class="err">${errregdate}</span>
					</div> --%>
				</div>
				<div class="form-group col-sm-6">
					<label class="control-label col-sm-12" for="content">
					</label>
					<div class="col-sm-12">
						<textarea name="content" id="content" rows="5" cols=""
							placeholder="글 내용" class="form-control">${bean.content}</textarea>
						<span class="err">${errcontent}</span>
					</div><br>
					<div align="center" class="col-sm-offset-3 col-sm-12 row">
						<div class="col-sm-6">
							<button class="btn btn-outline-primary" type="submit">글 등록</button>
						</div>
						<div class="col-sm-6">
							<button class="btn btn-outline-danger" type="reset">취소</button>
						</div>
					</div>
				</div>
			</div>
			<%-- <div class="form-group">
				<label class="control-label col-sm-<%=formleft%>" for="password">비밀
					번호</label>
				<div class="col-sm-<%=formright%>">
					<input type="password" class="form-control" name="password"
						id="password" placeholder="비밀 번호를 넣어 주셔용^^" value="${bean.password}">
						<span class="err">${errpassword}</span>
				</div>
			</div> --%>
		</form>
    </div>
    <div id="menu1" class="container tab-pane fade"><br>
      <table class="table table-striped table-hover">
			<thead>
				<tr>
					<td align="center">제목</td>
					<td align="right">작성 일자</td>
				</tr>
			</thead>
			<tr>
				<td colspan="2" align="center">
					<form action="<%=YesForm%>" class="form-inline" name="myform" method="get">
						<input type="hidden" name="command" value="cs-center-main">
						<div class="form-group">
							<select class="form-control" name="mode" id="mode">
								<option value="all" selected="selected">-- 선택하세요 --
								<option value="subject">제목
								<option value="content">글 내용
							</select>
						</div>
						<div class="form-group">
							<input type="text" class="form-control btn-xs" name="keyword"
								id="keyword" placeholder="검색 키워드">
						</div>
						<button class="btn btn-default btn-warning" type="submit" onclick="search();">검색</button>
						<button class="btn btn-default btn-warning" type="button" onclick="searchAll();">전체 검색</button>
						<button class="btn btn-default btn-warning" type="button"
							 onclick="writeForm();">글 쓰기</button> <!-- 운영자만 글 쓰기 가능으로 hidden처리해야함-->
							 <p class="form-control-static">${requestScope.pagingStatus}</p>
					</form>
				</td>
			</tr>
			<c:forEach var="bean" items="${requestScope.lists}">
				<tr>
					<td>
						<c:forEach var="cnt" begin="1" end="${bean.depth}">
							<span class="badge re">re</span>
						</c:forEach>
						<a href="<%=NoForm%>cs-detailView&no=${bean.no}&${requestScope.parameters}">
							${bean.subject}
						</a>
					</td>
					<td>${bean.writer}</td>
					<td>${bean.content}</td>
					<td>${bean.regdate}</td>
					<td>
						<c:if test="${sessionScope.loginfo.id == bean.writer}">
							<a href="<%=NoForm%>cs-update&no=${bean.no}&${requestScope.parameters}">
								수정
							</a>
						</c:if>
						<c:if test="${sessionScope.loginfo.id != bean.writer}">
								수정
						</c:if>
					</td>
					<td>
						<c:if test="${sessionScope.loginfo.id == bean.writer}">
							<a href="<%=NoForm %>cs-delete&no=${bean.no}&${requestScope.parameters}">
								삭제
							</a>
						</c:if>
						<c:if test="${sessionScope.loginfo.id != bean.writer}">
							삭제
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</table>
		<form class="form-horizontal" role="form" action="<%=YesForm%>"
			method="post">
			<input type="hidden" name="command" value="cs-center-insert">
			<div class="row">
				<div class="form-group col-sm-6">
					<label class="control-label col-sm-<%=formleft%>" for="writer">작성자</label>
					<div class="col-sm-12">
						<input type="text" class="form-control" name="fakewriter" id="fakewriter"
							placeholder="작성자" value="${sessionScope.loginfo.name}(${sessionScope.loginfo.id})" disabled="disabled">
						<input type="hidden" name="writer" id="writer"
							value="${sessionScope.loginfo.id}">
					</div>
					<label class="control-label col-sm-12" for="subject">
					</label>
					<div class="col-sm-12">
						<input type="text" class="form-control" name="subject"
							id="subject" placeholder="글 제목" value="${bean.subject}"> 
						<span class="err">${errsubject}</span>
					</div>
					<div class="form-group">
						<label class="control-label col-sm-<%=formleft%>"
							for="image"></label>
						<div class="col-sm-<%=formright%>">
							<input type="file" class="form-control" name="image"
								id="image" placeholder="이미지를 넣어 주셔용^^"><span
								class="err form-control-static">${errimage}</span>
						</div>
					</div>
					<label class="control-label col-sm-<%=formleft%>" for="regdate">
					</label>
				</div>
				<div class="form-group col-sm-6">
					<label class="control-label col-sm-12" for="content">
					</label>
					<div class="col-sm-12">
						<textarea name="content" id="content" rows="5" cols=""
							placeholder="글 내용" class="form-control">${bean.content}</textarea>
						<span class="err">${errcontent}</span>
					</div><br>
					<div align="center" class="col-sm-offset-3 col-sm-12 row">
						<div class="col-sm-6">
							<button class="btn btn-outline-primary" type="submit">글 등록</button>
						</div>
						<div class="col-sm-6">
							<button class="btn btn-outline-danger" type="reset">취소</button>
						</div>
					</div>
				</div>
			</div>
		</form>
    </div>
    <div id="menu2" class="container tab-pane fade"><br>
      <h3 align="center">이용약관 및 방침</h3>
      <table border="1">
			<tr class="terms-wrapper">
				<td><span class="bold">제1조(목적)</span> 이 약관은 (주)도담도담
					회사(사업자등록번호 : 759-87-00821, 통신판매업신고번호 : 제2020-서울강남-03029호, 대표자 :
					1조도담도담)가 운영하는 온라인 웹사이트 도담도담 및 모바일 어플리케이션 도담도담케어(이하 두 서비스를 통칭하여
					“도담도담”라 함)에서 제공하는 전자상거래 관련 서비스(이하 “서비스”라 한다.)를 이용함에 있어 도담도담와 이용자의
					권리, 의무 및 책임사항을 규정함을 목적으로 합니다. *PC통신, 스마트폰 앱, 무선 등을 이용하는 전자상거래에
					대해서도 그 성질에 반하지 않는 한 준용합니다. <span class="bold">제2조(정의)
				</span> ① “도담도담"란 (주)케어위드 회사가 재화 또는 용역(이하 “재화 등"이라 함)을 이용자에게 제공하기 위하여 컴퓨터
					등 정보통신설비를 이용하여 재화 등을 거래할 수 있도록 설정한 가상의 영업장 및 그에 부수되는 콘텐츠 서비스를
					말하며, 아울러 서비스를 운영하는 사업자의 의미로도 사용합니다. ② “이용자"란 “도담도담"에 접속하여 이 약관에
					따라 “도담도담"가 제공하는 서비스를 받는 회원 및 비회원을 말합니다. ③ “회원"이라 함은 “도담도담"에 회원등록을
					한 자로서, 계속적으로 “도담도담"가 제공하는 서비스를 이용할 수 있는 자를 말합니다. ④ “비회원"이라 함은
					회원으로 가입하지 않고 “도담도담"가 제공하는 서비스를 이용하는 자를 말합니다. <span class="bold">제3조
						(약관 등의 명시와 설명 및 개정) </span> ① “도담도담”는 이 약관의 내용과 상호 및 대표자 성명, 영업소 소재지
					주소(소비자의 불만을 처리할 수 있는 곳의 주소를 포함), 전화번호, 모사전송번호, 전자우편주소, 사업자등록번호,
					통신판매업 신고번호, 개인정보관리책임자등을 이용자가 쉽게 알 수 있도록 도담도담의 초기 서비스화면(전면)에
					게시합니다. 다만, 약관의 내용은 이용자가 연결화면을 통하여 볼 수 있도록 할 수 있습니다. ② “도담도담"는
					이용자가 약관에 동의하기에 앞서 약관에 정하여져 있는 내용 중 청약철회, 배송책임, 환불조건 등과 같은 중요한 내용을
					이용자가 이해할 수 있도록 별도의 연결화면 또는 팝업화면 등을 제공하여 이용자의 확인을 구하여야 합니다. ③
					“도담도담”는「전자상거래 등에서의 소비자보호에 관한 법률」, 「약관의 규제에 관한 법률」, 「전자문서 및
					전자거래기본법」, 「전자금융거래법」, 「전자서명법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「방문판매
					등에 관한 법률」, 「소비자기본법」 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다. ④
					“도담도담”가 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 함께 몰의 초기화면에 그 적용일자
					7일 이전부터 적용일자 전일까지 공지합니다. 다만, 이용자에게 불리하게 약관내용을 변경하는 경우에는 최소한 30일
					이상의 사전 유예기간을 두고 공지합니다. 이 경우 "도담도담“는 개정 전 내용과 개정 후 내용을 명확하게 비교하여
					이용자가 알기 쉽도록 표시합니다. ⑤ “도담도담”가 약관을 개정할 경우에는 그 개정약관은 그 적용일자 이후에 체결되는
					계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정 전의 약관조항이 그대로 적용됩니다. 다만 이미 계약을
					체결한 이용자가 개정약관 조항의 적용을 받기를 원하는 뜻을 제3항에 의한 개정약관의 공지기간 내에 “도담도담”에
					송신하여 “도담도담”의 동의를 받은 경우에는 개정약관 조항이 적용됩니다. ⑥ 이 약관에서 정하지 아니한 사항과 이
					약관의 해석에 관하여는 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제 등에 관한 법률, 공정거래위원회가
					정하는 전자상거래 등에서의 소비자 보호지침 및 관계법령 또는 상관례에 따릅니다. <span class="bold">제4조(서비스의
						제공 및 변경) </span> ① “도담도담”는 다음과 같은 서비스를 제공합니다. <span class="depth2">1.
						재화 또는 용역에 대한 정보 제공 및 구매계약의 체결 </span> <span class="depth2">2.
						구매계약이 체결된 재화 또는 용역의 배송</span> <span class="depth2">3. 이용자의
						“도담도담” 서비스 이용에 도움이 되는 알람 및 콘텐츠 제공 </span> <span class="depth2">4.
						기타 “도담도담”가 정하는 업무 </span> ② “도담도담”가 제공하는 재화 또는 용역 서비스는 비의료 건강관리서비스로서
					질환의 치료 목적의 서비스가 아닌 보조적 건강관리 서비스입니다. 특히 만성질환자의 경우 본 서비스 이용대상자가 아니며
					의사 또는 의료기관의 도움을 받으시기를 권고 드립니다. ③ “도담도담”는 재화 또는 용역의 품절 또는 기술적 사양의
					변경 등의 경우에는 장차 체결되는 계약에 의해 제공할 재화 또는 용역의 내용을 변경할 수 있습니다. 이 경우에는
					변경된 재화 또는 용역의 내용 및 제공일자를 명시하여 현재의 재화 또는 용역의 내용을 게시한 곳에 즉시 공지합니다.
					④ “도담도담”가 제공하기로 이용자와 계약을 체결한 서비스의 내용을 재화등의 품절 또는 기술적 사양의 변경 등의
					사유로 변경할 경우에는 그 사유를 이용자에게 통지 가능한 주소로 즉시 통지합니다. ⑤ 전항의 경우 “도담도담”는 이로
					인하여 이용자가 입은 손해를 배상합니다. 다만, “도담도담”가 고의 또는 과실이 없음을 입증하는 경우에는 그러하지
					아니합니다. <span class="bold">제5조(서비스의 중단) </span> ① “도담도담”는
					연중무휴, 1일 24시간 제공을 원칙으로 합니다. 단, 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장, 통신의
					두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다. ② “도담도담”는 제1항의 사유로
					서비스의 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 배상합니다. 단, “도담도담”가
					고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다. ③ 사업종목의 전환, 사업의 포기, 업체 간의 통합
					등의 이유로 서비스를 제공할 수 없게 되는 경우에는 “도담도담”는 제8조에 정한 방법으로 이용자에게 통지하고 당초
					“도담도담”에서 제시한 조건에 따라 소비자에게 보상합니다. 다만, “도담도담”가 보상기준 등을 고지하지 아니한
					경우에는 이용자들의 포인트 또는 적립금 등을 “도담도담”에서 통용되는 통화가치에 상응하는 현물 또는 현금으로
					이용자에게 지급합니다. ④ 제3항에도 불구하고 “도담도담”가 이용자에게 사전에 통지할 수 없는 부득이한 사유가 있는
					경우 사후에 통지할 수 있습니다. <span class="bold">제6조(회원가입) </span> ① 이용자는
					“도담도담”가 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을
					신청합니다. ② “도담도담”는 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각 호에 해당하지 않는 한
					회원으로 등록합니다. <span class="depth2">1. 가입신청자가 이 약관 제7조제3항에
						의하여 이전에 회원자격을 상실한 적이 있는 경우, 다만 제7조제3항에 의한 회원자격 상실 후 3년이 경과한 자로서
						“도담도담”의 회원재가입 승낙을 얻은 경우에는 예외로 함.</span> <span class="depth2">2.
						등록 내용에 허위, 기재누락, 오기가 있는 경우 </span> <span class="depth2">3. 기타
						회원으로 등록하는 것이 “도담도담”의 기술상 현저히 지장이 있다고 판단되는 경우 </span> <span
					class="depth2">4. 회원가입 및 전자상거래상의 계약에 관한 서비스는 만 14세 이상인자에
						한함 </span> ③ 회원가입계약의 성립 시기는 “도담도담”의 승낙이 회원에게 도달한 시점으로 합니다. ④ 회원은 회원가입 시
					등록한 사항에 변경이 있는 경우, 상당한 기간 이내에 “도담도담”에 대하여 회원정보 수정 등의 방법으로 그 변경사항을
					알려야 합니다. <span class="bold">제7조(회원 탈퇴 및 자격 상실 등) </span> ① 회원은
					“도담도담”에 언제든지 탈퇴를 요청할 수 있으며 “도담도담”는 즉시 회원탈퇴를 처리합니다. ② 회원이 다음 각 호의
					사유에 해당하는 경우, “도담도담”는 회원자격을 제한 및 정지시킬 수 있습니다. <span class="depth2">1.
						가입 신청 시에 허위 내용을 등록한 경우 </span> <span class="depth2">2. “도담도담”를
						이용하여 구입한 재화 등의 대금, 기타 “도담도담”이용에 관련하여 회원이 부담하는 채무를 기일에 지급하지 않는 경우
				</span> <span class="depth2">3. 다른 사람의 “도담도담” 이용을 방해하거나 그 정보를 도용하는
						등 전자상거래 질서를 위협하는 경우 </span> <span class="depth2">4. “도담도담”를 이용하여
						법령 또는 이 약관이 금지하거나 공서양속에 반하는 행위를 하는 경우 </span> ③ “도담도담”가 회원 자격을 제한․정지 시킨
					후, 동일한 행위가 2회 이상 반복되거나 30일 이내에 그 사유가 시정되지 아니하는 경우 “도담도담”는 회원자격을
					상실시킬 수 있습니다. ④ “도담도담”가 회원자격을 상실시키는 경우에는 회원등록을 말소합니다. 이 경우 회원에게 이를
					통지하고, 회원등록 말소 전에 최소한 30일 이상의 기간을 정하여 소명할 기회를 부여합니다. <span
					class="bold">제8조(회원에 대한 통지) </span> ① “도담도담”가 회원에 대한 통지를
					하는 경우, 회원이 “도담도담”와 미리 약정하여 지정한 전자우편 주소로 할 수 있습니다. ② “도담도담”는 불특정다수
					회원에 대한 통지의 경우 1주일이상 “도담도담” 게시판에 게시함으로서 개별 통지에 갈음할 수 있습니다. 다만, 회원
					본인의 거래와 관련하여 중대한 영향을 미치는 사항에 대하여는 개별통지를 합니다. <span class="bold">제9조(구매신청)
				</span> “도담도담”이용자는 “도담도담”상에서 다음 또는 이와 유사한 방법에 의하여 구매를 신청하며, “도담도담”는 이용자가
					구매신청을 함에 있어서 다음의 각 내용을 알기 쉽게 제공하여야 합니다. <span class="depth2">1.
						재화 등의 검색 및 선택 </span> <span class="depth2">2. 받는 사람의 성명, 주소,
						전화번호, 전자우편주소(또는 이동전화번호) 등의 입력 </span> <span class="depth2">3.
						약관내용, 청약철회권이 제한되는 서비스, 배송료 등의 비용부담과 관련한 내용에 대한 확인 </span> <span
					class="depth2">4. 이 약관에 동의하고 위 3.호의 사항을 확인하거나 거부하는 표시(예,
						마우스 클릭) </span> <span class="depth2">5. 재화등의 구매신청 및 이에 관한 확인 또는
						“도담도담”의 확인에 대한 동의 </span> <span class="depth2">6. 결제방법의 선택 </span> <span
					class="bold">제10조 (계약의 성립) </span> ① “도담도담”는 제9조와 같은 구매신청에 대하여 다음
					각 호에 해당하면 승낙하지 않을 수 있습니다. 다만, 미성년자와 계약을 체결하는 경우에는 법정대리인의 동의를 얻지
					못하면 미성년자 본인 또는 법정대리인이 계약을 취소할 수 있다는 내용을 고지하여야 합니다. <span
					class="depth2">1. 신청 내용에 허위, 기재누락, 오기가 있는 경우 </span> <span
					class="depth2">2. 미성년자가 담배, 주류 등 청소년보호법에서 금지하는 재화 및 용역을
						구매하는 경우 </span> <span class="depth2">3. 기타 구매신청에 승낙하는 것이 “도담도담”
						기술상 현저히 지장이 있다고 판단하는 경우 </span> ② “도담도담”의 승낙이 제13조 제1항의 수신확인통지형태로 이용자에게
					도달한 시점에 계약이 성립한 것으로 봅니다. ③ “도담도담”의 승낙의 의사표시에는 이용자의 구매 신청에 대한 확인 및
					판매가능 여부, 구매신청의 정정 취소 등에 관한 정보 등을 포함하여야 합니다. <span class="bold">제11조(지급방법)
				</span> “도담도담”에서 구매한 재화 또는 용역에 대한 대금지급방법은 다음 각 호의 방법중 가용한 방법으로 할 수 있습니다.
					단, “도담도담”는 이용자의 지급방법에 대하여 재화 등의 대금에 어떠한 명목의 수수료도 추가하여 징수할 수 없습니다.
					① 폰뱅킹, 인터넷뱅킹, 메일 뱅킹 등의 각종 계좌이체 ② 선불카드, 직불카드, 신용카드 등의 각종 카드의 비인증식
					정기결제 ③ 선불카드, 직불카드, 신용카드 등의 각종 카드의 인증식 일반결제 ④ 온라인무통장입금 ⑤ 포인트 등
					“도담도담”가 지급한 적립금에 의한 결제 (단, 정기구매의 경우 최초 구매 신청시 1회 사용 가능) ⑥ “도담도담"와
					계약을 맺었거나 “도담도담"가 인증한 상품권에 의한 결제 ⑦ 기타 전자적 지급 방법에 의한 대금 지급 등 (각종 간편
					결제 서비스) <span class="bold">제12조(프로모션코드) </span> ① 프로모션코드는 회원에게
					무상으로 발행되는 것으로 “도담도담"는 회원이 프로모션코드를 사이트에서 상품 구매 시 적용할 수 있도록 사용방법,
					사용기간, 사용대상, 할인액 또는 할인율 등을 정할 수 있습니다. 프로모션코드의 종류와 내용은 “도담도담"의 정책에
					따라 달라질 수 있습니다. ② 프로모션코드는 현금으로 환급될 수 없으며, 프로모션코드의 사용기간이 만료되거나 구매
					취소 시 또는 이용계약이 종료되면 소멸됩니다. ③ “회원”은 허락되지 않은 방법으로 프로모션코드를 제3자에게 또는
					다른 아이디로 양도할 수 없으며, 유상으로 거래하거나 현금으로 전환할 수 없습니다. ④ “도담도담”는 회원이
					“도담도담”가 승인하지 않은 방법으로 프로모션코드를 획득하거나 부정한 목적이나 용도로 프로모션코드를 사용하는 경우
					프로모션코드의 사용을 제한하거나 프로모션코드를 사용한 구매신청을 취소하거나 회원 자격을 정지할 수 있습니다. ⑤
					“도담도담”는 “회원"이 사용한 프로모션코드와 동일한 프로모션코드로 재구매 시 해당 프로모션코드 적용을 하지 않을 수
					있습니다. <span class="bold">제13조(수신확인통지, 구매신청 변경 및 취소) </span> ①
					“도담도담”는 이용자의 구매신청이 있는 경우 이용자에게 수신확인통지를 합니다. ② 수신확인통지를 받은 이용자는
					의사표시의 불일치 등이 있는 경우에는 수신확인통지를 받은 후 즉시 구매신청 변경 및 취소를 요청할 수 있고
					“도담도담”는 배송 전에 이용자의 요청이 있는 경우에는 지체 없이 그 요청에 따라 처리하여야 합니다. 다만 이미
					대금을 지불한 경우에는 제16조의 청약철회 등에 관한 규정에 따릅니다. <span class="bold">제14조(재화
						등의 공급) </span> ① “도담도담”는 이용자와 재화 등의 공급시기에 관하여 별도의 약정이 없는 이상, 이용자가 청약을 한
					날부터 7일 이내에 재화 등을 배송할 수 있도록 주문제작, 포장 등 기타의 필요한 조치를 취합니다. 다만,
					“도담도담”가 이미 재화 등의 대금의 전부 또는 일부를 받은 경우에는 대금의 전부 또는 일부를 받은 날부터 3영업일
					이내에 조치를 취합니다. 이때 “도담도담”는 이용자가 재화 등의 공급 절차 및 진행 사항을 확인할 수 있도록 적절한
					조치를 합니다. ② “도담도담”는 이용자가 구매한 재화에 대해 배송수단, 수단별 배송비용 부담자, 수단별 배송기간
					등을 명시합니다. 만약 “도담도담”가 약정 배송기간을 초과한 경우에는 그로 인한 이용자의 손해를 배상하여야 합니다.
					다만 “도담도담”가 고의․과실이 없음을 입증한 경우에는 그러하지 아니합니다. ③ 이용자는 “도담도담”가 지정하는 일부
					서비스 항목 또는 “도담도담”가 지정한 기한에 한하여 회원가입 없이 무상으로 서비스를 이용할 수 있습니다. <span
					class="bold">제15조(적립금 제도의 운영) </span> ① “도담도담”는 회원이 정기구매서비스를 이용하여
					재화를 구매하거나 이벤트에 참여하는 등의 일정한 경우 적립금으로서 포인트를 부여할 수 있습니다. 이러한 포인트의
					부여는 다음 각 호의 방법에 따르되, 그 구체적인 운영방법은 회사의 운영정책에 따릅니다. <span
					class="depth2">1. “도담도담”는 회원의 결제금액에 대하여 서비스 페이지에 고지한 특정한
						비율만큼 포인트를 부여할 수 있습니다. 단, 이 경우 적립대상금액은 쿠폰, 프로모션 등 기타 방법을 통해 할인 받은
						금액은 제외됩니다.</span> <span class="depth2">2. “도담도담”는 회원이 서비스나 이벤트
						등에 참여할 경우 포인트를 부여할 수 있습니다.</span> <span class="depth2">3.
						“도담도담”에서 회원이 구매한 재화를 반품하였을 때 해당 구매로 적립된 포인트는 환수됩니다.</span> ② 포인트는
					“도담도담”의 서비스 제도로서 “도담도담”가 회원에게 사전 고지한 조건 및 비율에 따라 “도담도담”의 포인트몰에서
					특정 재화로 교환이 가능합니다. 단, 포인트는 사은의 형태로 “도담도담”에서 지급하는 것으로 현금으로 환불되지는
					않으며 타인에게 양도할 수 없습니다. ③ 포인트의 사용기한은 최초 적립일로부터 1년이며, 기한내 사용하지 않은
					포인트는 소멸됩니다. 단일상품의 구매로 인하여 일시에 부여된 포인트에 대해서 그 중 일부만을 사용한 경우에도
					동일합니다. 단, 포인트 부여시 적립금 사용기간에 대해 별도의 사전 고지 또는 특약이 있는 경우에는 그 사용기간
					이내에 사용하여야 합니다. ④ 다음의 경우 포인트가 소멸됩니다. <span class="depth2">1.
						회원을 탈퇴한 경우</span> <span class="depth2">2. 사용기간이 경과한 경우</span> <span
					class="depth2">3. 사용가능 조건 및 소멸에 대한 내용이 별도로 공지된 경우</span> ⑤ 포인트를
					이용하여 부당 이득을 취하거나, 악의적인 상거래가 발생할 경우, “도담도담”는 포인트에 대해 지급을 중지하며 기지급된
					포인트를 환수할 수 있습니다. <span class="bold">제16조(환급) </span> “도담도담”는 이용자가
					구매신청한 재화 등이 품절 등의 사유로 인도 또는 제공을 할 수 없을 때에는 지체 없이 그 사유를 이용자에게 통지하고
					사전에 재화 등의 대금을 받은 경우에는 대금을 받은 날부터 3영업일 이내에 환급하거나 환급에 필요한 조치를 취합니다.
					<span class="bold">제17조(청약철회 등) </span> ① “도담도담”와 재화등의 구매에 관한 계약을
					체결한 이용자는 「전자상거래 등에서의 소비자보호에 관한 법률」 제13조 제2항에 따른 계약내용에 관한 서면을 받은
					날(그 서면을 받은 때보다 재화 등의 공급이 늦게 이루어진 경우에는 재화 등을 공급받거나 재화 등의 공급이 시작된
					날을 말합니다)부터 7일 이내에는 청약의 철회를 할 수 있습니다. 다만, 청약철회에 관하여 「전자상거래 등에서의
					소비자보호에 관한 법률」에 달리 정함이 있는 경우에는 동 법 규정에 따릅니다. ② 이용자는 재화 등을 배송 받은 경우
					다음 각 호의 1에 해당하는 경우에는 반품 및 교환을 할 수 없습니다. <span class="depth2">1.
						이용자에게 책임 있는 사유로 재화 등이 멸실 또는 훼손된 경우 (다만, 재화 등의 내용을 확인하기 위하여 포장 등을
						훼손한 경우에는 청약철회를 할 수 있습니다) </span> <span class="depth2">2. 이용자의 사용
						또는 일부 소비에 의하여 재화 등의 가치가 현저히 감소한 경우 </span> <span class="depth2">3.
						시간의 경과에 의하여 재판매가 곤란할 정도로 재화등의 가치가 현저히 감소한 경우 </span> <span
					class="depth2">4. 같은 성능을 지닌 재화 등으로 복제가 가능한 경우 그 원본인 재화 등의
						포장을 훼손한 경우 </span> ③ 제2항제2호 내지 제4호의 경우에 “도담도담”가 사전에 청약철회 등이 제한되는 사실을
					소비자가 쉽게 알 수 있는 곳에 명기하거나 시용상품을 제공하는 등의 조치를 하지 않았다면 이용자의 청약철회 등이
					제한되지 않습니다. ④ 이용자는 제1항 및 제2항의 규정에 불구하고 재화 등의 내용이 표시•광고 내용과 다르거나
					계약내용과 다르게 이행된 때에는 당해 재화 등을 공급받은 날부터 3월 이내, 그 사실을 안 날 또는 알 수 있었던
					날부터 30일 이내에 청약철회 등을 할 수 있습니다. <span class="bold">제18조(청약철회
						등의 효과) </span> ① “도담도담”는 이용자로부터 재화 등을 반환받은 경우 3영업일 이내에 이미 지급받은 재화 등의
					대금을 환급합니다. 이 경우 “도담도담”가 이용자에게 재화등의 환급을 지연한 때에는 그 지연기간에 대하여 「전자상거래
					등에서의 소비자보호에 관한 법률 시행령」제21조의2에서 정하는 지연이자율(괄호 부분 삭제)을 곱하여 산정한 지연이자를
					지급합니다. ② “도담도담”는 위 대금을 환급함에 있어서 이용자가 신용카드 또는 전자화폐 등의 결제수단으로 재화 등의
					대금을 지급한 때에는 지체 없이 당해 결제수단을 제공한 사업자로 하여금 재화 등의 대금의 청구를 정지 또는 취소하도록
					요청합니다. ③ 청약철회 등의 경우 공급받은 재화 등의 반환에 필요한 비용은 이용자가 부담합니다. “도담도담”는
					이용자에게 청약철회 등을 이유로 위약금 또는 손해배상을 청구하지 않습니다. 다만 재화 등의 내용이 표시•광고 내용과
					다르거나 계약내용과 다르게 이행되어 청약철회 등을 하는 경우 재화 등의 반환에 필요한 비용은 “도담도담”가
					부담합니다. ④ 이용자가 재화 등을 제공받을 때 발송비를 부담한 경우에 “도담도담”는 청약철회 시 그 비용을 누가
					부담하는지를 이용자가 알기 쉽도록 명확하게 표시합니다. <span class="bold">제19조(“도담도담“의
						의무) </span> ① “도담도담”는 법령과 이 약관이 금지하거나 공서양속에 반하는 행위를 하지 않으며 이 약관이 정하는 바에
					따라 지속적이고, 안정적으로 재화․용역을 제공하는데 최선을 다하여야 합니다. ② “도담도담”는 이용자가 안전하게
					인터넷 서비스를 이용할 수 있도록 이용자의 개인정보(신용정보 포함)보호를 위한 보안 시스템을 갖추어야 합니다. ③
					“도담도담”가 상품이나 용역에 대하여 「표시․광고의 공정화에 관한 법률」 제3조 소정의 부당한 표시․광고행위를
					함으로써 이용자가 손해를 입은 때에는 이를 배상할 책임을 집니다. ④ “도담도담”는 이용자가 원하지 않는 영리목적의
					광고성 전자우편을 발송하지 않습니다. <span class="bold">제20조(회원의 ID 및
						비밀번호에 대한 의무) </span> ① ID와 비밀번호에 관한 관리책임은 회원에게 있으며, 어떠한 경우에도 본인의 ID 또는
					비밀번호를 양도하거나 대여할 수 없습니다. ② 회원은 자신의 ID 및 비밀번호를 제3자에게 이용하게 해서는 안되며,
					“도담도담”의 귀책사유 없이 이를 유출, 양도, 대여한 행위로 인하여 발생하는 손실이나 손해에 대하여는 회원 본인이
					그에 대한 책임을 부담합니다. ③ 회원이 자신의 ID 및 비밀번호를 도난당하거나 제3자가 사용하고 있음을 인지한
					경우에는 바로 “도담도담”에 통보하고 “도담도담”의 안내가 있는 경우에는 그에 따라야 합니다. <span
					class="bold">제21조(이용자의 의무) </span> 이용자는 다음 행위를 하여서는 안 됩니다.
					<span class="depth2">1. 신청 또는 변경 시 허위 내용의 등록 </span> <span
					class="depth2">2. 타인의 정보 도용 </span> <span class="depth2">3.
						“도담도담”에 게시된 정보의 변경 </span> <span class="depth2">4. “도담도담”가 정한 정보
						이외의 정보(컴퓨터 프로그램 등) 등의 송신 또는 게시 </span> <span class="depth2">5.
						“도담도담” 기타 제3자의 저작권 등 지적재산권에 대한 침해 </span> <span class="depth2">6.
						“도담도담” 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위 </span> <span class="depth2">7.
						외설 또는 폭력적인 메시지, 화상, 음성, 기타 공서양속에 반하는 정보를 몰에 공개 또는 게시하는 행위 </span> <span
					class="bold">제22조(정기구매서비스 제공 및 이용자격) </span> ① 정기구매서비스는 “도담도담"
					회원의 편의를 위하여 상품을 정기적으로 결제하고 배송하는 서비스입니다. ② 정기구매서비스는 “도담도담"회원이면 누구나
					정기구매서비스를 신청함으로써 이용 가능합니다. <span class="bold">제23조(정기구매서비스
						상품의 결제 등) </span> ① “도담도담"는 정기구매서비스 상품에 대하여 할인혜택을 제공할 수 있으며, 할인율 및 거래조건
					등은 상품별로 다를 수 있고 변경될 수 있습니다. 할인율 및 거래조건 등이 회원에게 불리하게 변경되는 경우
					“도담도담"는 2주 이상의 상당한 기간 동안 위 변경에 대하여 공지하고, 회원은 위 변경에 동의하지 않으면 위 기간
					동안 본 서비스를 종료시킬 수 있으며, 위 기간 동안 서비스를 종료시키지 않으면 위 변경에 회원이 동의한 것으로
					봅니다. ② 정기구매서비스의 특성상 상품의 가격은 계속적으로 변경될 수 있으며, 회원에게 고지된 시점의 상품가격을
					기준으로 결제가 이루어집니다. 가격 결정의 기준 시점은 변경될 수 있습니다. ③ 정기구매서비스 상품의 추가 또는 변경
					시 결제되는 총 상품의 금액은 변경될 수 있습니다. ④ 카드한도 초과 등 상품의 결제가 이루어지지 않을 경우, 해당
					회차의 정기구매 주문은 이루어지지 않을 수 있으며, 위와 같은 상황이 2회 이상 지속되는 경우 “도담도담"는
					정기구매서비스를 중지할 수 있습니다. <span class="bold">제24조(정기구매서비스 상품의
						판매 종료 등) </span> ① 정기구매서비스의 대상 상품을 품절 등의 사유로 더 이상 판매할 수 없거나 해당 상품을
					정기구매서비스로 제공할 수 없는 사유가 있는 경우, “도담도담"는 해당 상품의 정기구매서비스를 종료하거나 해당 회차의
					상품을 공급하지 않을 수 있습니다. ② 재화 등의 대금을 환급하여야 하는 경우 제16조에서 정한 사항에 따릅니다. <span
					class="bold">제25조(정기구매서비스의 종료) </span> ① 회원이 “도담도담"에게 정기구매서비스의
					종료를 통지하거나, “도담도담"의 마이페이지에서 해지 신청함으로써 정기구매서비스를 종료시킬 수 있습니다. ②
					정기구매서비스가 종료된 경우 해당 정기구매서비스에 적용된 프로모션코드와 장기구매고객할인 등 각종 혜택은 동시에
					종료됩니다. <span class="bold">제26조(정기구매서비스 이용의 제한) </span> ① 회원의 통지
					또는 과실에 의해서 정기구매서비스가 중지되는 경우, 해당 상품의 정기구매 서비스 신청이 2개월의 범위 내에서 제한될
					수 있습니다. ② “도담도담"는 특정상품에 대하여 구매 수량을 제한할 수 있습니다. ③ “도담도담"는 상품의 재판매
					가능성이 있는 경우, 또는 불법적이거나 부당한 행위와 관련된 경우 정기구매서비스 제공을 제한할 수 있습니다. ④
					서비스 이용의 제한에 대한 구체적인 기준은 내부 운영정책에 따라 적용됩니다. ⑤ “도담도담"는 자체적인 시스템을 통해
					모니터링과 각종 기관에서 접수된 민원 내용, 수사기관의 정보 등을 통해 정황을 확인한 후 정기구매서비스 제한
					사유행위를 한 것으로 추정되는 경우 정기구매서비스 이용을 제한할 수 있습니다. <span class="bold">제27조(저작권의
						귀속 및 이용제한) </span> ① “도담도담“가 작성한 저작물에 대한 저작권 기타 지적재산권은 "도담도담"에 귀속합니다. ②
					이용자는 “도담도담”를 이용함으로써 얻은 정보 중 “도담도담”에게 지적재산권이 귀속된 정보를 “도담도담”의 사전 승낙
					없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는
					안됩니다. ③ “도담도담”는 약정에 따라 이용자에게 귀속된 저작권을 사용하는 경우 당해 이용자에게 통보하여야 합니다.
					<span class="bold">제28조(면책조항) </span> ① “도담도담”는 천재지변 또는 이에
					준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다. ② “도담도담”는
					의 귀책사유로 인한 서비스 이용의 장애에 대하여 책임을 지지 않습니다. ③ “도담도담”는 회원이 서비스를 이용하여
					기대하는 수익을 상실한 것에 대하여 책임을 지지 않으며, 그 밖의 서비스를 통하여 얻은 자료로 인한 손해에 관하여
					책임을 지지 않습니다. ④ “도담도담”는 회원이 게재한 정보, 자료, 사실의 신뢰도, 정확성 등 내용에 관해서는
					책임을 지지 않습니다. ⑤ “도담도담”는 회원 간 또는 회원과 제3자 상호간에 서비스를 매개로 하여 거래 등을 한
					경우에는 책임을 지지 않습니다. <span class="bold">제29조(분쟁해결) </span> ① “도담도담”는
					이용자가 제기하는 정당한 의견이나 불만을 반영하고 그 피해를 보상처리하기 위하여 피해보상처리기구를 설치․운영합니다.
					② “도담도담”는 이용자로부터 제출되는 불만사항 및 의견은 우선적으로 그 사항을 처리합니다. 다만, 신속한 처리가
					곤란한 경우에는 이용자에게 그 사유와 처리일정을 즉시 통보해 드립니다. ③ “도담도담”와 이용자 간에 발생한
					전자상거래 분쟁과 관련하여 이용자의 피해구제신청이 있는 경우에는 공정거래위원회 또는 시•도지사가 의뢰하는
					분쟁조정기관의 조정에 따를 수 있습니다. <span class="bold">제30조(재판권 및 준거법)</span>
					① “도담도담”와 이용자 간에 발생한 전자상거래 분쟁에 관한 소송은 제소 당시의 이용자의 주소에 의하고, 주소가 없는
					경우에는 거소를 관할하는 지방법원의 전속관할로 합니다. 다만, 제소 당시 이용자의 주소 또는 거소가 분명하지 않거나
					외국 거주자의 경우에는 민사소송법상의 관할법원에 제기합니다. ② “도담도담”와 이용자 간에 제기된 전자상거래 소송에는
					한국 법을 적용합니다. 이 약관은 2020년 8월 11일부터 시행됩니다. 단, 본 약관의 공지 이후 시행일 이전에 본
					약관에 동의한 경우에는 동의 시부터 본 약관이 적용됩니다. <a
					href="/terms/service/6f67b4d4-8fb6-11e8-8e29-0a48753a1178">이전
						약관(2018년 8월 8일자 시행) 보기 ▶︎</a></td>
			</tr>
		</table>
    </div>
    <div id="menu3" class="container tab-pane fade"><br>
      <h3 align="center">추가 문의 사항</h3>
		<address>
				<p align="center">
					<span>고객문의: <a href="mailto:rlaalsdn8@gmail.com">rlaalsdn8@gmail.com</a></span>
						<span>전화: <a href="tel://010-9255-9798">010-9255-9798</a></span>
				</p>
				<p align="center">
					<span>제휴문의: <a href="mailto:rlaalsdn8@naver.com">rlaalsdn8@naver.com</a></span>
					<span>전화: <a href="tel://010-9255-9798">010-9255-9798</a></span>
				</p>
		</address>
    </div>
  </div>
</div>

	
	<!-- <div class="container">
		<ul class="nav nav-tabs">
			<li class="nav-item">
				<a id="cs-main-top" class="nav-link active" data-toggle="tab" href="#cs-main-top-notice">
					공지 사항
				</a>
			</li>
			<li class="nav-item">
				<a id="cs-main-top" class="nav-link" data-toggle="tab" href="#cs-main-top-question">
					자주묻는 질문
				</a>
			</li>
			<li class="nav-item">
				<a id="cs-main-top" class="nav-link" data-toggle="tab" href="#cs-main-top-nonMember">
					비회원 주문
				</a>
			</li>
			<li class="nav-item">
				<a id="cs-main-top" class="nav-link" data-toggle="tab" href="#cs-main-top-policies">
					약관 및 방침
				</a>
			</li>
			<li class="nav-item">
				<a id="cs-main-top" class="nav-link" data-toggle="tab" href="#cs-main-top-inquiries">
					추가 문의
				</a>
			</li>
		</ul>
	</div> -->
	<%-- <div class="tab-content">
		<div class="container offset-sm-<%=myoffset%> col-sm-<%=mywidth%>">
			<div id="cs-main-top-notice" class="container tab-pane active">
				<form action="" class="form-inline">
					<h2>공지 사항</h2>
				</form>
					<table class="table table-striped table-hover">
						<thead>
							<tr>
								<td align="center">제목</td>
								<td align="right">작성 일자</td>
							</tr>
						</thead>
						<tr>
							<td colspan="2" align="center">
								<form action="<%=YesForm%>" class="form-inline" name="myform" method="get">
									<input type="hidden" name="command" value="cs-center-main">
									<div class="form-group">
										<select class="form-control" name="mode" id="mode">
											<option value="all" selected="selected">-- 선택하세요 --
											<option value="subject">제목
											<option value="content">글 내용
										</select>
									</div>
									<div class="form-group">
										<input type="text" class="form-control btn-xs" name="keyword"
											id="keyword" placeholder="검색 키워드">
									</div>
									<button class="btn btn-default btn-warning" type="submit" onclick="search();">검색</button>
									<button class="btn btn-default btn-warning" type="button" onclick="searchAll();">전체 검색</button>
									<button class="btn btn-default btn-warning" type="button"
										 onclick="writeForm();">글 쓰기</button> <!-- 운영자만 글 쓰기 가능으로 hidden처리해야함-->
										 <p class="form-control-static">${requestScope.pagingStatus}</p>
								</form>
							</td>
						</tr>
						<c:forEach var="bean" items="${requestScope.lists}">
							<tr>
								<td>
									<c:forEach var="cnt" begin="1" end="${bean.depth}">
										<span class="badge re">re</span>
									</c:forEach>
									<a href="<%=NoForm%>cs-detailView&no=${bean.no}&${requestScope.parameters}">
										${bean.subject}
									</a>
								</td>
								<td>${bean.writer}</td>
								<td>${bean.content}</td>
								<td>${bean.regdate}</td>
								<td>
									<c:if test="${sessionScope.loginfo.id == bean.writer}">
										<a href="<%=NoForm%>cs-update&no=${bean.no}&${requestScope.parameters}">
											수정
										</a>
									</c:if>
									<c:if test="${sessionScope.loginfo.id != bean.writer}">
											수정
									</c:if>
								</td>
								<td>
									<c:if test="${sessionScope.loginfo.id == bean.writer}">
										<a href="<%=NoForm %>cs-delete&no=${bean.no}&${requestScope.parameters}">
											삭제
										</a>
									</c:if>
									<c:if test="${sessionScope.loginfo.id != bean.writer}">
										삭제
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</table>
				<div align="center">
					<footer>${requestScope.pagingHtml}</footer>
				</div>
				<div class="col-sm-offset-<%=myoffset%> col-sm-<%=mywidth%>" style="display: inline;"><!--운영자 로그인 시 볼수있게 바꿔야함-->
						<div class="panel panel-default panel-primary">
							<div class="panel-heading">
								<h4 align="center">공지사항 등록</h4>
							</div>
							<div class="panel-body">
								<form class="form-horizontal" role="form" action="<%=YesForm%>"
									method="post">
									<input type="hidden" name="command" value="cs-center-insert">
									<div class="row">
										<div class="form-group col-sm-6">
											<label class="control-label col-sm-<%=formleft%>" for="writer">작성자</label>
											<div class="col-sm-12">
												<input type="text" class="form-control" name="fakewriter" id="fakewriter"
													placeholder="작성자" value="${sessionScope.loginfo.name}(${sessionScope.loginfo.id})" disabled="disabled">
												<input type="hidden" name="writer" id="writer"
													value="${sessionScope.loginfo.id}">
											</div>
											<label class="control-label col-sm-12" for="subject">
											</label>
											<div class="col-sm-12">
												<input type="text" class="form-control" name="subject"
													id="subject" placeholder="글 제목" value="${bean.subject}"> 
												<span class="err">${errsubject}</span>
											</div>
											<div class="form-group">
												<label class="control-label col-sm-<%=formleft%>"
													for="image"></label>
												<div class="col-sm-<%=formright%>">
													<input type="file" class="form-control" name="image"
														id="image" placeholder="이미지를 넣어 주셔용^^"><span
														class="err form-control-static">${errimage}</span>
												</div>
											</div>
											<label class="control-label col-sm-<%=formleft%>" for="regdate">
											</label>
											<div class="col-sm-12">
												<input type="datetime" class="form-control" name="regdate"
													id="regdate" placeholder="작성 일자" value="${bean.regdate}"> <span
													class="err">${errregdate}</span>
											</div>
										</div>
										<div class="form-group col-sm-6">
											<label class="control-label col-sm-12" for="content">
											</label>
											<div class="col-sm-12">
												<textarea name="content" id="content" rows="5" cols=""
													placeholder="글 내용" class="form-control">${bean.content}</textarea>
												<span class="err">${errcontent}</span>
											</div><br>
											<div align="center" class="col-sm-offset-3 col-sm-12 row">
												<div class="col-sm-6">
													<button class="btn btn-outline-primary" type="submit">글 등록</button>
												</div>
												<div class="col-sm-6">
													<button class="btn btn-outline-danger" type="reset">취소</button>
												</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-sm-<%=formleft%>" for="password">비밀
											번호</label>
										<div class="col-sm-<%=formright%>">
											<input type="password" class="form-control" name="password"
												id="password" placeholder="비밀 번호를 넣어 주셔용^^" value="${bean.password}">
												<span class="err">${errpassword}</span>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
			</div>
		</div>
		<div class="container offset-sm-<%=myoffset%> col-sm-<%=mywidth%>">
			<div id="cs-main-top-question" class="container tab-pane fade">
				<form action="" class="form-inline">
					<h2>자주 묻는 질문</h2>
				</form>
					<table class="table table-striped table-hover">
						<thead>
							<tr>
								<td align="center">제목</td>
								<td align="right">작성 일자</td>
							</tr>
						</thead>
						<tr>
							<td colspan="2" align="center">
								<form action="<%=YesForm%>" class="form-inline" name="myform" method="get">
									<input type="hidden" name="command" value="cs-center-main">
									<div class="form-group">
										<select class="form-control" name="mode" id="mode">
											<option value="all" selected="selected">-- 선택하세요 --
											<option value="subject">제목
											<option value="content">글 내용
										</select>
									</div>
									<div class="form-group">
										<input type="text" class="form-control btn-xs" name="keyword"
											id="keyword" placeholder="검색 키워드">
									</div>
									<button class="btn btn-default btn-warning" type="submit" onclick="search();">검색</button>
									<button class="btn btn-default btn-warning" type="button" onclick="searchAll();">전체 검색</button>
									<button class="btn btn-default btn-warning" type="button"
										 onclick="writeForm();">글 쓰기</button> <!-- 운영자만 글 쓰기 가능으로 hidden처리해야함-->
										 <p class="form-control-static">${requestScope.pagingStatus}</p>
								</form>
							</td>
						</tr>
						<c:forEach var="bean" items="${requestScope.lists}">
							<tr>
								<td>
									<c:forEach var="cnt" begin="1" end="${bean.depth}">
										<span class="badge re">re</span>
									</c:forEach>
									<a href="<%=NoForm%>cs-detailView&no=${bean.no}&${requestScope.parameters}">
										${bean.subject}
									</a>
								</td>
								<td>${bean.writer}</td>
								<td>${bean.content}</td>
								<td>${bean.regdate}</td>
								<td>
									<c:if test="${sessionScope.loginfo.id == bean.writer}">
										<a href="<%=NoForm%>cs-update&no=${bean.no}&${requestScope.parameters}">
											수정
										</a>
									</c:if>
									<c:if test="${sessionScope.loginfo.id != bean.writer}">
											수정
									</c:if>
								</td>
								<td>
									<c:if test="${sessionScope.loginfo.id == bean.writer}">
										<a href="<%=NoForm %>cs-delete&no=${bean.no}&${requestScope.parameters}">
											삭제
										</a>
									</c:if>
									<c:if test="${sessionScope.loginfo.id != bean.writer}">
										삭제
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</table>
				<div align="center">
					<footer>${requestScope.pagingHtml}</footer>
				</div>
				<div class="col-sm-offset-<%=myoffset%> col-sm-<%=mywidth%>" style="display: inline;"><!--운영자 로그인 시 볼수있게 바꿔야함-->
						<div class="panel panel-default panel-primary">
							<div class="panel-heading">
								<h4 align="center">공지사항 등록</h4>
							</div>
							<div class="panel-body">
								<form class="form-horizontal" role="form" action="<%=YesForm%>"
									method="post">
									<input type="hidden" name="command" value="cs-center-insert">
									<div class="row">
										<div class="form-group col-sm-6">
											<label class="control-label col-sm-<%=formleft%>" for="writer">작성자</label>
											<div class="col-sm-12">
												<input type="text" class="form-control" name="fakewriter" id="fakewriter"
													placeholder="작성자" value="${sessionScope.loginfo.name}(${sessionScope.loginfo.id})" disabled="disabled">
												<input type="hidden" name="writer" id="writer"
													value="${sessionScope.loginfo.id}">
											</div>
											<label class="control-label col-sm-12" for="subject">
											</label>
											<div class="col-sm-12">
												<input type="text" class="form-control" name="subject"
													id="subject" placeholder="글 제목" value="${bean.subject}"> 
												<span class="err">${errsubject}</span>
											</div>
											<div class="form-group">
												<label class="control-label col-sm-<%=formleft%>"
													for="image"></label>
												<div class="col-sm-<%=formright%>">
													<input type="file" class="form-control" name="image"
														id="image" placeholder="이미지를 넣어 주셔용^^"><span
														class="err form-control-static">${errimage}</span>
												</div>
											</div>
											<label class="control-label col-sm-<%=formleft%>" for="regdate">
											</label>
											<div class="col-sm-12">
												<input type="datetime" class="form-control" name="regdate"
													id="regdate" placeholder="작성 일자" value="${bean.regdate}"> <span
													class="err">${errregdate}</span>
											</div>
										</div>
										<div class="form-group col-sm-6">
											<label class="control-label col-sm-12" for="content">
											</label>
											<div class="col-sm-12">
												<textarea name="content" id="content" rows="5" cols=""
													placeholder="글 내용" class="form-control">${bean.content}</textarea>
												<span class="err">${errcontent}</span>
											</div><br>
											<div align="center" class="col-sm-offset-3 col-sm-12 row">
												<div class="col-sm-6">
													<button class="btn btn-outline-primary" type="submit">글 등록</button>
												</div>
												<div class="col-sm-6">
													<button class="btn btn-outline-danger" type="reset">취소</button>
												</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="control-label col-sm-<%=formleft%>" for="password">비밀
											번호</label>
										<div class="col-sm-<%=formright%>">
											<input type="password" class="form-control" name="password"
												id="password" placeholder="비밀 번호를 넣어 주셔용^^" value="${bean.password}">
												<span class="err">${errpassword}</span>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
			</div>
		</div>
		|
		<div id="cs-main-top-policies" class="container tab-pane fade" role="tabpanel"
			aria-labelledby="cs-main-top">
			<div class=" ">
				<div class="panel panel-default panel-primary">
					<div class="panel-heading">
						<form class="form-inline" role="form">
							<h3>약관 및 방침</h3>
						</form>
					</div>
				</div>
				<table border="1">
					<tr class="terms-wrapper">
						<td><span class="bold" style="font: bolder;">제1조(목적)</span> 이
							약관은 (주)도담도담 회사(사업자등록번호 : 759-87-00821, 통신판매업신고번호 :
							제2020-서울강남-03029호, 대표자 : 1조도담도담)가 운영하는 온라인 웹사이트 도담도담 및 모바일 어플리케이션
							도담도담케어(이하 두 서비스를 통칭하여 “도담도담”라 함)에서 제공하는 전자상거래 관련 서비스(이하 “서비스”라 한다.)를
							이용함에 있어 도담도담와 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다. *PC통신, 스마트폰 앱, 무선
							등을 이용하는 전자상거래에 대해서도 그 성질에 반하지 않는 한 준용합니다. <span class="bold"
							style="font: bolder;">제2조(정의) </span> ① “도담도담"란 (주)케어위드 회사가 재화 또는
							용역(이하 “재화 등"이라 함)을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 등을 거래할 수
							있도록 설정한 가상의 영업장 및 그에 부수되는 콘텐츠 서비스를 말하며, 아울러 서비스를 운영하는 사업자의 의미로도
							사용합니다. ② “이용자"란 “도담도담"에 접속하여 이 약관에 따라 “도담도담"가 제공하는 서비스를 받는 회원 및 비회원을
							말합니다. ③ “회원"이라 함은 “도담도담"에 회원등록을 한 자로서, 계속적으로 “도담도담"가 제공하는 서비스를 이용할 수
							있는 자를 말합니다. ④ “비회원"이라 함은 회원으로 가입하지 않고 “도담도담"가 제공하는 서비스를 이용하는 자를
							말합니다. <span class="bold" style="font: bolder;">제3조 (약관 등의
								명시와 설명 및 개정) </span> ① “도담도담”는 이 약관의 내용과 상호 및 대표자 성명, 영업소 소재지 주소(소비자의 불만을
							처리할 수 있는 곳의 주소를 포함), 전화번호, 모사전송번호, 전자우편주소, 사업자등록번호, 통신판매업 신고번호,
							개인정보관리책임자등을 이용자가 쉽게 알 수 있도록 도담도담의 초기 서비스화면(전면)에 게시합니다. 다만, 약관의 내용은
							이용자가 연결화면을 통하여 볼 수 있도록 할 수 있습니다. ② “도담도담"는 이용자가 약관에 동의하기에 앞서 약관에
							정하여져 있는 내용 중 청약철회, 배송책임, 환불조건 등과 같은 중요한 내용을 이용자가 이해할 수 있도록 별도의
							연결화면 또는 팝업화면 등을 제공하여 이용자의 확인을 구하여야 합니다. ③ “도담도담”는「전자상거래 등에서의 소비자보호에
							관한 법률」, 「약관의 규제에 관한 법률」, 「전자문서 및 전자거래기본법」, 「전자금융거래법」, 「전자서명법」,
							「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「방문판매 등에 관한 법률」, 「소비자기본법」 등 관련 법을
							위배하지 않는 범위에서 이 약관을 개정할 수 있습니다. ④ “도담도담”가 약관을 개정할 경우에는 적용일자 및 개정사유를
							명시하여 현행약관과 함께 몰의 초기화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 이용자에게
							불리하게 약관내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다. 이 경우 "도담도담“는 개정
							전 내용과 개정 후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다. ⑤ “도담도담”가 약관을 개정할 경우에는
							그 개정약관은 그 적용일자 이후에 체결되는 계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정 전의
							약관조항이 그대로 적용됩니다. 다만 이미 계약을 체결한 이용자가 개정약관 조항의 적용을 받기를 원하는 뜻을 제3항에
							의한 개정약관의 공지기간 내에 “도담도담”에 송신하여 “도담도담”의 동의를 받은 경우에는 개정약관 조항이 적용됩니다. ⑥ 이
							약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제
							등에 관한 법률, 공정거래위원회가 정하는 전자상거래 등에서의 소비자 보호지침 및 관계법령 또는 상관례에 따릅니다. <span
							class="bold" style="font: bolder;">제4조(서비스의 제공 및 변경) </span> ①
							“도담도담”는 다음과 같은 서비스를 제공합니다. <span class="depth2">1. 재화 또는 용역에
								대한 정보 제공 및 구매계약의 체결 </span> <span class="depth2">2. 구매계약이 체결된 재화
								또는 용역의 배송</span> <span class="depth2">3. 이용자의 “도담도담” 서비스 이용에 도움이
								되는 알람 및 콘텐츠 제공 </span> <span class="depth2">4. 기타 “도담도담”가 정하는 업무 </span>
							② “도담도담”가 제공하는 재화 또는 용역 서비스는 비의료 건강관리서비스로서 질환의 치료 목적의 서비스가 아닌 보조적
							건강관리 서비스입니다. 특히 만성질환자의 경우 본 서비스 이용대상자가 아니며 의사 또는 의료기관의 도움을 받으시기를
							권고 드립니다. ③ “도담도담”는 재화 또는 용역의 품절 또는 기술적 사양의 변경 등의 경우에는 장차 체결되는 계약에
							의해 제공할 재화 또는 용역의 내용을 변경할 수 있습니다. 이 경우에는 변경된 재화 또는 용역의 내용 및 제공일자를
							명시하여 현재의 재화 또는 용역의 내용을 게시한 곳에 즉시 공지합니다. ④ “도담도담”가 제공하기로 이용자와 계약을
							체결한 서비스의 내용을 재화등의 품절 또는 기술적 사양의 변경 등의 사유로 변경할 경우에는 그 사유를 이용자에게 통지
							가능한 주소로 즉시 통지합니다. ⑤ 전항의 경우 “도담도담”는 이로 인하여 이용자가 입은 손해를 배상합니다. 다만,
							“도담도담”가 고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다. <span class="bold"
							style="font: bolder;">제5조(서비스의 중단) </span> ① “도담도담”는 연중무휴, 1일 24시간
							제공을 원칙으로 합니다. 단, 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장, 통신의 두절 등의 사유가 발생한
							경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다. ② “도담도담”는 제1항의 사유로 서비스의 제공이 일시적으로
							중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 배상합니다. 단, “도담도담”가 고의 또는 과실이 없음을
							입증하는 경우에는 그러하지 아니합니다. ③ 사업종목의 전환, 사업의 포기, 업체 간의 통합 등의 이유로 서비스를
							제공할 수 없게 되는 경우에는 “도담도담”는 제8조에 정한 방법으로 이용자에게 통지하고 당초 “도담도담”에서 제시한 조건에
							따라 소비자에게 보상합니다. 다만, “도담도담”가 보상기준 등을 고지하지 아니한 경우에는 이용자들의 포인트 또는 적립금
							등을 “도담도담”에서 통용되는 통화가치에 상응하는 현물 또는 현금으로 이용자에게 지급합니다. ④ 제3항에도 불구하고
							“도담도담”가 이용자에게 사전에 통지할 수 없는 부득이한 사유가 있는 경우 사후에 통지할 수 있습니다. <span
							class="bold" style="font: bolder;">제6조(회원가입) </span> ① 이용자는 “도담도담”가
							정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을 신청합니다. ②
							“도담도담”는 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다.
							<span class="depth2">1. 가입신청자가 이 약관 제7조제3항에 의하여 이전에 회원자격을
								상실한 적이 있는 경우, 다만 제7조제3항에 의한 회원자격 상실 후 3년이 경과한 자로서 “도담도담”의 회원재가입
								승낙을 얻은 경우에는 예외로 함.</span> <span class="depth2">2. 등록 내용에 허위,
								기재누락, 오기가 있는 경우 </span> <span class="depth2">3. 기타 회원으로 등록하는 것이
								“도담도담”의 기술상 현저히 지장이 있다고 판단되는 경우 </span> <span class="depth2">4.
								회원가입 및 전자상거래상의 계약에 관한 서비스는 만 14세 이상인자에 한함 </span> ③ 회원가입계약의 성립 시기는
							“도담도담”의 승낙이 회원에게 도달한 시점으로 합니다. ④ 회원은 회원가입 시 등록한 사항에 변경이 있는 경우, 상당한
							기간 이내에 “도담도담”에 대하여 회원정보 수정 등의 방법으로 그 변경사항을 알려야 합니다. <span
							class="bold" style="font: bolder;">제7조(회원 탈퇴 및 자격 상실 등) </span> ①
							회원은 “도담도담”에 언제든지 탈퇴를 요청할 수 있으며 “도담도담”는 즉시 회원탈퇴를 처리합니다. ② 회원이 다음 각 호의
							사유에 해당하는 경우, “도담도담”는 회원자격을 제한 및 정지시킬 수 있습니다. <span class="depth2">1.
								가입 신청 시에 허위 내용을 등록한 경우 </span> <span class="depth2">2. “도담도담”를
								이용하여 구입한 재화 등의 대금, 기타 “도담도담”이용에 관련하여 회원이 부담하는 채무를 기일에 지급하지 않는 경우 </span>
							<span class="depth2">3. 다른 사람의 “도담도담” 이용을 방해하거나 그 정보를 도용하는 등
								전자상거래 질서를 위협하는 경우 </span> <span class="depth2">4. “도담도담”를 이용하여 법령
								또는 이 약관이 금지하거나 공서양속에 반하는 행위를 하는 경우 </span> ③ “도담도담”가 회원 자격을 제한․정지 시킨 후,
							동일한 행위가 2회 이상 반복되거나 30일 이내에 그 사유가 시정되지 아니하는 경우 “도담도담”는 회원자격을 상실시킬 수
							있습니다. ④ “도담도담”가 회원자격을 상실시키는 경우에는 회원등록을 말소합니다. 이 경우 회원에게 이를 통지하고,
							회원등록 말소 전에 최소한 30일 이상의 기간을 정하여 소명할 기회를 부여합니다. <span class="bold"
							style="font: bolder;">제8조(회원에 대한 통지) </span> ① “도담도담”가 회원에 대한 통지를
							하는 경우, 회원이 “도담도담”와 미리 약정하여 지정한 전자우편 주소로 할 수 있습니다. ② “도담도담”는 불특정다수 회원에
							대한 통지의 경우 1주일이상 “도담도담” 게시판에 게시함으로서 개별 통지에 갈음할 수 있습니다. 다만, 회원 본인의
							거래와 관련하여 중대한 영향을 미치는 사항에 대하여는 개별통지를 합니다. <span class="bold"
							style="font: bolder;">제9조(구매신청) </span> “도담도담”이용자는 “도담도담”상에서 다음 또는 이와
							유사한 방법에 의하여 구매를 신청하며, “도담도담”는 이용자가 구매신청을 함에 있어서 다음의 각 내용을 알기 쉽게
							제공하여야 합니다. <span class="depth2">1. 재화 등의 검색 및 선택 </span> <span
							class="depth2">2. 받는 사람의 성명, 주소, 전화번호, 전자우편주소(또는 이동전화번호)
								등의 입력 </span> <span class="depth2">3. 약관내용, 청약철회권이 제한되는 서비스, 배송료
								등의 비용부담과 관련한 내용에 대한 확인 </span> <span class="depth2">4. 이 약관에
								동의하고 위 3.호의 사항을 확인하거나 거부하는 표시(예, 마우스 클릭) </span> <span class="depth2">5.
								재화등의 구매신청 및 이에 관한 확인 또는 “도담도담”의 확인에 대한 동의 </span> <span class="depth2">6.
								결제방법의 선택 </span> <span class="bold" style="font: bolder;">제10조
								(계약의 성립) </span> ① “도담도담”는 제9조와 같은 구매신청에 대하여 다음 각 호에 해당하면 승낙하지 않을 수 있습니다.
							다만, 미성년자와 계약을 체결하는 경우에는 법정대리인의 동의를 얻지 못하면 미성년자 본인 또는 법정대리인이 계약을
							취소할 수 있다는 내용을 고지하여야 합니다. <span class="depth2">1. 신청 내용에
								허위, 기재누락, 오기가 있는 경우 </span> <span class="depth2">2. 미성년자가 담배, 주류
								등 청소년보호법에서 금지하는 재화 및 용역을 구매하는 경우 </span> <span class="depth2">3.
								기타 구매신청에 승낙하는 것이 “도담도담” 기술상 현저히 지장이 있다고 판단하는 경우 </span> ② “도담도담”의 승낙이 제13조
							제1항의 수신확인통지형태로 이용자에게 도달한 시점에 계약이 성립한 것으로 봅니다. ③ “도담도담”의 승낙의 의사표시에는
							이용자의 구매 신청에 대한 확인 및 판매가능 여부, 구매신청의 정정 취소 등에 관한 정보 등을 포함하여야 합니다. <span
							class="bold" style="font: bolder;">제11조(지급방법) </span> “도담도담”에서 구매한
							재화 또는 용역에 대한 대금지급방법은 다음 각 호의 방법중 가용한 방법으로 할 수 있습니다. 단, “도담도담”는 이용자의
							지급방법에 대하여 재화 등의 대금에 어떠한 명목의 수수료도 추가하여 징수할 수 없습니다. ① 폰뱅킹, 인터넷뱅킹,
							메일 뱅킹 등의 각종 계좌이체 ② 선불카드, 직불카드, 신용카드 등의 각종 카드의 비인증식 정기결제 ③ 선불카드,
							직불카드, 신용카드 등의 각종 카드의 인증식 일반결제 ④ 온라인무통장입금 ⑤ 포인트 등 “도담도담”가 지급한 적립금에
							의한 결제 (단, 정기구매의 경우 최초 구매 신청시 1회 사용 가능) ⑥ “도담도담"와 계약을 맺었거나 “도담도담"가 인증한
							상품권에 의한 결제 ⑦ 기타 전자적 지급 방법에 의한 대금 지급 등 (각종 간편 결제 서비스) <span
							class="bold" style="font: bolder;">제12조(프로모션코드) </span> ① 프로모션코드는
							회원에게 무상으로 발행되는 것으로 “도담도담"는 회원이 프로모션코드를 사이트에서 상품 구매 시 적용할 수 있도록
							사용방법, 사용기간, 사용대상, 할인액 또는 할인율 등을 정할 수 있습니다. 프로모션코드의 종류와 내용은 “도담도담"의
							정책에 따라 달라질 수 있습니다. ② 프로모션코드는 현금으로 환급될 수 없으며, 프로모션코드의 사용기간이 만료되거나
							구매 취소 시 또는 이용계약이 종료되면 소멸됩니다. ③ “회원”은 허락되지 않은 방법으로 프로모션코드를 제3자에게
							또는 다른 아이디로 양도할 수 없으며, 유상으로 거래하거나 현금으로 전환할 수 없습니다. ④ “도담도담”는 회원이
							“도담도담”가 승인하지 않은 방법으로 프로모션코드를 획득하거나 부정한 목적이나 용도로 프로모션코드를 사용하는 경우
							프로모션코드의 사용을 제한하거나 프로모션코드를 사용한 구매신청을 취소하거나 회원 자격을 정지할 수 있습니다. ⑤
							“도담도담”는 “회원"이 사용한 프로모션코드와 동일한 프로모션코드로 재구매 시 해당 프로모션코드 적용을 하지 않을 수
							있습니다. <span class="bold" style="font: bolder;">제13조(수신확인통지,
								구매신청 변경 및 취소) </span> ① “도담도담”는 이용자의 구매신청이 있는 경우 이용자에게 수신확인통지를 합니다. ②
							수신확인통지를 받은 이용자는 의사표시의 불일치 등이 있는 경우에는 수신확인통지를 받은 후 즉시 구매신청 변경 및
							취소를 요청할 수 있고 “도담도담”는 배송 전에 이용자의 요청이 있는 경우에는 지체 없이 그 요청에 따라 처리하여야
							합니다. 다만 이미 대금을 지불한 경우에는 제16조의 청약철회 등에 관한 규정에 따릅니다. <span
							class="bold" style="font: bolder;">제14조(재화 등의 공급) </span> ① “도담도담”는
							이용자와 재화 등의 공급시기에 관하여 별도의 약정이 없는 이상, 이용자가 청약을 한 날부터 7일 이내에 재화 등을
							배송할 수 있도록 주문제작, 포장 등 기타의 필요한 조치를 취합니다. 다만, “도담도담”가 이미 재화 등의 대금의 전부
							또는 일부를 받은 경우에는 대금의 전부 또는 일부를 받은 날부터 3영업일 이내에 조치를 취합니다. 이때 “도담도담”는
							이용자가 재화 등의 공급 절차 및 진행 사항을 확인할 수 있도록 적절한 조치를 합니다. ② “도담도담”는 이용자가 구매한
							재화에 대해 배송수단, 수단별 배송비용 부담자, 수단별 배송기간 등을 명시합니다. 만약 “도담도담”가 약정 배송기간을
							초과한 경우에는 그로 인한 이용자의 손해를 배상하여야 합니다. 다만 “도담도담”가 고의․과실이 없음을 입증한 경우에는
							그러하지 아니합니다. ③ 이용자는 “도담도담”가 지정하는 일부 서비스 항목 또는 “도담도담”가 지정한 기한에 한하여 회원가입
							없이 무상으로 서비스를 이용할 수 있습니다. <span class="bold" style="font: bolder;">제15조(적립금
								제도의 운영) </span> ① “도담도담”는 회원이 정기구매서비스를 이용하여 재화를 구매하거나 이벤트에 참여하는 등의 일정한 경우
							적립금으로서 포인트를 부여할 수 있습니다. 이러한 포인트의 부여는 다음 각 호의 방법에 따르되, 그 구체적인
							운영방법은 회사의 운영정책에 따릅니다. <span class="depth2">1. “도담도담”는 회원의
								결제금액에 대하여 서비스 페이지에 고지한 특정한 비율만큼 포인트를 부여할 수 있습니다. 단, 이 경우 적립대상금액은
								쿠폰, 프로모션 등 기타 방법을 통해 할인 받은 금액은 제외됩니다.</span> <span class="depth2">2.
								“도담도담”는 회원이 서비스나 이벤트 등에 참여할 경우 포인트를 부여할 수 있습니다.</span> <span
							class="depth2">3. “도담도담”에서 회원이 구매한 재화를 반품하였을 때 해당 구매로 적립된
								포인트는 환수됩니다.</span> ② 포인트는 “도담도담”의 서비스 제도로서 “도담도담”가 회원에게 사전 고지한 조건 및 비율에 따라
							“도담도담”의 포인트몰에서 특정 재화로 교환이 가능합니다. 단, 포인트는 사은의 형태로 “도담도담”에서 지급하는 것으로
							현금으로 환불되지는 않으며 타인에게 양도할 수 없습니다. ③ 포인트의 사용기한은 최초 적립일로부터 1년이며, 기한내
							사용하지 않은 포인트는 소멸됩니다. 단일상품의 구매로 인하여 일시에 부여된 포인트에 대해서 그 중 일부만을 사용한
							경우에도 동일합니다. 단, 포인트 부여시 적립금 사용기간에 대해 별도의 사전 고지 또는 특약이 있는 경우에는 그
							사용기간 이내에 사용하여야 합니다. ④ 다음의 경우 포인트가 소멸됩니다. <span class="depth2">1.
								회원을 탈퇴한 경우</span> <span class="depth2">2. 사용기간이 경과한 경우</span> <span
							class="depth2">3. 사용가능 조건 및 소멸에 대한 내용이 별도로 공지된 경우</span> ⑤ 포인트를
							이용하여 부당 이득을 취하거나, 악의적인 상거래가 발생할 경우, “도담도담”는 포인트에 대해 지급을 중지하며 기지급된
							포인트를 환수할 수 있습니다. <span class="bold" style="font: bolder;">제16조(환급)
						</span> “도담도담”는 이용자가 구매신청한 재화 등이 품절 등의 사유로 인도 또는 제공을 할 수 없을 때에는 지체 없이 그 사유를
							이용자에게 통지하고 사전에 재화 등의 대금을 받은 경우에는 대금을 받은 날부터 3영업일 이내에 환급하거나 환급에
							필요한 조치를 취합니다. <span class="bold" style="font: bolder;">제17조(청약철회
								등) </span> ① “도담도담”와 재화등의 구매에 관한 계약을 체결한 이용자는 「전자상거래 등에서의 소비자보호에 관한 법률」
							제13조 제2항에 따른 계약내용에 관한 서면을 받은 날(그 서면을 받은 때보다 재화 등의 공급이 늦게 이루어진
							경우에는 재화 등을 공급받거나 재화 등의 공급이 시작된 날을 말합니다)부터 7일 이내에는 청약의 철회를 할 수
							있습니다. 다만, 청약철회에 관하여 「전자상거래 등에서의 소비자보호에 관한 법률」에 달리 정함이 있는 경우에는 동 법
							규정에 따릅니다. ② 이용자는 재화 등을 배송 받은 경우 다음 각 호의 1에 해당하는 경우에는 반품 및 교환을 할 수
							없습니다. <span class="depth2">1. 이용자에게 책임 있는 사유로 재화 등이 멸실 또는
								훼손된 경우 (다만, 재화 등의 내용을 확인하기 위하여 포장 등을 훼손한 경우에는 청약철회를 할 수 있습니다) </span> <span
							class="depth2">2. 이용자의 사용 또는 일부 소비에 의하여 재화 등의 가치가 현저히 감소한
								경우 </span> <span class="depth2">3. 시간의 경과에 의하여 재판매가 곤란할 정도로 재화등의
								가치가 현저히 감소한 경우 </span> <span class="depth2">4. 같은 성능을 지닌 재화 등으로
								복제가 가능한 경우 그 원본인 재화 등의 포장을 훼손한 경우 </span> ③ 제2항제2호 내지 제4호의 경우에 “도담도담”가
							사전에 청약철회 등이 제한되는 사실을 소비자가 쉽게 알 수 있는 곳에 명기하거나 시용상품을 제공하는 등의 조치를 하지
							않았다면 이용자의 청약철회 등이 제한되지 않습니다. ④ 이용자는 제1항 및 제2항의 규정에 불구하고 재화 등의 내용이
							표시•광고 내용과 다르거나 계약내용과 다르게 이행된 때에는 당해 재화 등을 공급받은 날부터 3월 이내, 그 사실을 안
							날 또는 알 수 있었던 날부터 30일 이내에 청약철회 등을 할 수 있습니다. <span class="bold"
							style="font: bolder;">제18조(청약철회 등의 효과) </span> ① “도담도담”는 이용자로부터 재화
							등을 반환받은 경우 3영업일 이내에 이미 지급받은 재화 등의 대금을 환급합니다. 이 경우 “도담도담”가 이용자에게
							재화등의 환급을 지연한 때에는 그 지연기간에 대하여 「전자상거래 등에서의 소비자보호에 관한 법률
							시행령」제21조의2에서 정하는 지연이자율(괄호 부분 삭제)을 곱하여 산정한 지연이자를 지급합니다. ② “도담도담”는 위
							대금을 환급함에 있어서 이용자가 신용카드 또는 전자화폐 등의 결제수단으로 재화 등의 대금을 지급한 때에는 지체 없이
							당해 결제수단을 제공한 사업자로 하여금 재화 등의 대금의 청구를 정지 또는 취소하도록 요청합니다. ③ 청약철회 등의
							경우 공급받은 재화 등의 반환에 필요한 비용은 이용자가 부담합니다. “도담도담”는 이용자에게 청약철회 등을 이유로 위약금
							또는 손해배상을 청구하지 않습니다. 다만 재화 등의 내용이 표시•광고 내용과 다르거나 계약내용과 다르게 이행되어
							청약철회 등을 하는 경우 재화 등의 반환에 필요한 비용은 “도담도담”가 부담합니다. ④ 이용자가 재화 등을 제공받을 때
							발송비를 부담한 경우에 “도담도담”는 청약철회 시 그 비용을 누가 부담하는지를 이용자가 알기 쉽도록 명확하게 표시합니다.
							<span class="bold" style="font: bolder;">제19조(“도담도담“의 의무) </span> ①
							“도담도담”는 법령과 이 약관이 금지하거나 공서양속에 반하는 행위를 하지 않으며 이 약관이 정하는 바에 따라 지속적이고,
							안정적으로 재화․용역을 제공하는데 최선을 다하여야 합니다. ② “도담도담”는 이용자가 안전하게 인터넷 서비스를 이용할 수
							있도록 이용자의 개인정보(신용정보 포함)보호를 위한 보안 시스템을 갖추어야 합니다. ③ “도담도담”가 상품이나 용역에
							대하여 「표시․광고의 공정화에 관한 법률」 제3조 소정의 부당한 표시․광고행위를 함으로써 이용자가 손해를 입은 때에는
							이를 배상할 책임을 집니다. ④ “도담도담”는 이용자가 원하지 않는 영리목적의 광고성 전자우편을 발송하지 않습니다. <span
							class="bold" style="font: bolder;">제20조(회원의 ID 및 비밀번호에 대한
								의무) </span> ① ID와 비밀번호에 관한 관리책임은 회원에게 있으며, 어떠한 경우에도 본인의 ID 또는 비밀번호를
							양도하거나 대여할 수 없습니다. ② 회원은 자신의 ID 및 비밀번호를 제3자에게 이용하게 해서는 안되며, “도담도담”의
							귀책사유 없이 이를 유출, 양도, 대여한 행위로 인하여 발생하는 손실이나 손해에 대하여는 회원 본인이 그에 대한
							책임을 부담합니다. ③ 회원이 자신의 ID 및 비밀번호를 도난당하거나 제3자가 사용하고 있음을 인지한 경우에는 바로
							“도담도담”에 통보하고 “도담도담”의 안내가 있는 경우에는 그에 따라야 합니다. <span class="bold"
							style="font: bolder;">제21조(이용자의 의무) </span> 이용자는 다음 행위를 하여서는 안
							됩니다. <span class="depth2">1. 신청 또는 변경 시 허위 내용의 등록 </span> <span
							class="depth2">2. 타인의 정보 도용 </span> <span class="depth2">3.
								“도담도담”에 게시된 정보의 변경 </span> <span class="depth2">4. “도담도담”가 정한 정보 이외의
								정보(컴퓨터 프로그램 등) 등의 송신 또는 게시 </span> <span class="depth2">5. “도담도담”
								기타 제3자의 저작권 등 지적재산권에 대한 침해 </span> <span class="depth2">6. “도담도담”
								기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위 </span> <span class="depth2">7.
								외설 또는 폭력적인 메시지, 화상, 음성, 기타 공서양속에 반하는 정보를 몰에 공개 또는 게시하는 행위 </span> <span
							class="bold" style="font: bolder;">제22조(정기구매서비스 제공 및 이용자격)
						</span> ① 정기구매서비스는 “도담도담" 회원의 편의를 위하여 상품을 정기적으로 결제하고 배송하는 서비스입니다. ②
							정기구매서비스는 “도담도담"회원이면 누구나 정기구매서비스를 신청함으로써 이용 가능합니다. <span
							class="bold" style="font: bolder;">제23조(정기구매서비스 상품의 결제 등)
						</span> ① “도담도담"는 정기구매서비스 상품에 대하여 할인혜택을 제공할 수 있으며, 할인율 및 거래조건 등은 상품별로 다를 수
							있고 변경될 수 있습니다. 할인율 및 거래조건 등이 회원에게 불리하게 변경되는 경우 “도담도담"는 2주 이상의 상당한
							기간 동안 위 변경에 대하여 공지하고, 회원은 위 변경에 동의하지 않으면 위 기간 동안 본 서비스를 종료시킬 수
							있으며, 위 기간 동안 서비스를 종료시키지 않으면 위 변경에 회원이 동의한 것으로 봅니다. ② 정기구매서비스의 특성상
							상품의 가격은 계속적으로 변경될 수 있으며, 회원에게 고지된 시점의 상품가격을 기준으로 결제가 이루어집니다. 가격
							결정의 기준 시점은 변경될 수 있습니다. ③ 정기구매서비스 상품의 추가 또는 변경 시 결제되는 총 상품의 금액은
							변경될 수 있습니다. ④ 카드한도 초과 등 상품의 결제가 이루어지지 않을 경우, 해당 회차의 정기구매 주문은
							이루어지지 않을 수 있으며, 위와 같은 상황이 2회 이상 지속되는 경우 “도담도담"는 정기구매서비스를 중지할 수
							있습니다. <span class="bold" style="font: bolder;">제24조(정기구매서비스
								상품의 판매 종료 등) </span> ① 정기구매서비스의 대상 상품을 품절 등의 사유로 더 이상 판매할 수 없거나 해당 상품을
							정기구매서비스로 제공할 수 없는 사유가 있는 경우, “도담도담"는 해당 상품의 정기구매서비스를 종료하거나 해당 회차의
							상품을 공급하지 않을 수 있습니다. ② 재화 등의 대금을 환급하여야 하는 경우 제16조에서 정한 사항에 따릅니다. <span
							class="bold" style="font: bolder;">제25조(정기구매서비스의 종료) </span> ①
							회원이 “도담도담"에게 정기구매서비스의 종료를 통지하거나, “도담도담"의 마이페이지에서 해지 신청함으로써 정기구매서비스를
							종료시킬 수 있습니다. ② 정기구매서비스가 종료된 경우 해당 정기구매서비스에 적용된 프로모션코드와 장기구매고객할인 등
							각종 혜택은 동시에 종료됩니다. <span class="bold" style="font: bolder;">제26조(정기구매서비스
								이용의 제한) </span> ① 회원의 통지 또는 과실에 의해서 정기구매서비스가 중지되는 경우, 해당 상품의 정기구매 서비스
							신청이 2개월의 범위 내에서 제한될 수 있습니다. ② “도담도담"는 특정상품에 대하여 구매 수량을 제한할 수 있습니다.
							③ “도담도담"는 상품의 재판매 가능성이 있는 경우, 또는 불법적이거나 부당한 행위와 관련된 경우 정기구매서비스 제공을
							제한할 수 있습니다. ④ 서비스 이용의 제한에 대한 구체적인 기준은 내부 운영정책에 따라 적용됩니다. ⑤ “도담도담"는
							자체적인 시스템을 통해 모니터링과 각종 기관에서 접수된 민원 내용, 수사기관의 정보 등을 통해 정황을 확인한 후
							정기구매서비스 제한 사유행위를 한 것으로 추정되는 경우 정기구매서비스 이용을 제한할 수 있습니다. <span
							class="bold" style="font: bolder;">제27조(저작권의 귀속 및 이용제한) </span> ①
							“도담도담“가 작성한 저작물에 대한 저작권 기타 지적재산권은 "도담도담"에 귀속합니다. ② 이용자는 “도담도담”를 이용함으로써
							얻은 정보 중 “도담도담”에게 지적재산권이 귀속된 정보를 “도담도담”의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송
							기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다. ③ “도담도담”는 약정에 따라
							이용자에게 귀속된 저작권을 사용하는 경우 당해 이용자에게 통보하여야 합니다. <span class="bold"
							style="font: bolder;">제28조(면책조항) </span> ① “도담도담”는 천재지변 또는 이에 준하는
							불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다. ② “도담도담”는 의
							귀책사유로 인한 서비스 이용의 장애에 대하여 책임을 지지 않습니다. ③ “도담도담”는 회원이 서비스를 이용하여 기대하는
							수익을 상실한 것에 대하여 책임을 지지 않으며, 그 밖의 서비스를 통하여 얻은 자료로 인한 손해에 관하여 책임을 지지
							않습니다. ④ “도담도담”는 회원이 게재한 정보, 자료, 사실의 신뢰도, 정확성 등 내용에 관해서는 책임을 지지
							않습니다. ⑤ “도담도담”는 회원 간 또는 회원과 제3자 상호간에 서비스를 매개로 하여 거래 등을 한 경우에는 책임을
							지지 않습니다. <span class="bold" style="font: bolder;">제29조(분쟁해결)
						</span> ① “도담도담”는 이용자가 제기하는 정당한 의견이나 불만을 반영하고 그 피해를 보상처리하기 위하여 피해보상처리기구를
							설치․운영합니다. ② “도담도담”는 이용자로부터 제출되는 불만사항 및 의견은 우선적으로 그 사항을 처리합니다. 다만,
							신속한 처리가 곤란한 경우에는 이용자에게 그 사유와 처리일정을 즉시 통보해 드립니다. ③ “도담도담”와 이용자 간에
							발생한 전자상거래 분쟁과 관련하여 이용자의 피해구제신청이 있는 경우에는 공정거래위원회 또는 시•도지사가 의뢰하는
							분쟁조정기관의 조정에 따를 수 있습니다. <span class="bold" style="font: bolder;">제30조(재판권
								및 준거법)</span> ① “도담도담”와 이용자 간에 발생한 전자상거래 분쟁에 관한 소송은 제소 당시의 이용자의 주소에 의하고,
							주소가 없는 경우에는 거소를 관할하는 지방법원의 전속관할로 합니다. 다만, 제소 당시 이용자의 주소 또는 거소가
							분명하지 않거나 외국 거주자의 경우에는 민사소송법상의 관할법원에 제기합니다. ② “도담도담”와 이용자 간에 제기된
							전자상거래 소송에는 한국 법을 적용합니다. 이 약관은 2020년 8월 11일부터 시행됩니다. 단, 본 약관의 공지
							이후 시행일 이전에 본 약관에 동의한 경우에는 동의 시부터 본 약관이 적용됩니다. <a
							href="/terms/service/6f67b4d4-8fb6-11e8-8e29-0a48753a1178">이전
								약관(2018년 8월 8일자 시행) 보기 ▶︎</a></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="cs-main-top-inquiries" class="container tab-pane fade" role="tabpanel" aria-labelledby="cs-main-top">
			<div>
				<div class="panel panel-default panel-primary">
					<div class="panel-heading">
						<form class="form-inline" role="form">
						</form>
					</div>
				</div>
				<address>
					<span class="display-4">추가 문의 사항 연락처</span>>
						<p align="center">
							<span>고객문의: <a href="mailto:rlaalsdn8@gmail.com">rlaalsdn8@gmail.com</a></span>
								<span>전화: <a href="tel://010-9255-9798">010-9255-9798</a></span>
						</p>
						<p align="center">
							<span>제휴문의: <a href="mailto:rlaalsdn8@naver.com">rlaalsdn8@naver.com</a></span>
							<span>전화: <a href="tel://010-9255-9798">010-9255-9798</a></span>
						</p>
				</address>
			</div>
		</div>
	</div> --%>
	</body>
</html>