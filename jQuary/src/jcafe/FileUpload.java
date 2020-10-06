package jcafe;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/FileUpload")
@MultipartConfig(location="c:/tmp", maxFileSize=1024000L, maxRequestSize = -1, fileSizeThreshold = 1024)
public class FileUpload extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
    public FileUpload() {
        super();
        
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 한글 출력하기
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=UTF-8");
		
		Collection<Part> parts = request.getParts();
		String filename = "";
		String filepath = request.getServletContext().getRealPath("/images"); 
		
		System.out.println(filepath); //파일이 저장될 경로 출력
		
		for(Part part : parts) {
			filename = part.getSubmittedFileName();
			
			System.out.println("filename: " + part.getSubmittedFileName()); // 파일 이름 출력
			System.out.println("filesize: " + part.getSize()); // 파일 사이즈 출력
			System.out.println("parameter name: " + part.getName());  // 파라미터 이름 출력
			
			part.write(filepath + "/" + part.getSubmittedFileName()); // 파일이름 붙일 때 경로로 붙여야 되니까 / 추가
		}
		PrintWriter out = response.getWriter();
		out.println("<script>");
		out.println("opener.frm.image.value='" + filename + "';");
		out.println("window.close();");
		out.println("</script>");
//		doGet(request, response);
	}

}
