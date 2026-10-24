<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="SPR_CISCO.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="margin:5px" >
<asp:Label ID="lb_Spr" runat="server" Text="" 
    Font-Names="Verdana" Font-Size="Large"></asp:Label>
<asp:Panel ID="PanelCisco" runat="server">
    <asp:GridView ID="GV_CISCO" runat="server" AutoGenerateColumns="False" 
        BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" 
        CellPadding="2" DataKeyNames="ID_CISCO" DataSourceID="ADS_CISCO" 
        EnableModelValidation="True" ForeColor="Black" ShowFooter="True">
        <AlternatingRowStyle BackColor="PaleGoldenrod" />
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
                    <asp:ImageButton ID="ImgBtnInsert" runat="server" ImageUrl="~/img/cross_edit_add32.png" OnClick="ImgBtnInsert_Click" Text="Добавить" ToolTip="Добавить"/>
                </FooterTemplate>
                <FooterStyle Wrap="False" />
                <ItemStyle Wrap="False" />
            </asp:TemplateField>
            <asp:BoundField DataField="ID_CISCO" HeaderText="ID_CISCO" 
                InsertVisible="False" ReadOnly="True" SortExpression="ID_CISCO" 
                ConvertEmptyStringToNull="False" Visible="False" />
            <asp:TemplateField HeaderText="IP_CISCO" SortExpression="IP_CISCO" 
                ConvertEmptyStringToNull="False">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("IP_CISCO") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("IP_CISCO") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                   <asp:TextBox ID="TBox_ins_IPCISCO" runat="server" Text='<%# Bind("IP_CISCO") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Пролет" SortExpression="Prolet_CISCO" 
                ConvertEmptyStringToNull="False">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Prolet_CISCO") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Prolet_CISCO") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                   <asp:TextBox ID="TBox_ins_ProletCISCO" runat="server" Text='<%# Bind("Prolet_CISCO") %>'></asp:TextBox>
                    <asp:RangeValidator
                        ID="RangeValidatorProlet" runat="server" 
                        ErrorMessage="Номером пролета должно быть числом" ControlToValidate="TBox_ins_ProletCISCO" 
                        Display="Dynamic" MaximumValue="1000" MinimumValue="-1000" Type="Integer" Text="*" 
                        ValidationGroup="AllValidators">Введите число
                    </asp:RangeValidator>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ось" SortExpression="Oc_CISCO" 
                ConvertEmptyStringToNull="False">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("Oc_CISCO") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Oc_CISCO") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                   <asp:TextBox ID="TBox_ins_OC_CISCO" runat="server" Text='<%# Bind("Oc_CISCO") %>'></asp:TextBox>
                   <asp:RangeValidator
                        ID="RangeValidator_OC" runat="server" 
                        ErrorMessage="Номером пролета должно быть число" ControlToValidate="TBox_ins_OC_CISCO" 
                        Display="Dynamic" MaximumValue="1000" MinimumValue="-1000" Type="Integer" Text="*" 
                        ValidationGroup="AllValidators">Введите число
                    </asp:RangeValidator>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Расположение" SortExpression="Location_CISCO" 
                ConvertEmptyStringToNull="False">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("Location_CISCO") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("Location_CISCO") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                   <asp:TextBox ID="TBox_ins_Loc_CISCO" runat="server" Text='<%# Bind("Location_CISCO") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Примечание" SortExpression="Opisanie_CISCO" 
                ConvertEmptyStringToNull="False">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("Opisanie_CISCO") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("Opisanie_CISCO") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                   <asp:TextBox ID="TBox_ins_Opis_CISCO" runat="server" Text='<%# Bind("Opisanie_CISCO") %>'></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
        </Columns>
        <FooterStyle BackColor="Tan" />
        <HeaderStyle BackColor="Tan" Font-Bold="True" />
        <PagerStyle BackColor="PaleGoldenrod" ForeColor="DarkSlateBlue" 
            HorizontalAlign="Center" />
        <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
    </asp:GridView>
    <asp:AccessDataSource ID="ADS_CISCO" runat="server" 
        DataFile="~/App_Data/AsutpDB.mdb" 
        DeleteCommand="DELETE FROM [SPR_CISCO] WHERE [ID_CISCO] = ?" 
        InsertCommand="INSERT INTO [SPR_CISCO] ([IP_CISCO], [Prolet_CISCO], [Oc_CISCO], [Location_CISCO], [Opisanie_CISCO]) VALUES (?, ?, ?, ?, ?)" 
        SelectCommand="SELECT * FROM [SPR_CISCO] ORDER BY [IP_CISCO]" 
        UpdateCommand="UPDATE [SPR_CISCO] SET [IP_CISCO] = ?, [Prolet_CISCO] = ?, [Oc_CISCO] = ?, [Location_CISCO] = ?, [Opisanie_CISCO] = ? WHERE [ID_CISCO] = ?">
        <DeleteParameters>
            <asp:Parameter Name="ID_CISCO" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="IP_CISCO" Type="String" />
            <asp:Parameter Name="Prolet_CISCO" Type="Int32" />
            <asp:Parameter Name="Oc_CISCO" Type="Int32" />
            <asp:Parameter Name="Location_CISCO" Type="String" />
            <asp:Parameter Name="Opisanie_CISCO" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="IP_CISCO" Type="String" />
            <asp:Parameter Name="Prolet_CISCO" Type="Int32" />
            <asp:Parameter Name="Oc_CISCO" Type="Int32" />
            <asp:Parameter Name="Location_CISCO" Type="String" />
            <asp:Parameter Name="Opisanie_CISCO" Type="String" />
            <asp:Parameter Name="ID_CISCO" Type="Int32" />
        </UpdateParameters>
    </asp:AccessDataSource>

    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
