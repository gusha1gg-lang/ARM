<%@ Language = "VBScript" %>
<% Response.Buffer = True %>

<html>

<%

' Prepare variables.

Dim oFS, oFSPath
Dim sServername, sServerinst, sPhyspath, sServerVersion 
Dim sServerIP, sRemoteIP
Dim sPath, oDefSite, sDefDoc, sDocName, aDefDoc

Dim bSuccess           ' This value is used later to warn the user if a default document does not exist.
Dim iVer               ' This value is used to pass the server version number to a function.

bSuccess = False
iVer = 0

' Get some server variables to help with the next task.

sServername = LCase(Request.ServerVariables("SERVER_NAME"))
sServerinst = Request.ServerVariables("INSTANCE_ID")
sPhyspath = LCase(Request.ServerVariables("APPL_PHYSICAL_PATH"))
sServerVersion = LCase(Request.ServerVariables("SERVER_SOFTWARE"))
sServerIP = LCase(Request.ServerVariables("LOCAL_ADDR"))      ' Server's IP address
sRemoteIP =  LCase(Request.ServerVariables("REMOTE_ADDR"))    ' Client's IP address

' If the querystring variable uc <> 1, and the user is browsing from the server machine, 
' go ahead and show them localstart.asp.  We don't want localstart.asp shown to outside users.

If Not (sServername = "localhost" Or sServerIP = sRemoteIP) Then
  Response.Redirect "iisstart.asp"
Else 

' Using ADSI, get the list of default documents for this Web site.

sPath = "IIS://" & sServername & "/W3SVC/" & sServerinst
Set oDefSite = GetObject(sPath)
sDefDoc = LCase(oDefSite.DefaultDoc)
aDefDocs = split(sDefDoc, ",")

' Make sure at least one of them is valid.

Set oFS = CreateObject("Scripting.FileSystemObject")

For Each sDocName in aDefDocs
  If oFS.FileExists(sPhyspath & sDocName) Then
    If InStr(sDocName,"iisstart") = 0 Then
      ' IISstart doesn't count because it is an IIS file.
      bSuccess = True  ' This value will be used later to warn the user if a default document does not exist.
      Exit For
    End If
  End If
Next

' Find out what version of IIS is running.

Select Case sServerVersion 
   Case "microsoft-iis/5.0"
     iVer = 50         ' This value is used to pass the server version number to a function.
   Case "microsoft-iis/5.1"
     iVer = 51
   Case "microsoft-iis/6.0"
     iVer = 60
End Select

%>

<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1251">

<script language="javascript">

  // This code is executed before the rest of the page, even before the ASP code above.
  
  var gWinheight;
  var gDialogsize;
  var ghelpwin;
  
  // Move the current window to the top left corner.
  
  window.moveTo(5,5);
  
  // Change the size of the window.

  gWinheight= 480;
  gDialogsize= "width=640,height=480,left=300,top=50,"
  
  if (window.screen.height > 600)
  {
<% if not success and Err = 0 then %>
    gWinheight= 700;
<% else %>
    gWinheight= 700;
<% end if %>
    gDialogsize= "width=640,height=480,left=500,top=50"
  }
  
  window.resizeTo(620,gWinheight);
  
  // Launch IIS Help in another browser window.
  
  loadHelpFront();

function loadHelpFront()
// This function opens IIS Help in another browser window.
{
  ghelpwin = window.open("http://localhost/iishelp/","Help","status=yes,toolbar=yes,scrollbars=yes,menubar=yes,location=yes,resizable=yes,"+gDialogsize,true);  
      window.resizeTo(620,gWinheight);
}

function activate(ServerVersion)
// This function brings up a little help window showing how to open the IIS snap-in.
{
  if (50 == ServerVersion)
    window.open("http://localhost/iishelp/iis/htm/core/iisnapin.htm", "SnapIn", 'toolbar=no, left=200, top=200, scrollbars=yes, resizeable=yes,  width=350, height=350');
  if (51 == ServerVersion)
    window.open("http://localhost/iishelp/iis/htm/core/iiabuti.htm", "SnapIn", 'toolbar=no, left=200, top=200, scrollbars=yes, resizeable=yes,  width=350, height=350');
  if (60 == ServerVersion)
    window.open("http://localhost/iishelp/iis/htm/core/gs_iissnapin.htm", "SnapIn", 'toolbar=no, left=200, top=200, scrollbars=yes, resizeable=yes,  width=350, height=350');
  if (0 == ServerVersion)
    window.open("http://localhost/iishelp/", "Help", 'toolbar=no, left=200, top=200, scrollbars=yes, resizeable=yes,  width=350, height=350');  
}

</script>

