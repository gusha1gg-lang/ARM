<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="VideoIP.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        A { text-decoration: none; color :Black; }
   
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
    <asp:Label ID="lbVideoType" runat="server" Text="IP видеонаблюдение" 
        Font-Names="Verdana" Font-Size="Large"></asp:Label>

<table class="style2">
    <tr>
        <td>
            Цех</td>
        <td>
            <asp:DropDownList ID="Shop" runat="server" AutoPostBack="True" 
                BackColor="White" ForeColor="#284E98" 
                onselectedindexchanged="Shop_SelectedIndexChanged">
            </asp:DropDownList>
            <asp:AccessDataSource ID="AccessDataSource1" runat="server" 
                DataFile="~/App_Data/AsutpDB.mdb" 
                SelectCommand="SELECT [ShopID], [ShopName] FROM [NameShop] ORDER BY [ShopName]">
            </asp:AccessDataSource>
        </td>
    </tr>
    <tr>
        <td>
            Пролет</td>
        <td>
            <asp:DropDownList ID="Prolet" runat="server" AutoPostBack="True" 
                BackColor="White" ForeColor="#284E98" 
                onselectedindexchanged="Prolet_SelectedIndexChanged">
            </asp:DropDownList>
                <asp:AccessDataSource ID="AccessDataSource2" runat="server" 
                DataFile="~/App_Data/AsutpDB.mdb" 
                
                SelectCommand="SELECT [ShopID], [Prolet], [Prolet_name] FROM [NameProlet] WHERE ([ShopID] = ?) ORDER BY [Prolet]">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="Shop" Name="ShopID" 
                            PropertyName="SelectedValue" Type="Int32" />
                    </SelectParameters>
            </asp:AccessDataSource>
        </td>
    </tr>
    <tr>
    <td>

    </td>
    <td>
        <asp:CheckBox ID="CB_Edit" runat="server" AutoPostBack="True"
        oncheckedchanged="CB_Edit_CheckedChanged" Text="Добавление данных" />
    </td>
    </tr>
