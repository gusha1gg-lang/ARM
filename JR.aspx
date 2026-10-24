<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="JR.aspx.cs" Inherits="_Default" Title="Справочник ТЭСК ТБД" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="margin:5px">
    <h4>
            <span style="font-family: Verdana">Список ярлыков</span></h4>
    <asp:Button ID="Button1" runat="server" onclick="Button1_Click" 
                            Text="Добавить" BackColor="White" BorderColor="#507CD1" 
                            BorderStyle="Solid" Font-Names="Verdana" Font-Size="X-Small" 
                            ForeColor="#284E98" />
    <asp:Table ID="Table1" runat="server" CellPadding="2" CellSpacing="0">
        <asp:TableRow runat="server">
            <asp:TableCell runat="server" BackColor="#507CD1" BorderColor="Black" 
                BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Left">Ярлыки</asp:TableCell>
        </asp:TableRow>
    </asp:Table>
    </div>
</asp:Content>

