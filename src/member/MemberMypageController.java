package member;

import DAO.MemberDAO;
import common.IndexController;
import common.SuperClass;
import VO.MemberVO;
import DAO.MemberDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class MemberMypageController extends SuperClass {
    @Override
    public void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        MemberVO tem = (MemberVO)session.getAttribute("loginfo");
        MemberDAO dao = new MemberDAO();

        try {
            MemberVO mem = dao.selectMember(tem.getId(), tem.getPassword());
            session.setAttribute("loginfo", mem);
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
            new IndexController().doGet(request, response);
        }

        super.doProcess(request, response);
        super.GotoPage("/member/mypage.jsp");
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doProcess(request, response);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if(session.getAttribute("loginfo") == null){
            new IndexController().doGet(request, response);
        }
        this.doProcess(request, response);
    }
}