</table>
<asp:Panel ID="PanelVideoIP" runat="server">

    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" 
       DataSourceID="ODS_VideoIP" EnableModelValidation="True" DataKeyNames="ID_VID_CAM" 
        EmptyDataText="Данные по выбранному пролету отсутствуют" CellPadding="4" 
        ForeColor="#333333" ShowFooter="True">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <EditItemTemplate>
                    <asp:ImageButton ID="ImageButton1" runat="server" CausesValidation="True" 
                        CommandName="Update" ImageUrl="~/img/save.png" Text="Обновить" ToolTip="Обновить" />
                    &nbsp;<asp:ImageButton ID="ImageButton2" runat="server" CausesValidation="False" 
                        CommandName="Cancel" ImageUrl="~/img/arrow_undo.png" Text="Отмена" ToolTip="Отмена" />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:ImageButton ID="ImageButton1" runat="server" CausesValidation="False" 
                        CommandName="Edit" ImageUrl="~/img/buttonedit.png" Text="Редактировать" ToolTip="Редактировать" />
                    &nbsp;<asp:ImageButton ID="ImageButtonDel" runat="server" OnClientClick="return confirm('Уверен, что хочешь удалить?');" CausesValidation="False" 
                        CommandName="Delete" ImageUrl="~/img/cross.png" Text="Удалить" ToolTip="Удалить" />
                </ItemTemplate>
                <FooterTemplate>
                <asp:ImageButton ID="ImgBtnInsertIP" runat="server" OnClick="ImgBtnInsertIP_Click" CausesValidation="True" 
                         ImageUrl="~/img/cross_edit_add32.png" Text="Добавить" ToolTip="Добавить" />
                </FooterTemplate>
                <ItemStyle Wrap="False" />
            </asp:TemplateField>
            <asp:BoundField DataField="ID_VID_CAM" HeaderText="ID_VID_CAM" 
                SortExpression="ID_VID_CAM" Visible="False" />
            <asp:BoundField DataField="IDCAM_NAME" HeaderText="IDCAM_NAME" 
                SortExpression="IDCAM_NAME" Visible="False" />
            <asp:TemplateField HeaderText="Цех" SortExpression="ShopID">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:DropDownList ID="DDL_Tab_Shop" runat="server" DataSourceID="ADS_Shop" 
                        DataTextField="ShopName" DataValueField="ShopID" 
                        SelectedValue='<%# Bind("ShopID") %>'>
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_Shop" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" 
                        SelectCommand="SELECT [ShopID], [ShopName] FROM [NameShop] ORDER BY [ShopName]">
                    </asp:AccessDataSource>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:DropDownList ID="DDL_Foot_Tab_Shop" runat="server" DataSourceID="ADS_Shop_Foot" 
                        DataTextField="ShopName" DataValueField="ShopID">
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_Shop_Foot" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" 
                        SelectCommand="SELECT [ShopID], [ShopName] FROM [NameShop] ORDER BY [ShopName]">
                    </asp:AccessDataSource>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("ShopName") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Пролет" SortExpression="Prolet">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:DropDownList ID="DDL_Prolet" runat="server" DataSourceID="ADS_Prolet" 
                        DataTextField="Prolet_name" DataValueField="Prolet" 
                        SelectedValue='<%# Bind("Prolet") %>'>
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_Prolet" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" 
                        SelectCommand="SELECT [ProletID], [ShopID], [Prolet], [Prolet_name] FROM [NameProlet] ORDER BY [Prolet]">
                    </asp:AccessDataSource>
                </EditItemTemplate>
                <FooterTemplate>
                <asp:DropDownList ID="DDL_Foot_Prolet" runat="server" DataSourceID="ADS_Foot_Prolet" 
                        DataTextField="Prolet_name" DataValueField="Prolet">
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_Foot_Prolet" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" 
                        SelectCommand="SELECT [ProletID], [ShopID], [Prolet], [Prolet_name] FROM [NameProlet] WHERE [Prolet]<>-100 ORDER BY [Prolet]">
                    </asp:AccessDataSource>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Prolet") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Участок" SortExpression="Uchastok">
                <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Uchastok") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("Uchastok") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="txtInsert_Uchastok" runat="server" 
                        Text='<%# Bind("Uchastok") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ось" SortExpression="Oc">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBoxOCIP" runat="server" Text='<%# Bind("Oc") %>'></asp:TextBox>
                    <asp:RangeValidator
                        ID="RangeValidatorOcIP" runat="server" 
                        ErrorMessage="Номером пролета должно быть числом" ControlToValidate="TextBoxOCIP" 
                        Display="Dynamic" MaximumValue="1000" MinimumValue="-1000" Type="Integer" Text="*" 
                        ValidationGroup="AllValidators">Введите число
                    </asp:RangeValidator>
                </EditItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txtInsert_OC" runat="server" Text='<%# Bind("Oc") %>'></asp:TextBox>
                 <asp:RangeValidator
                        ID="RangeValidatorOcIPIns" runat="server" 
                        ErrorMessage="Номером пролета должно быть числом" ControlToValidate="txtInsert_OC" 
                        Display="Dynamic" MaximumValue="1000" MinimumValue="-1000" Type="Integer" Text="*" 
                        ValidationGroup="AllValidators">Введите число
                    </asp:RangeValidator>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("Oc") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="IP адрес" SortExpression="IPaddress">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("IPaddress") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txtInsert_IPAddress" runat="server" Text='<%# Bind("IPaddress") %>'></asp:TextBox>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label7" runat="server" Text='<%# Bind("IPaddress") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Имя, № камеры" SortExpression="Camera_number">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("Camera_number") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label8" runat="server" Text='<%# Bind("Camera_number") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txtInsert_Camera_number" runat="server" Text='<%# Bind("Camera_number") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Марка камеры" SortExpression="Camera_Name">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:DropDownList ID="DDL_Spr_Cameras" runat="server" 
                        DataSourceID="ODS_SPR_Cameras" DataTextField="Camera_Name" 
                        DataValueField="IDCAM_NAME" SelectedValue='<%# Bind("IDCAM_NAME") %>'>
                    </asp:DropDownList>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:DropDownList ID="DDL_Foot_Spr_Cameras" runat="server" 
                        DataSourceID="ODS_SPR_Cameras" DataTextField="Camera_Name" 
                        DataValueField="IDCAM_NAME" SelectedValue='<%# Bind("IDCAM_NAME") %>'>
                    </asp:DropDownList>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Camera_Name") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Сервер/РС" SortExpression="IP_Server_PC">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("IP_Server_PC") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label9" runat="server" Text='<%# Bind("IP_Server_PC") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txt_Insert_IPServerPC" runat="server" Text='<%# Bind("IP_Server_PC") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Изоб-е камеры" 
                SortExpression="IP_CAMERA_STREAM">
                <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                <table>
                <tr>
                <td>Файл</td>
                <td> <asp:TextBox ID="TextBox6" runat="server" 
                        Text='<%# Bind("upload_img") %>'></asp:TextBox> </td>
                </tr>

                <tr>
                <td>Ссылка</td>
                <td> <asp:TextBox ID="TextBox12" runat="server" 
                        Text='<%# Bind("IP_CAMERA_STREAM") %>'></asp:TextBox> </td>
                </tr>                
                </table>



                </EditItemTemplate>
                <ItemTemplate>
                <a href='<%# Eval("IP_CAMERA_STREAM") %>' target="_blank">
                    <asp:Image ID="ImgIpCameraStream" Height="100px" Width="100px" runat="server" 
                        AlternateText="Фото нет" ImageUrl='<%# Bind("upload_img") %>' />
                </a>
                </ItemTemplate>
                <FooterTemplate>
                <table>
                <tr>
                <td>Файл</td>
                <td> <asp:TextBox ID="txt_Insert_IP_CAM" runat="server" Text='<%# Bind("upload_img") %>' Enabled="False"></asp:TextBox></td>
                </tr>
                <tr>
                <td>Ссылка</td>
                <td><asp:TextBox ID="txtLinkFoterIP" runat="server" Text='<%# Bind("IP_CAMERA_STREAM") %>'></asp:TextBox></td>
                </tr>
                </table>
                   
                    <asp:FileUpload ID="FileUploadIP" runat="server" />
                    <asp:Button ID="btnUploadIP" runat="server"
                     Text="Загрузить" onclick="btnUploadIP_Click" />
                    <asp:Label ID="lblMessageIP" runat="server" Text=""></asp:Label>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Логин/пароль" SortExpression="Login_password">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox7" runat="server" Text='<%# Bind("Login_password") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label11" runat="server" Text='<%# Bind("Login_password") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txt_Insert_Login_password" runat="server" Text='<%# Bind("Login_password") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="CISCO" SortExpression="CISCO">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:DropDownList ID="DDL_CISCO" runat="server" DataSourceID="ADS_CISCO" 
                        DataTextField="IP_CISCO" DataValueField="ID_CISCO" SelectedValue='<%# Bind("ID_CISCO") %>'>
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_CISCO" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" SelectCommand="SELECT * FROM [SPR_CISCO]">
                    </asp:AccessDataSource>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:DropDownList ID="DDL_Foot_CISCO" runat="server" DataSourceID="ADS_FOOT_CISCO" 
                        DataTextField="IP_CISCO" DataValueField="ID_CISCO">
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_FOOT_CISCO" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" SelectCommand="SELECT * FROM [SPR_CISCO]">
                    </asp:AccessDataSource>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("IP_CISCO") %>' > </asp:Label>
                    <a class=tooltip href=#><img border=0 src="img/square-question_16.png"/><span>Пролет <%# Eval("Prolet_CISCO") %> Ось <%# Eval("Oc_CISCO")%> - <%# Eval("Location_CISCO")%> - <%# Eval("Opisanie_CISCO")%> <small></small></span></a>
                </ItemTemplate>
                <ItemStyle Wrap="False" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Порт CISCO" SortExpression="Port_CISCO">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox8" runat="server" Text='<%# Bind("Port_CISCO") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label12" runat="server" Text='<%# Bind("Port_CISCO") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txt_Insert_Port_CISCO" runat="server" Text='<%# Bind("Port_CISCO") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Вывод изображения расположение/РС" 
                SortExpression="Video_out_lacation_PC">
                <HeaderStyle Font-Bold="False" Font-Italic="False" Wrap="True" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox9" runat="server" 
                        Text='<%# Bind("Video_out_lacation_PC") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="txt_Insert_Video_out_lacation" runat="server" 
                        Text='<%# Bind("Video_out_lacation_PC") %>'></asp:TextBox>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label13" runat="server" 
                        Text='<%# Bind("Video_out_lacation_PC") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Монитор" SortExpression="Monitor">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox10" runat="server" Text='<%# Bind("Monitor") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label14" runat="server" Text='<%# Bind("Monitor") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txt_Insert_Monitor" runat="server" Text='<%# Bind("Monitor") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="Примечание" 
                SortExpression="Opisanie">
                <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox11" runat="server" Text='<%# Bind("Opisanie") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txt_Insert_Opisanie" runat="server" Text='<%# Bind("Opisanie") %>'></asp:TextBox>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label15" runat="server" Text='<%# Bind("Opisanie") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EditRowStyle BackColor="#999999" />
        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#1a4780" Font-Bold="False" Font-Italic="False" ForeColor="White" />
        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
    </asp:GridView>
    <asp:ObjectDataSource ID="ODS_VideoIP" runat="server" 
        SelectMethod="GetAllVideoCamera" TypeName="VideoCameraDataAccesseLayer" 
        DeleteMethod="DeleteVideoCamera" UpdateMethod="UpdateVideoCamera" 
        InsertMethod="InsertVideoCamera">
        <DeleteParameters>
            <asp:Parameter Name="ID_VID_CAM" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="IDCAM_NAME" Type="Int32" />
            <asp:Parameter Name="Oc" Type="Int32" />
            <asp:Parameter Name="Prolet" Type="Int32" />
            <asp:Parameter Name="ShopID" Type="Int32" />
            <asp:Parameter Name="Uchastok" Type="String" />
            <asp:Parameter Name="IPaddress" Type="String" />
            <asp:Parameter Name="Camera_number" Type="String" />
            <asp:Parameter Name="IP_Server_PC" Type="String" />
            <asp:Parameter Name="IP_CAMERA_STREAM" Type="String" />
            <asp:Parameter Name="Login_password" Type="String" />
            <asp:Parameter Name="ID_CISCO" Type="Int32" />
            <asp:Parameter Name="Port_CISCO" Type="String" />
            <asp:Parameter Name="Video_out_lacation_PC" Type="String" />
            <asp:Parameter Name="Monitor" Type="String" />
            <asp:Parameter Name="Opisanie" Type="String" />
            <asp:Parameter Name="upload_img" Type="String" />
            <asp:Parameter Name="Camera_Type" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="Shop" Name="ShopID" 
                PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Prolet" Name="Prolet" 
                PropertyName="SelectedValue" Type="Int32" />
            <asp:QueryStringParameter Name="Camera_Type" QueryStringField="VideoType" 
                Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="ID_VID_CAM" Type="Int32" />
            <asp:Parameter Name="IDCAM_NAME" Type="Int32" />
            <asp:Parameter Name="Oc" Type="Int32" />
            <asp:Parameter Name="Prolet" Type="Int32" />
            <asp:Parameter Name="ShopID" Type="Int32" />
            <asp:Parameter Name="Uchastok" Type="String" />
            <asp:Parameter Name="IPaddress" Type="String" />
            <asp:Parameter Name="Camera_number" Type="String" />
            <asp:Parameter Name="IP_Server_PC" Type="String" />
            <asp:Parameter Name="IP_CAMERA_STREAM" Type="String" />
            <asp:Parameter Name="Login_password" Type="String" />
            <asp:Parameter Name="CISCO" Type="String" />
            <asp:Parameter Name="Port_CISCO" Type="String" />
            <asp:Parameter Name="Video_out_lacation_PC" Type="String" />
            <asp:Parameter Name="Monitor" Type="String" />
            <asp:Parameter Name="Opisanie" Type="String" />
            <asp:Parameter Name="ID_CISCO" Type="Int32" />
            <asp:Parameter Name="upload_img" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ODS_SPR_Prolet" runat="server"></asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ODS_SPR_Cameras" runat="server" 
        SelectMethod="GetAllCameras" TypeName="SPR_Camera_DataAccesseLayer">
        <SelectParameters>
            <asp:QueryStringParameter Name="Camera_Type" QueryStringField="VideoType" 
                Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Panel>

