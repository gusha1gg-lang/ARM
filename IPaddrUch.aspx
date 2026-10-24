<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="IPaddrUch.aspx.cs" Inherits="_Default" Title="Справочник ТЭСК ТБД" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        A { text-decoration: none; color :Black; }
        .style2
        {
            width: 250px;
            font-family: Verdana;
        }
.tooltip { position: relative; }
.tooltip span {
  position: absolute;
  right: 0;
  top: -30px;
  display: none;
  min-width: 50px;
  padding: 3px 8px;
  white-space: nowrap;
  font-size: 14px;
  text-align: right;
  background-color: rgba(0,0,0,.8);
  -webkit-border-radius: 5px;
  -moz-border-radius: 5px;
  color: #fff;
}
.tooltip span small {
  position: absolute;
  right: 10px;
  bottom: -6px;
  border-top: 6px solid rgba(0,0,0,.8);
  border-left: 6px solid transparent;
}
.tooltip:hover span { display: block; }
.tooltip span { background-color: #000; }
.tooltip span small { border-top: 6px solid #000; }
 
/* фиксим проблему со стрелочкой в IE 6 */
 
*html .tooltip span small {
  border-left: 6px solid #363636; /* Соответствует цвету фона */
}
 
/* фиксим проблему в IE 8 */
 
.tooltip span { background-color /*\**/: #000\9  }
.tooltip span small { border-top /*\**/: 6px solid #000; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="margin:5px" >
        <h4 style="font-family: Verdana" >
            <span>Информация об АРМ на внешних участках</span></h4>
        
            <table class="style2">
                <tr>
                    <td>
                        Показать участок</td>
                    <td>
                        <asp:DropDownList ID="Uchastok" runat="server" AutoPostBack="True" 
                            BackColor="White" ForeColor="#284E98" 
                            onselectedindexchanged="Uchastok_SelectedIndexChanged">
                            
                            
                        </asp:DropDownList>
                        <asp:AccessDataSource ID="AccessDataSource1" runat="server" 
                            DataFile="~/App_Data/AsutpDB.mdb" 
                            
                            SelectCommand="SELECT [IDUchastok], [Nameuchastka] FROM [NameUchastok] ORDER BY [Nameuchastka]">
                        </asp:AccessDataSource>
                    </td>
                </tr>
            </table>
       
            <br />
            
            <asp:Button ID="Button1" runat="server" BackColor="White" BorderColor="#507CD1" 
                BorderStyle="Solid" Font-Size="X-Small" ForeColor="#284E98" 
                onclick="Button1_Click" Text="Добавить" />
            <asp:Table ID="Table1" runat="server" CellPadding="2" CellSpacing="0">
                <asp:TableRow runat="server" ID="TableRow1">
                    <asp:TableCell ID="TableCell1" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">Этаж</asp:TableCell>
                    <asp:TableCell ID="TableCell2" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">Кабинет</asp:TableCell>    
                    <asp:TableCell ID="TableCell3" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">Логин TS</asp:TableCell>
                    <asp:TableCell ID="TableCell4" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">IP адрес</asp:TableCell>
                    <asp:TableCell ID="TableCell5" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">CISCO</asp:TableCell>
                    <asp:TableCell ID="TableCell6" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">MAC адрес</asp:TableCell>
                    <asp:TableCell ID="TableCell7" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">PC/TS</asp:TableCell>
                    <asp:TableCell ID="TableCell8" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">Телефон</asp:TableCell>
                    <asp:TableCell ID="TableCell9" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">Монитор</asp:TableCell>
                    <asp:TableCell ID="TableCell10" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">Принтер</asp:TableCell>
                    <asp:TableCell ID="TableCell11" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">ИБП</asp:TableCell>
                    <asp:TableCell ID="TableCell12" runat="server" BackColor="#1a4780" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" HorizontalAlign="Center" 
                        ForeColor="White">Модем</asp:TableCell>
                    
                </asp:TableRow>
            </asp:Table>
        
        
            <span style="font-family: Verdana"></span>
          
    </div>
</asp:Content>

