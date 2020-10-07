package jcafe;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONArray;


@WebServlet("/jcafe/GetProductServlet")
public class GetProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
    public GetProductServlet() {
        super();
      
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("utf-8"); 
		response.setContentType("text/html;charset=UTF-8");
		
		String itemNo = request.getParameter("itemNo");
		response.setContentType("text/html;charset=UTF-8");
		
		ProductDAO dao = new ProductDAO();
		ProductVO vo = dao.getProduct(itemNo);
		
		response.getWriter().append(JSONArray.fromObject(vo).toString()); //제이슨파일로 만들기
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
