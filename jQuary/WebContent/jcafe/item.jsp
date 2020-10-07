<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>item.jsp</title>
	<script src="../js/jquery-3.5.1.min.js"></script>
</head>

<body>
	<table border="1">
		<tr>
			<td>Item No</td>
			<td><input type="text" name="itemNo"></td>
		</tr>
		<tr>
			<td>Item</td>
			<td><input type="text" name="item"></td>
		</tr>
		<tr>
			<td>Category</td>
			<td><input type="text" name="category"></td>
		</tr>
		<tr>
			<td>Price</td>
			<td><input type="text" name="price"></td>
		</tr>
		<tr>
			<td>Content</td>
			<td><input type="text" name="content"></td>
		</tr>
		<tr>
			<td>Like It</td>
			<td id="likeIt"></td>
		</tr>
		<tr>
			<td>Image</td>
			<td><img id="image"></td>
		</tr>
		
	</table>
	<% 
		String itemNo = request.getParameter("itemNo");
	%>
	<script>
		$.ajax({
			url: 'GetProductServlet', // 서블릿 만들 때 경로 지정 해줬기때문에 파일이름만으로 가져올 수 있음
			data: {itemNo: '<%=itemNo%>'}, 
			dataType: 'json',
			success: function (result) {
				let data = result;
				
				// price에 포맷주기 ~
				let price = $('input[name="price"]').val(new Intl.NumberFormat('ko-KR', {
			        style: 'currency',
			        currency: 'KRW'
			    }).format(data[0].price));
				
				
				$('input[name="itemNo"]').val(data[0].itemNo);
				$('input[name="item"]').val(data[0].item);
				$('input[name="category"]').val(data[0].category);
				$('input[name="content"]').val(data[0].content);
				$('#image').attr('src', '../images/'+ data[0].image).attr('width', '300px');
				
				// 별 달기
				let star = '';
			    let cnt = Math.floor(data[0].likeIt);
			    console.log(cnt);
			    
			    for (let i = 0; i < cnt; i++) {
			        star += '&#127765';
			    }
			    
			    let half = data[0].likeIt - cnt;
			    if (half) {
			        star += '&#127767'; // 반쪽별(하얀별) 처리
			    }
			    
			    $('#likeIt').html(star);
				
			    
				
				
			},
			error: function (result) {
				console.lon(result);
			}
		});
	</script>
</body>
</html>