<asp:Panel ID="PanelVideoAnalog" runat="server">
<asp:GridView ID="GridViewAnalog" runat="server" AutoGenerateColumns="False" 
       DataSourceID="ODS_VideoAnalog" EnableModelValidation="True" DataKeyNames="ID_VID_CAM" 
        EmptyDataText="Данные по выбранному пролету отсутствуют" CellPadding="4" 
        ForeColor="#333333" ShowFooter="True">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <EditItemTemplate>
                    <asp:ImageButton ID="ImageButton1" runat="server" CausesValidation="True" 
                        CommandName="Update" ImageUrl="~/img/save.png" Text="Обновить" ToolTip="Обновить" />
                    &nbsp;<asp:ImageButton ID="ImageButton2" runat="server" CausesValidation="False" 
                        CommandName="Cancel" ImageUrl="~/img/arrow_undo.png" Text="Отмена" ToolTip="Отмена" />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:ImageButton ID="ImageButton1" runat="server" CausesValidation="False" 
                        CommandName="Edit" ImageUrl="~/img/buttonedit.png" Text="Редактировать" ToolTip="Редактировать" />
                    &nbsp;<asp:ImageButton ID="ImageButton2" runat="server" OnClientClick="return confirm('Уверен, что хочешь удалить?');" CausesValidation="False" 
                        CommandName="Delete" ImageUrl="~/img/cross.png" Text="Удалить" ToolTip="Удалить" />
                </ItemTemplate>
                <FooterTemplate>
                <asp:ImageButton ID="ImgBtnInsertAnalog" runat="server" OnClick="ImgBtnInsertAnalog_Click" CausesValidation="True" 
                         ImageUrl="~/img/cross_edit_add32.png" Text="Добавить" ToolTip="Добавить" />
                </FooterTemplate>
                <ItemStyle Wrap="False" />
            </asp:TemplateField>
            <asp:BoundField DataField="ID_VID_CAM" HeaderText="ID_VID_CAM" 
                SortExpression="ID_VID_CAM" Visible="False" />
            <asp:BoundField DataField="IDCAM_NAME" HeaderText="IDCAM_NAME" 
                SortExpression="IDCAM_NAME" Visible="False" />
            <asp:TemplateField HeaderText="Цех" SortExpression="ShopID">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:DropDownList ID="DDL_Tab_Shop" runat="server" DataSourceID="ADS_Shop" 
                        DataTextField="ShopName" DataValueField="ShopID" 
                        SelectedValue='<%# Bind("ShopID") %>'>
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_Shop" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" 
                        SelectCommand="SELECT [ShopID], [ShopName] FROM [NameShop] ORDER BY [ShopName]">
                    </asp:AccessDataSource>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:DropDownList ID="DDL_Foot_Tab_Shop_A" runat="server" DataSourceID="ADS_Shop_Foot" 
                        DataTextField="ShopName" DataValueField="ShopID">
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_Shop_Foot" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" 
                        SelectCommand="SELECT [ShopID], [ShopName] FROM [NameShop] ORDER BY [ShopName]">
                    </asp:AccessDataSource>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("ShopName") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Пролет" SortExpression="Prolet">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:DropDownList ID="DDL_Prolet" runat="server" DataSourceID="ADS_Prolet" 
                        DataTextField="Prolet_name" DataValueField="Prolet" 
                        SelectedValue='<%# Bind("Prolet") %>'>
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_Prolet" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" 
                        SelectCommand="SELECT [ProletID], [ShopID], [Prolet], [Prolet_name] FROM [NameProlet] ORDER BY [Prolet]">
                    </asp:AccessDataSource>
                </EditItemTemplate>
                <FooterTemplate>
                <asp:DropDownList ID="DDL_Foot_Prolet_A" runat="server" DataSourceID="ADS_Foot_Prolet" 
                        DataTextField="Prolet_name" DataValueField="Prolet">
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_Foot_Prolet" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" 
                        SelectCommand="SELECT [ProletID], [ShopID], [Prolet], [Prolet_name] FROM [NameProlet] WHERE [Prolet]<>-100 ORDER BY [Prolet]">
                    </asp:AccessDataSource>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Prolet") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Участок" SortExpression="Uchastok">
                <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Uchastok") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("Uchastok") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="txtInsert_Uchastok_A" runat="server" 
                        Text='<%# Bind("Uchastok") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ось" SortExpression="Oc">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Oc") %>'></asp:TextBox>
                    <asp:RangeValidator
                        ID="RangeValidatorOc" runat="server" 
                        ErrorMessage="Номером пролета должно быть числом" ControlToValidate="TextBox1" 
                        Display="Dynamic" MaximumValue="1000" MinimumValue="-1000" Type="Integer" Text="*" 
                        ValidationGroup="AllValidators">Введите число
                    </asp:RangeValidator>
                </EditItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txtInsert_OC_A" runat="server" Text='<%# Bind("Oc") %>'></asp:TextBox>
                    <asp:RangeValidator
                        ID="RangeValidatorOcIPAn" runat="server" 
                        ErrorMessage="Номером пролета должно быть числом" ControlToValidate="txtInsert_OC_A" 
                        Display="Dynamic" MaximumValue="1000" MinimumValue="-1000" Type="Integer" Text="*" 
                        ValidationGroup="AllValidators">Введите число
                    </asp:RangeValidator>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("Oc") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Видеорегистратор (расположение)" 
                SortExpression="Video_out_lacation_PC">
                <HeaderStyle Font-Bold="False" Font-Italic="False" Wrap="True" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox9" runat="server" 
                        Text='<%# Bind("Video_out_lacation_PC") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="txt_Insert_Video_out_lacation_A" runat="server" 
                        Text='<%# Bind("Video_out_lacation_PC") %>'></asp:TextBox>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label13" runat="server" 
                        Text='<%# Bind("Video_out_lacation_PC") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="IP адрес" SortExpression="IPaddress" 
                Visible="False">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("IPaddress") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txtInsert_IPAddress_A" runat="server" Text='<%# Bind("IPaddress") %>'></asp:TextBox>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label7" runat="server" Text='<%# Bind("IPaddress") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Имя, № камеры" SortExpression="Camera_number">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("Camera_number") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label8" runat="server" Text='<%# Bind("Camera_number") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txtInsert_Camera_number_A" runat="server" Text='<%# Bind("Camera_number") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Марка камеры" SortExpression="Camera_Name">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:DropDownList ID="DDL_Spr_Cameras" runat="server" 
                        DataSourceID="ODS_SPR_Cameras" DataTextField="Camera_Name" 
                        DataValueField="IDCAM_NAME" SelectedValue='<%# Bind("IDCAM_NAME") %>'>
                    </asp:DropDownList>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:DropDownList ID="DDL_Foot_Spr_Cameras_A" runat="server" 
                        DataSourceID="ODS_SPR_Cameras" DataTextField="Camera_Name" 
                        DataValueField="IDCAM_NAME" SelectedValue='<%# Bind("IDCAM_NAME") %>'>
                    </asp:DropDownList>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Camera_Name") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Сервер/РС" SortExpression="IP_Server_PC" 
                Visible="False">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("IP_Server_PC") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label9" runat="server" Text='<%# Bind("IP_Server_PC") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txt_Insert_IPServerPC_A" runat="server" Text='<%# Bind("IP_Server_PC") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Изоб-е камеры" 
                SortExpression="IP_CAMERA_STREAM">
                <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                <table>
                <tr>
                <td>Файл</td>
                <td><asp:TextBox ID="TextBox6" runat="server" 
                        Text='<%# Bind("upload_img") %>'></asp:TextBox> </td>
                </tr>
                <tr>
                <td>Ссылка</td>
                <td><asp:TextBox ID="TextBox12" runat="server" 
                        Text='<%# Bind("IP_CAMERA_STREAM") %>'></asp:TextBox> </td>
                </tr>                
                </table>
                </EditItemTemplate>
                <ItemTemplate>
                <a href='<%# Eval("IP_CAMERA_STREAM") %>' target="_blank">
                <asp:Image ID="ImgIpCameraStream" Height="100px" Width="100px" runat="server" 
                        AlternateText="Фото нет" ImageUrl='<%# Bind("upload_img") %>' />
                </a>
                    
                </ItemTemplate>
                <FooterTemplate>
                <table>
                <tr>
                <td>Файл</td>
                <td> <asp:TextBox ID="txt_Insert_IP_CAM_A" runat="server" Text='<%# Bind("upload_img") %>' Enabled="False"></asp:TextBox></td>
                </tr>
                <tr>
                <td>Ссылка</td>
                <td><asp:TextBox ID="txtLinkFoter" runat="server" Text='<%# Bind("IP_CAMERA_STREAM") %>'></asp:TextBox></td>
                </tr>
                </table>
                   
                    <asp:FileUpload ID="FileUploadAnalog" runat="server" />
                    <asp:Button ID="btnUploadAnalog" runat="server"
                     Text="Загрузить" onclick="btnUploadAnalog_Click" />
                    <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Логин/пароль" SortExpression="Login_password">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox7" runat="server" Text='<%# Bind("Login_password") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label11" runat="server" Text='<%# Bind("Login_password") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txt_Insert_Login_password_A" runat="server" Text='<%# Bind("Login_password") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Монитор" SortExpression="Monitor">
                <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox10" runat="server" Text='<%# Bind("Monitor") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label14" runat="server" Text='<%# Bind("Monitor") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="txt_Insert_Monitor_A" runat="server" 
                        Text='<%# Bind("Monitor") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="CISCO" SortExpression="CISCO">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:DropDownList ID="DDL_CISCO" runat="server" DataSourceID="ADS_CISCO" 
                        DataTextField="IP_CISCO" DataValueField="ID_CISCO" SelectedValue='<%# Bind("ID_CISCO") %>'>
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_CISCO" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" SelectCommand="SELECT * FROM [SPR_CISCO]">
                    </asp:AccessDataSource>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:DropDownList ID="DDL_Foot_CISCO_A" runat="server" DataSourceID="ADS_FOOT_CISCO" 
                        DataTextField="IP_CISCO" DataValueField="ID_CISCO">
                    </asp:DropDownList>
                    <asp:AccessDataSource ID="ADS_FOOT_CISCO" runat="server" 
                        DataFile="~/App_Data/AsutpDB.mdb" SelectCommand="SELECT * FROM [SPR_CISCO]">
                    </asp:AccessDataSource>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("IP_CISCO") %>' > </asp:Label>
                    <a class=tooltip href=#><img border=0 src="img/square-question_16.png"/><span>Пролет <%# Eval("Prolet_CISCO") %> Ось <%# Eval("Oc_CISCO")%> - <%# Eval("Location_CISCO")%> - <%# Eval("Opisanie_CISCO")%> <small></small></span></a>
                </ItemTemplate>
                <ItemStyle Wrap="False" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Порт CISCO" SortExpression="Port_CISCO">
            <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox8" runat="server" Text='<%# Bind("Port_CISCO") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label12" runat="server" Text='<%# Bind("Port_CISCO") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txt_Insert_Port_CISCO_A" runat="server" Text='<%# Bind("Port_CISCO") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField ConvertEmptyStringToNull="False" HeaderText="Примечание" 
                SortExpression="Opisanie">
                <HeaderStyle Font-Bold="False" Font-Italic="False" />
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox11" runat="server" Text='<%# Bind("Opisanie") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txt_Insert_Opisanie_A" runat="server" Text='<%# Bind("Opisanie") %>'></asp:TextBox>
                </FooterTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label15" runat="server" Text='<%# Bind("Opisanie") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EditRowStyle BackColor="#999999" />
        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#1a4780" Font-Bold="False" Font-Italic="False" ForeColor="White" />
        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
    </asp:GridView>
