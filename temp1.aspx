<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="temp1.aspx.cs" Inherits="temp1" Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style3
        {
            width: 100%;
            border-style: solid;
            border-width: 1px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:Button ID="Button1" runat="server" 
        Text="Сколько" onclick="Button1_Click" />

    <asp:ImageButton ID="ImageButton1" runat="server" 
        ImageUrl="~/img/buttonedit.png" />

    <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/img/ipt4but1.jpg" 
        onprerender="ImageButton2_PreRender" />

    <br />
    <table class="style3">
        <tr>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
    </table>

</asp:Content>

