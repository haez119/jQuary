<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>comments.jsp</title>
<style>
	.comment {
		border: 1px dotted blue;

	}
	#commentUpdate {
		background-color: yellow;
	}
</style>
<script src="../js/jquery-3.5.1.min.js"></script>
<script>
	window.onload = function() {
		loadCommentList(); // 목록조회	
	}
	
	function loadCommentList() {
		$.ajax({
			url: '../CommentsServ',
			data: {cmd: 'selectAll'}, // ==  "cmd=selectAll"
			dataType: 'xml',
			type: 'get',
			success: loadCommentResult,
			error: function (a, b) {
				alert("댓글 로딩 실패: " + b);
				
			}
			
		});
	}
	
	// success에 들어가는 콜백함수
	function loadCommentResult(xmlResult) { // ajax에서 넘겨주는 xml타입의 데이터를 매개값으로 받음
		// console.log(xmlResult);
		let xmlDoc = xmlResult;
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue; // imem(0) == []
		if(code == 'success') {
			let commentList = eval( '(' + xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue + ')' ); // 안에 있는 거 그대로 실행? eval?
			console.log(commentList);
			let listDiv = $('#commentList');
			
			for(let i=0; i < commentList.length; i++) {
				let commentDiv = makeCommentView(commentList[i]);
				listDiv.append(commentDiv);
			}
			
			
			// for(field in commentList[0]) {
			// 	  $(listDiv).append(commentList[0][field]);
			// }
			
		}
	}
	
	// 댓글 리스트 & 수정 삭제
	function makeCommentView(comment) {
		let div = document.createElement('div');
		div.setAttribute('id', 'c' + comment.id); // c0 c1 c2 ...
		div.className = 'comment';
		div.comment = comment; // comment== {id:2, name: 홍, content: 내용들~}
		
		// 댓글 처럼
		let str = '<strong>' + comment.name + '</strong> ' + 
							   comment.content + 
							   ' <input type="button" value="수정" onclick="viewUpdateForm('+ comment.id + ')" >' +
							   ' <input type="button" value="삭제" onclick="confirmDeletion(' + comment.id +')" >';
		div.innerHTML = str;
		return div;
	}
	
	// 댓글 등록 하는거 ajax 호출해서
	
	function addComment() {
		let name = document.addForm.name.value;
		let content = document.addForm.content.value;
		
		if(name == null || name == '') {
			alert("name is invalid");
			return; // 프로그램 종료하기 리턴!!
		} else if ( content == null || content == '' ) { 
			alert("content is invalid");
			return;
		}
		
		let params = 'name='+ name + "&content=" + content + "&cmd=insert";
		
		$.ajax({
			url:' ../CommentsServ',
			dataType: 'xml',
			data: params,
			success: addResult,
			error: function(a, b) {
				alert("서버 에러: " + b);
			}
		});
		
	}
	
	function addResult(req) {
		let xmlDoc = req;
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue; // imem(0) == []
		if(code == 'success') {
			let comment = eval("("+ xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue +")");
			let listDiv = document.getElementById('commentList');
			let commentDiv = makeCommentView(comment); // 새로 들어온 값을 make~ => 댓글리스트+ 수정삭제 만드는 애 매개값으로 주기
			listDiv.append(commentDiv);
			
			// 입력 완료하면 form 비워주기
			document.addForm.name.value = '';
			document.addForm.content.value = '';
			
			alert("등록했습니다. [" + comment.id + "]");
		}
	}
	
	// 수정버튼 이벤트 핸들러
	function viewUpdateForm(commentId) {
		let commentDiv = document.getElementById('c' + commentId);
		let updateFormDiv = document.getElementById('commentUpdate');
		commentDiv.after(updateFormDiv);
		
		let comment = commentDiv.comment; // =={id:??, name:??}
		document.updateForm.id.value = comment.id;
		document.updateForm.name.value = comment.name;
		document.updateForm.content.value = comment.content;
		updateFormDiv.style.display = 'block';
		
	}
	
	// 변경버튼 이벤트 핸들러
	function updateComment() {
		let id = document.updateForm.id.value;
		let name = document.updateForm.name.value;
		let content = document.updateForm.content.value;
		let params = 'id=' + id + '&name=' + name + '&content=' + content + '&cmd=update';
		
		$.ajax({
			url: '../CommentsServ',
			data: params,
			dataType: 'xml',
			success: updateResult,
			error: function(a, b) { console.log(a,b)}
			
		});
	}
	
	// 수정 콜백 함수
	function updateResult(req) {
		let xmlDoc = req;
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue; // imem(0) == []
		if(code == 'success') {
			let comment = eval("("+ xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue +")");
			let listDiv = document.getElementById('commentList');
			let commentDiv = makeCommentView(comment); //태그 새로 만들고
			let oldCommentDiv = document.getElementById('c' + comment.id); // div id 가져와서
			listDiv.replaceChild(commentDiv, oldCommentDiv); // 새로 만든 태그의 id를 old id로 바꿔치기 할거야
			
			// 완료되면 수정 창 다시 display = none
			document.getElementById('commentUpdate').style.display = 'none';
			alert('수정되었습니다.');
		}
	}
	
	function confirmDeletion(id) {
		$.ajax({
			url: '../CommentsServ',
			data: 'id=' + id + '&cmd=delete',
			dataType: 'xml',
			success: deleteResult,
			error: function(a, b) {console.log(b)}
		});
	}
	
	// 삭제 콜백
	function deleteResult(req) {
		let xmlDoc = req;
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue;
		if(code == 'success') {
			let comment = eval("("+ xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue +")");
			let listDiv = document.getElementById('commentList');
			
			let commentDiv = document.getElementById('c' + comment.id);
			listDiv.removeChild(commentDiv);
			alert('삭제 되었습니다.');
			
		}
	}
	

</script>
</head>
<body>
	<div id="commentList">
		
	</div>
	
	<!-- 글 등록 화면 -->
	<div id="commentAdd">
		<form action="" name="addForm">
			<p></p>
			이름: <input type="text" name="name" size="10"><br>
			내용: <textarea name="content" cols="20" rows="2"></textarea><br>
			<input type="button" value="등록" onclick="addComment()">
			
			
		</form>
	</div>
	
	<!-- 글 수정 화면 -->
	<div id="commentUpdate" style="display: none;">
		<form action="" name="updateForm">
			<input type="hidden" name="id" value="">
			이름: <input type="text" name="name" size="10"><br>
			내용: <textarea name="content" cols="20" rows="2"></textarea><br>
			<input type="button" value="변경" onclick="updateComment()">
			<input type="button" value="취소" onclick="cancelUpdate()">
		</form>
	</div>
	
	
</body>
</html>