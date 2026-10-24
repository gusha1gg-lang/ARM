<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="EditJR.aspx.cs" Inherits="_Default" Title="Справочник ТЭСК ТБД" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="margin:5px">
<h2>Редактирование или удаление ярлыка</h2>
<asp:Panel ID="Panel1" runat="server">
<table align="left" >
               
    <tr>
        <td>
            Название ярлыка в таблице</td>
        <td>
            <asp:TextBox ID="TextBox10" runat="server"></asp:TextBox>
        </td>
    </tr>
     <tr>
        <td>
            Название файла ярлыка (.lnk)</td>
        <td>
            <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td>
            &nbsp</td>
        <td>
            <asp:Button ID="Button1" runat="server" onclick="Button1_Click" 
                            Text="Сохранить" BackColor="White" BorderColor="#507CD1" 
                            BorderStyle="Solid" Font-Names="Verdana" Font-Size="X-Small" 
                            ForeColor="#284E98" />
        </td>
    </tr>
    <tr>
        <td>
            &nbsp</td>
        <td>
            <asp:Button ID="Button2" runat="server" onclick="Button2_Click" 
                            Text="Удалить епт" BackColor="White" BorderColor="#507CD1" 
                            BorderStyle="Solid" Font-Names="Verdana" Font-Size="X-Small" 
                            ForeColor="#284E98" />
        </td>
    </tr>
</table> 
</asp:Panel>
</div>

</asp:Content>