<asp:ObjectDataSource ID="ODS_VideoAnalog" runat="server" 
        SelectMethod="GetAllVideoCamera" TypeName="VideoCameraDataAccesseLayer" 
        DeleteMethod="DeleteVideoCamera" UpdateMethod="UpdateVideoCamera" 
        InsertMethod="InsertVideoCamera">
        <DeleteParameters>
            <asp:Parameter Name="ID_VID_CAM" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="IDCAM_NAME" Type="Int32" />
            <asp:Parameter Name="Oc" Type="Int32" />
            <asp:Parameter Name="Prolet" Type="Int32" />
            <asp:Parameter Name="ShopID" Type="Int32" />
            <asp:Parameter Name="Uchastok" Type="String" />
            <asp:Parameter Name="IPaddress" Type="String" />
            <asp:Parameter Name="Camera_number" Type="String" />
            <asp:Parameter Name="IP_Server_PC" Type="String" />
            <asp:Parameter Name="IP_CAMERA_STREAM" Type="String" />
            <asp:Parameter Name="Login_password" Type="String" />
            <asp:Parameter Name="ID_CISCO" Type="Int32" />
            <asp:Parameter Name="Port_CISCO" Type="String" />
            <asp:Parameter Name="Video_out_lacation_PC" Type="String" />
            <asp:Parameter Name="Monitor" Type="String" />
            <asp:Parameter Name="Opisanie" Type="String" />
            <asp:Parameter Name="upload_img" Type="String" />
            <asp:Parameter Name="Camera_Type" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="Shop" Name="ShopID" 
                PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="Prolet" Name="Prolet" 
                PropertyName="SelectedValue" Type="Int32" />
            <asp:QueryStringParameter Name="Camera_Type" QueryStringField="VideoType" 
                Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="ID_VID_CAM" Type="Int32" />
            <asp:Parameter Name="IDCAM_NAME" Type="Int32" />
            <asp:Parameter Name="Oc" Type="Int32" />
            <asp:Parameter Name="Prolet" Type="Int32" />
            <asp:Parameter Name="ShopID" Type="Int32" />
            <asp:Parameter Name="Uchastok" Type="String" />
            <asp:Parameter Name="IPaddress" Type="String" />
            <asp:Parameter Name="Camera_number" Type="String" />
            <asp:Parameter Name="IP_Server_PC" Type="String" />
            <asp:Parameter Name="IP_CAMERA_STREAM" Type="String" />
            <asp:Parameter Name="Login_password" Type="String" />
            <asp:Parameter Name="CISCO" Type="String" />
            <asp:Parameter Name="Port_CISCO" Type="String" />
            <asp:Parameter Name="Video_out_lacation_PC" Type="String" />
            <asp:Parameter Name="Monitor" Type="String" />
            <asp:Parameter Name="Opisanie" Type="String" />
            <asp:Parameter Name="ID_CISCO" Type="Int32" />
            <asp:Parameter Name="upload_img" Type="String" />
        </UpdateParameters>
    </asp:ObjectDataSource>

</asp:Panel>
</div>

</asp:Content>

