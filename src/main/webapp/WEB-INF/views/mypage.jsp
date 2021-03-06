<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <!-- Kakao -->
    <script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
  </head>
  <body>
    <jsp:include page="include.jsp" />

    <div id="button">
      <c:if test='${empty id}'>
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">
          LOGIN
        </button>
        <a id="kakao-login-btn"></a>
      </c:if>
      <c:if test='${not empty id}'>
        <button type="button" id="logout">LOGOUT</button>
        <h1>${session}</h1>
      </c:if>
    </div>

    <!-- 로그인 모달 -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        </div>
          <div class="modal-body">
            <form action="loginAjax" method="post">
              <div class="form-group">
                <label for="exampleInputEmail1">ID</label>
                <input type="email" class="form-control" id="id" placeholder="이메일을 입력하세요">
              </div>
              <div class="form-group">
                <label for="exampleInputPassword1">PW</label>
                <input type="password" class="form-control" id="pw" placeholder="암호">
              </div>
              <button type="button" id="signup" class="btn btn-default">SIGNUP</button>
              <button type="button" id="login" class="btn btn-default">LOGIN</button>
            </form>
          </div>
        </div>
      </div>
    </div>

  </body>
</html>

<script>
//회원가입 페이지 이동
$('#signup').click(function(){
  location.href="/forder/signup";
})

//로그인
$('#login').click(function(){
  $.ajax({
    type: "POST",
    url: "/forder/login",
    data:{
      "id": $('#id').val(),
      "pw": $('#pw').val(),
    },
    success: function(result){
      if(result == "seller"){
        location.href="/forder/seller";
      }
      $('.close').trigger("click");
      $('#button').load(window.location.href + "#button");
    },
    error: function(){
      alert("LOGIN FAIL")
    }
  })
})

//카카오 로그인 API
<c:if test='${empty id}'>
  // 사용할 앱의 JavaScript 키를 설정해 주세요.
  Kakao.init('a7462a3c5074c7223a0efc1b182f553d');
  // 카카오 로그인 버튼을 생성합니다.
  Kakao.Auth.createLoginButton({
    container: '#kakao-login-btn',
    success: function(authObj) {
      Kakao.API.request({
        url: '/v2/user/me',
        success: function(res) {
          console.log(res.id); //id 정보 출력
          console.log(res.properties.nickname); //닉네임 출력
          console.log(authObj.access_token); //토큰값 출력
          $.post("/forder/kakaoLogin", {
            id: res.id,
            name: res.properties.nickname,
            token: authObj.access_token
          }).done(function(result){
            if(result=="fail"){
              location.href="/forder/kakaoSignup?id=" + res.id + "&pw=kakaoSignup";
            }
            $('#button').load(window.location.href + "#button");
          })
       }
      })
    },
    fail: function(err) {
       alert(JSON.stringify(err));
    }
  });
</c:if>

// 로그아웃
$('#logout').click(function(){
  $.ajax({
    type: "POST",
    url: "/forder/logout",
    success: function(){
      $('#button').load(window.location.href + "#button");
    },
    error: function(){
      alert("LOGOUT FAIL")
    }
  })
})
</script>
