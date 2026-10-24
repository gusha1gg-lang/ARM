<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="spr_shop.aspx.cs" Inherits="_Default" Title="Справочник ТЭСК ТБД" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="margin:5px">

    <asp:Label ID="Label1" runat="server" Text="Справочник цехов" 
    Font-Size="20pt"></asp:Label>

    <br />
    
    <asp:Panel ID="Panel1" runat="server">
        <asp:AccessDataSource ID="AccessDataSource1" runat="server" 
            DataFile="~/App_Data/AsutpDB.mdb" 
            DeleteCommand="DELETE FROM [NameShop] WHERE [ShopID] = ?" 
            InsertCommand="INSERT INTO [NameShop] ([ShopName]) VALUES (?)" 
            SelectCommand="SELECT * FROM [NameShop] ORDER BY [ShopName] DESC" 
            UpdateCommand="UPDATE [NameShop] SET [ShopName] = ? WHERE [ShopID] = ?">
            <DeleteParameters>
                <asp:Parameter Name="ShopID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="ShopName" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="ShopName" Type="String" />
                <asp:Parameter Name="ShopID" Type="Int32" />
            </UpdateParameters>
        </asp:AccessDataSource>

        <asp:DetailsView ID="DetailsView1" runat="server" Height="50px" Width="125px" 
            AutoGenerateRows="False" DataKeyNames="ShopID" DataSourceID="AccessDataSource1" 
            EnableModelValidation="True" CellPadding="4" ForeColor="#333333" 
            GridLines="None">
            <AlternatingRowStyle BackColor="White" />
            <CommandRowStyle BackColor="#D1DDF1" Font-Bold="True" />
            <EditRowStyle BackColor="#2461BF" />
            <FieldHeaderStyle BackColor="#DEE8F5" Font-Bold="True" />
            <Fields>
                <asp:BoundField DataField="ShopID" HeaderText="ID цеха" InsertVisible="False" 
                    ReadOnly="True" SortExpression="ShopID" />
                <asp:BoundField DataField="ShopName" HeaderText="Цех" 
                    SortExpression="ShopName" />
                <asp:CommandField ShowInsertButton="True" InsertText="Добавить" 
                    NewText="Добавить цех" />
            </Fields>
            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#EFF3FB" />
        </asp:DetailsView>
        <br />
        <asp:GridView ID="GridView1" runat="server" AllowSorting="True" 
            DataSourceID="AccessDataSource1" EnableModelValidation="True" 
            AutoGenerateColumns="False" CellPadding="2" DataKeyNames="ShopID" 
            ForeColor="Black" GridLines="None" BackColor="LightGoldenrodYellow" 
            BorderColor="Tan" BorderWidth="1px">
            <AlternatingRowStyle BackColor="PaleGoldenrod" />
            <Columns>
                <asp:BoundField DataField="ShopID" HeaderText="ID цеха" InsertVisible="False" 
                    ReadOnly="True" SortExpression="ShopID" />
                <asp:BoundField DataField="ShopName" HeaderText="Цех" 
                    SortExpression="ShopName" />
                <asp:CommandField  ButtonType ="Image" EditText="Редактировать" ShowDeleteButton="True" 
                    ShowEditButton="True" DeleteImageUrl="~/img/del.png" 
                    EditImageUrl="~/img/buttonedit.png" CancelImageUrl="~/img/arrow_undo.png" 
                    UpdateImageUrl="~/img/save.png" />
            </Columns>
            <FooterStyle BackColor="Tan" />
            <HeaderStyle BackColor="Tan" Font-Bold="True" />
            <PagerStyle BackColor="PaleGoldenrod" ForeColor="DarkSlateBlue" 
                HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
        </asp:GridView>
    </asp:Panel>
    </div>
</asp:Content>

