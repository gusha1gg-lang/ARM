<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="EditUch.aspx.cs" Inherits="_Default" Title="Справочник ТЭСК ТБД" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style2
        {
            height: 26px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="margin:5px">
<h2>Редактирование данных</h2>
    <asp:AccessDataSource ID="AccessDataSource1" runat="server" 
        DataFile="~/App_Data/AsutpDB.mdb" 
        SelectCommand="SELECT * FROM [NameUchastok] ORDER BY [Nameuchastka]"></asp:AccessDataSource>
       <asp:Panel ID="Panel1" runat="server">
            <table align="left" >
                <tr>
                    <td>
                        Название участка</td>
                    <td>
                        <asp:DropDownList ID="DDL1" runat="server" DataSourceID="AccessDataSource1" 
                            DataTextField="Nameuchastka" DataValueField="IDUchastok">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        Этаж</td>
                    <td>
                        <asp:TextBox ID="TextBox10" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Кабинет</td>
                    <td>
                        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Логин TS</td>
                    <td>
                        <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        IP адрес</td>
                    <td>
                        <asp:TextBox ID="TextBox4" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        CISCO</td>
                    <td>
                        <asp:TextBox ID="TextBox5" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        MAC адрес</td>
                    <td>
                        <asp:TextBox ID="TextBox6" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        PC/TS</td>
                    <td>
                        <asp:TextBox ID="TextBox7" runat="server"></asp:TextBox>
                        <asp:CustomValidator ID="CustomValidKE" runat="server" 
                            ErrorMessage="Братюня, КЕ с таким номером уже существует, ты уверен что желаешь добавить?" 
                            ControlToValidate="TextBox7" onservervalidate="CustomValidKE_ServerValidate"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Телефон</td>
                    <td>
                        <asp:TextBox ID="TextBox8" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Монитор</td>
                    <td>
                        <asp:TextBox ID="TextBox11" runat="server"></asp:TextBox>
                        <asp:CustomValidator ID="CustomValidMonitor" runat="server" 
                            ErrorMessage="Братюня, КЕ с таким номером уже существует, ты уверен что желаешь добавить?" 
                            ControlToValidate="TextBox11" onservervalidate="CustomValidMonitor_ServerValidate"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Принтер</td>
                    <td>
                        <asp:TextBox ID="TextBox12" runat="server"></asp:TextBox>
                        <asp:CustomValidator ID="CustomValidPrint" runat="server" 
                            ErrorMessage="Братюня, КЕ с таким номером уже существует, ты уверен что желаешь добавить?" 
                            ControlToValidate="TextBox12" onservervalidate="CustomValidPrint_ServerValidate"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td class="style2">
                        ИБП</td>
                    <td class="style2">
                        <asp:TextBox ID="TextBox13" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Модем</td>
                    <td>
                        <asp:TextBox ID="TextBox14" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Описание</td>
                    <td>
                        <asp:TextBox ID="TextBox3" runat="server" TextMode="MultiLine"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                    
                        &nbsp;</td>
                    <td>
                       
                        <asp:Button ID="Button1" runat="server" onclick="Button1_Click" 
                            Text="Сохранить" BackColor="White" BorderColor="#507CD1" 
                            BorderStyle="Solid" Font-Names="Verdana" Font-Size="X-Small" 
                            ForeColor="#284E98" />
                        <asp:Button ID="Button3" runat="server" onclick="Button3_Click" 
                            Text="Все равно сохранить" BackColor="White" BorderColor="#507CD1" 
                            BorderStyle="Solid" Font-Names="Verdana" Font-Size="X-Small" 
                            ForeColor="#284E98" Visible="False" />
                    </td>
                </tr>
                <tr>
                    <td>
                    
                        &nbsp;</td>
                    <td>
                       
                        <asp:Button ID="Button2" runat="server" onclick="Button2_Click" 
                            Text="Удалить" BackColor="White" BorderColor="#507CD1" 
                            BorderStyle="Solid" Font-Names="Verdana" Font-Size="X-Small" 
                            ForeColor="#284E98" />
                    </td>
                </tr>
            </table>
            
        </asp:Panel>
        <br/>
        
    </div>
</asp:Content>