<title>Службы Интернета Windows XP Server</title>
<style>
  ul{margin-left: 15px;}
  .clsHeading {font-family: verdana; color: black; font-size: 11; font-weight: 800; width:210;}  
  .clsEntryText {font-family: verdana; color: black; font-size: 11; font-weight: 400; background-color:#FFFFFF;}    
  .clsWarningText {font-family: verdana; color: #B80A2D; font-size: 11; font-weight: 600; width:550;  background-color:#EFE7EA;}  
  .clsCopy {font-family: verdana; color: black; font-size: 11; font-weight: 400;  background-color:#FFFFFF;}  
</style>
</head>

<body topmargin="3" leftmargin="3" marginheight="0" marginwidth="0" bgcolor="#FFFFFF"
link="#000066" vlink="#000000" alink="#0000FF" text="#000000">

<!-- BEGIN MAIN DOCUMENT BODY --->

<p align="center"><img src="winXP.gif" vspace="0" hspace="0"></p>
<table width="500" cellpadding="5" cellspacing="3" border="0" align="center">

  <tr>
  <td class="clsWarningText" colspan="2">
  
  <table><tr><td>
  <img src="warning.gif" width="40" height="40" border="0" align="left">
  </td><td class="clsWarningText">
  <b>Служба Web теперь работает.
  
<% If Not bSuccess And Err = 0 Then %>
  
  <p>Для пользователей не определена страница по умолчанию.
 Пользователи, пытающиеся подключиться к вашему веб-узлу с других компьютеров, попадают на страницу 
  <a href="iisstart.asp?uc=1">В процессе разработки</a> .
  Веб-сервер допускает использование в качестве веб-страниц по умолчанию следующих файлов: <%=sDefDoc%>. В настоящее время существует только файл iisstart.asp.<br><br>
  
<% End If %>

  Чтобы добавить документы на веб-узел по умолчанию, сохраните файлы в каталоге <%=sPhyspath%>. 
  </b>
  </td></tr></table>
 
  </td>
  </tr>
  
  <tr>
  <td>
  <table cellpadding="3" cellspacing="3" border=0 >
  <tr>
    <td valign="top" rowspan=3>
      <img src="web.gif">
    </td>  
    <td valign="top" rowspan=3>
  <span class="clsHeading">
  IIS 5.1</span><br>
      <span class="clsEntryText">    
    Internet Information Services (IIS) 5.1 для Microsoft Windows XP Professional
    позволяет Windows использовать 
    все возможности Интернета. С помощью IIS можно обеспечивать общий доступ к файлам и принтерам, а также создавать приложения
    для безопасной публикации информации в Интернете с целью совместного использования ее сотрудниками вашей организации. IIS - это надежная платформа  
    для создания и развертывания в Интернете решений для электронной коммерции и других приложений.
  <p>
    Windows XP Professional с установленной службой IIS позволяет выполнять следующие задачи.</span>
  <p>
    <ul class="clsEntryText">
      <li>Создание личного веб-сервера
      <li>Совместное использование информации
      <li>Доступ к базам данных
      <li>Разработка интрасети предприятия
      <li>Разработка приложений для Интернета.
    </ul>
  <p>
  <span class="clsEntryText">
    IIS интегрирует Windows с общепризнанными стандартами Интернета, поэтому для работы в Интернете не требуется 
    изучать новые способы публикации, разработки и изменения содержимого. 
  <p>
  </span>
  </td>

    <td valign="top">
      <img src="mmc.gif">
    </td>
    <td valign="top">
      <span class="clsHeading">Встроенное управление</span>
      <br>
      <span class="clsEntryText">
        Управление IIS осуществляется с помощью консоли 'Управление компьютером' <a href="javascript:activate(<%=iVer%>);">Windows XP</a> 
        или посредством сценариев. Консоль позволяет также предоставлять общий доступ к содержимому узлов и серверов, работающих под управлением 
        Internet Information Services,  другим пользователям Интернета. В оснастке IIS консоли можно 
        настроить наиболее общие свойства и параметры IIS. Помимо разработки узлов и приложений эти свойства и параметры можно применять в 
        средах, использующих более мощные версии серверов Windows.  
      <p>
       
      </span>
    </td>
  </tr>
  <tr>
    <td valign="top">
      <img src="help.gif">
    </td>
    <td valign="top">
      <span class="clsHeading"><a href="javascript:loadHelpFront();">Интерактивная документация</a></span>
      <br>
      <span class="clsEntryText">Интерактивная документация по IIS включает предметный указатель, а также средства полнотекстового поиска 
        и печати отдельных разделов и статей. Вместе с IIS устанавливаются примеры программного администрирования
 и сценариев. Файлы справки хранятся в формате 
        HTML, что позволяет при необходимости изменять и публиковать их. Интерактивная документация по IIS 
        позволяет выполнять следующие задачи.<p>
      </span>
      <ul class="clsEntryText">
         <li>Получение справки по выполнению конкретных задач
         <li>Получение сведений по работе с сервером и управлению им
         <li>Получение сведений о других источниках информации
         <li>Просмотр примеров программ.
      </ul>
      <p>
        <span class="clsEntryText">
        Другие источники ценной информации об IIS находятся на веб-узлах Microsoft.com: 
        MSDN, TechNet и Windows.
        </span>
    </td>
  </tr>
  
  <tr>
    <td valign="top">
      <img src="print.gif">
    </td>
    <td valign="top">
      <span class="clsHeading">Веб-печать</span>
      <br>
      <span class="clsEntryText">Windows XP Professional ведет динамический список всех принтеров 
        вашего сервера на доступном веб-узле. На этом веб-узле Вы можете просматривать 
        принтеры и их задания. С помощью этого узла вы также можете подключаться к этим принтерам 
        с любого компьютера под управлением Windows. Дополнительные сведения о печати через Интернет см. в справке Windows.
      </span>
    </td>
  </tr>
  
  </table>
</td>
</tr>
</table>

<p align=center><em><a href="/iishelp/common/colegal.htm">© Корпорация Майкрософт (Microsoft Corporation),  1997-2001. Все права защищены.</a></em></p>

</body>
</html>

<% End If %>

