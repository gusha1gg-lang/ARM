<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="Addipt5.aspx.cs" Inherits="_Default" Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style2
        {
            height: 25px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="margin:5px">
<h2>Добавление данных</h2>
    
       
            <table align="left" >
               
                <tr>
                    <td>
                        Название участка</td>
                    <td>
                        <asp:TextBox ID="TextBox10" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Ось</td>
                    <td>
                        <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox><asp:RequiredFieldValidator
                            ID="RequiredFieldValidator1" runat="server" 
                            ErrorMessage="Неправильный формат данных" ControlToValidate="TextBox2" 
                            Display="Dynamic" ValidationGroup="AllValidators">*</asp:RequiredFieldValidator><asp:RangeValidator
                                ID="RangeValidator1" runat="server" ErrorMessage="Должно быть число" 
                            ControlToValidate="TextBox2" Display="Dynamic" MaximumValue="10000" 
                            MinimumValue="0" Type="Integer" ValidationGroup="AllValidators">Должно быть 
                        число</asp:RangeValidator>
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
                        Логин TS</td>
                    <td>
                        <asp:TextBox ID="TextBox11" runat="server"></asp:TextBox>
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
                        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                        <asp:CustomValidator ID="CustomValidMonitor" runat="server" 
                            ErrorMessage="КЕ с таким номером уже существует, ты уверен что желаешь сохранить?" 
                            ControlToValidate="TextBox1" onservervalidate="CustomValidMonitor_ServerValidate"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Принтер</td>
                    <td>
                        <asp:TextBox ID="TextBox3" runat="server" Height="22px"></asp:TextBox>
                        <asp:CustomValidator ID="CustomValidPrint" runat="server" 
                            ErrorMessage="КЕ с таким номером уже существует, ты уверен что желаешь сохранить?" 
                            ControlToValidate="TextBox3" onservervalidate="CustomValidPrint_ServerValidate"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        ИБП</td>
                    <td>
                        <asp:TextBox ID="TextBox5" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Модем</td>
                    <td>
                        <asp:TextBox ID="TextBox9" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="style2">
                        CISCO</td>
                    <td class="style2">
                        <asp:TextBox ID="TextBox12" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Описание</td>
                    <td>
                        <asp:TextBox ID="TextBox13" runat="server" TextMode="MultiLine"></asp:TextBox>
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
                        <asp:Button ID="Button2" runat="server" onclick="Button2_Click" 
                            Text="Все равно сохранить" BackColor="White" BorderColor="#507CD1" 
                            BorderStyle="Solid" Font-Names="Verdana" Font-Size="X-Small" 
                            ForeColor="#284E98" Visible="False" />
                    
                    </td>
                </tr>
            </table>
            
        
        <br/>
        
    </div>
</asp:Content>

