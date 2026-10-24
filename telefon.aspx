<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="telefon.aspx.cs" Inherits="_Default" Title="Справочник ТЭСК ТБД" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="margin:5px">

    <asp:Label ID="Label1" runat="server" Text="Список телефонов" 
    Font-Size="20pt"></asp:Label>
    
    
    <br />
    <asp:AccessDataSource ID="AccessDataSource1" runat="server" 
        DataFile="~/App_Data/AsutpDB.mdb" 
        SelectCommand="SELECT * FROM [telefon]" 
        DeleteCommand="DELETE FROM [telefon] WHERE [id] = ?" 
        InsertCommand="INSERT INTO [telefon] ([fio], [telnumber]) VALUES (?, ?)" 
        OldValuesParameterFormatString="original_{0}" 
        
        UpdateCommand="UPDATE [telefon] SET [fio] = ?, [telnumber] = ? WHERE [id] = ?">
        <DeleteParameters>
            <asp:Parameter Name="original_id" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="fio" Type="String" />
            <asp:Parameter Name="telnumber" Type="String" />
            <asp:Parameter Name="original_id" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            
            <asp:Parameter Name="fio" Type="String" />
            <asp:Parameter Name="telnumber" Type="String" />
        </InsertParameters>
    </asp:AccessDataSource>
    
    <asp:Panel ID="Panel1" runat="server">
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" 
    CellPadding="4" DataKeyNames="id" DataSourceID="AccessDataSource1" 
    ForeColor="Black" GridLines="Vertical" AllowSorting="True" 
        onselectedindexchanged="GridView1_SelectedIndexChanged">
        <RowStyle BackColor="#F7F7DE" />
        <Columns>
            <asp:BoundField DataField="fio" HeaderText="ФИО" SortExpression="fio" />
            <asp:BoundField DataField="telnumber" HeaderText="Телефон" 
                SortExpression="telnumber" />
        </Columns>
        <FooterStyle BackColor="#CCCC99" />
        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
    </asp:Panel>
    <asp:Panel ID="Panel2" runat="server" Visible="False">
    <asp:DetailsView ID="DetailsView1" runat="server" Height="50px" Width="125px" 
            AllowPaging="True" AutoGenerateRows="False" BackColor="White" 
            BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" 
            DataKeyNames="id" DataSourceID="AccessDataSource1" GridLines="Vertical">
            <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
            <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
            <Fields>
                <asp:BoundField DataField="fio" HeaderText="ФИО" SortExpression="fio" />
                <asp:BoundField DataField="telnumber" HeaderText="Телефон" 
                    SortExpression="telnumber" />
                <asp:CommandField 
                    ShowInsertButton="True" NewText="Добавить" />
            </Fields>
            <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
            <EditRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="#DCDCDC" />
        </asp:DetailsView>
        
        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" 
    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" 
    CellPadding="4" DataKeyNames="id" DataSourceID="AccessDataSource1" 
    ForeColor="Black" GridLines="Vertical" AllowSorting="True" 
        onselectedindexchanged="GridView1_SelectedIndexChanged">
        <RowStyle BackColor="#F7F7DE" />
            <Columns>
                <asp:BoundField DataField="fio" HeaderText="ФИО" SortExpression="fio" />
                <asp:BoundField DataField="telnumber" HeaderText="Телефон" 
                    SortExpression="telnumber" />
                <asp:CommandField DeleteText="Удалить" EditText="Изменить" 
                    ShowDeleteButton="True" ShowEditButton="True" />
            </Columns>
        <FooterStyle BackColor="#CCCC99" />
        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
        
    </asp:Panel>
    </div>
</asp:Content>

