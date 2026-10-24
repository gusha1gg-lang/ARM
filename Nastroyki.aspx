<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="Nastroyki.aspx.cs" Inherits="_Default" Title="Справочник ТЭСК ТБД" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="margin:5px">

    <asp:Label ID="Label1" runat="server" Text="Список настроек" Font-Size="Large" 
        Font-Names="Arial"></asp:Label>
    <hr>
    <asp:HyperLink ID="HyperLink1" runat="server" Font-Names="Arial" 
        Font-Size="Medium" Target="_self" NavigateUrl="~/NastroykaOPT.htm">Инструкция по печати этикеток на окончательной приемке(Zebra)</asp:HyperLink>
    <br />
    <asp:HyperLink ID="HyperLink2" runat="server" Font-Names="Arial" 
        Font-Size="Medium" Target="_self" NavigateUrl="~/Настройка ODBC.htm">Настройка ODBC</asp:HyperLink>
    <br />
    <asp:HyperLink ID="HyperLink3" runat="server" Font-Names="Arial" 
        Font-Size="Medium" Target="_self" NavigateUrl="~/birka_akp5.htm">Настройка печати бирок на АКП5 в ДМАП ТЭСК ТБД</asp:HyperLink>
    <br />
    <asp:HyperLink ID="HyperLink4" runat="server" Font-Names="Arial" 
        Font-Size="Medium" Target="_self" NavigateUrl="~/tururushka.htm">Настройка ручных сканеров Symbol</asp:HyperLink>
    <br />
    <asp:HyperLink ID="HyperLink5" runat="server" Font-Names="Arial" 
        Font-Size="Medium" Target="_self" NavigateUrl="http://portal.vsw.ru/dit/uis/DocLib1/%D0%98%D0%BD%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%86%D0%B8%D0%B8%20%D0%B4%D0%BB%D1%8F%20%D0%B8%D0%BD%D0%B6%D0%B5%D0%BD%D0%B5%D1%80%D0%BE%D0%B2%20%D1%81%D0%BB%D1%83%D0%B6%D0%B1%D1%8B%20%D0%BF%D0%BE%D0%B4%D0%B4%D0%B5%D1%80%D0%B6%D0%BA%D0%B8/VPN%20Android.jpg">Настройки VPN Android</asp:HyperLink>
    <br />
     <asp:HyperLink ID="HyperLink6" runat="server" Font-Names="Arial" 
        Font-Size="Medium" Target="_self" NavigateUrl="http://portal.vsw.ru/dit/uis/DocLib1/%D0%98%D0%BD%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%86%D0%B8%D0%B8%20%D0%B4%D0%BB%D1%8F%20%D0%B8%D0%BD%D0%B6%D0%B5%D0%BD%D0%B5%D1%80%D0%BE%D0%B2%20%D1%81%D0%BB%D1%83%D0%B6%D0%B1%D1%8B%20%D0%BF%D0%BE%D0%B4%D0%B4%D0%B5%D1%80%D0%B6%D0%BA%D0%B8/%D0%9D%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0%20Wi-Fi%20Android%202.jpg">Настройки Wi-Fi Android</asp:HyperLink>
         
        
</div>
    
</asp:Content>