</asp:Panel>

<asp:Panel ID="PanelCamera" runat="server">
    <asp:GridView ID="GV_CAMERA" runat="server" AutoGenerateColumns="False" 
        BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" 
        CellPadding="2" DataKeyNames="IDCAM_NAME" DataSourceID="ADS_Camera" 
        EnableModelValidation="True" ForeColor="Black" ShowFooter="True">
        <AlternatingRowStyle BackColor="PaleGoldenrod" />
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
                    <asp:ImageButton ID="ImgBtnInsertCameraType" runat="server" ImageUrl="~/img/cross_edit_add32.png" OnClick="ImgBtnInsertCameraType_Click" Text="Добавить" ToolTip="Добавить"/>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="IDCAM_NAME" HeaderText="IDCAM_NAME" 
                InsertVisible="False" ReadOnly="True" SortExpression="IDCAM_NAME" 
                Visible="False" />
            <asp:TemplateField HeaderText="Тип камеры" SortExpression="Camera_Type">
                <EditItemTemplate>
                <asp:DropDownList ID="DDL_Camera_Type" runat="server" SelectedValue='<%# Bind("Camera_Type") %>'>
                    <asp:ListItem>IP</asp:ListItem>
                    <asp:ListItem>Analog</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Camera_Type") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                    <asp:DropDownList ID="DDL_Camera_Type" runat="server">
                    <asp:ListItem>IP</asp:ListItem>
                    <asp:ListItem>Analog</asp:ListItem>
                    </asp:DropDownList>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Марка камеры" SortExpression="Camera_Name" 
                ConvertEmptyStringToNull="False">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Camera_Name") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Camera_Name") %>'></asp:Label>
                </ItemTemplate>
                <FooterTemplate>
                <asp:TextBox ID="txtIns_CameraName" runat="server" Text='<%# Bind("Camera_Name") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Введи марку камеры"  Text="*" ForeColor="Red" 
                     ControlToValidate="txtIns_CameraName" ></asp:RequiredFieldValidator>
                </FooterTemplate>
            </asp:TemplateField>
        </Columns>
        <FooterStyle BackColor="Tan" />
        <HeaderStyle BackColor="Tan" Font-Bold="True" />
        <PagerStyle BackColor="PaleGoldenrod" ForeColor="DarkSlateBlue" 
            HorizontalAlign="Center" />
        <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
    </asp:GridView>
    <asp:AccessDataSource ID="ADS_Camera" runat="server" 
        DataFile="~/App_Data/AsutpDB.mdb" 
        DeleteCommand="DELETE FROM [SPR_CAMERA] WHERE [IDCAM_NAME] = ?" 
        InsertCommand="INSERT INTO [SPR_CAMERA] ([Camera_Type], [Camera_Name]) VALUES (?, ?)" 
        SelectCommand="SELECT * FROM [SPR_CAMERA] ORDER BY [Camera_Type]" 
        UpdateCommand="UPDATE [SPR_CAMERA] SET [Camera_Type] = ?, [Camera_Name] = ? WHERE [IDCAM_NAME] = ?">
        <DeleteParameters>
            <asp:Parameter Name="IDCAM_NAME" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Camera_Type" Type="String" />
            <asp:Parameter Name="Camera_Name" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Camera_Type" Type="String" />
            <asp:Parameter Name="Camera_Name" Type="String" />
            <asp:Parameter Name="IDCAM_NAME" Type="Int32" />
        </UpdateParameters>
    </asp:AccessDataSource>
    <asp:ValidationSummary ID="ValidationSummary2" runat="server" />
</asp:Panel>
</div>
</asp:Content>

