<%@ Page Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="Webnav.aspx.cs" Inherits="_Default" Title="Справочник ТЭСК ТБД" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style2
        {
            width: 500px;
        }
        .style3
        {
            text-decoration: underline;
            font-size: medium;
        }
        .style4
        {
        }
        .style5
        {
            font-style: italic;
        }
        .style6
        {
            font-weight: bold;
            font-style: italic;
        }
        .style7
        {
            font-size: medium;
        }
        .style8
        {
            font-weight: bold;
            text-decoration: underline;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="margin:5px">
    <table align="left" cellpadding="0" class="style2">
        <tr>
            <td>
                <h4 class="style3">
                    WEB NAVIGATOR</h4>
            </td>
        </tr>
        <tr>
            <td class="style7">
                <b>1. Сервер (система регистации температуры АКП3,4)</b><br />
                <a href="https://scada-003.d0.vsw.ru">https://scada-003.d0.vsw.ru</a> или <a href="https://10.100.210.147">
                http://10.100.210.147</a> </td>
        </tr>
        <tr>
            <td class="style7">
                <span class="style8">Форма для мастеров</span><br />
                <i>login</i>: master34<br />
                <i>Pass</i>: 123456</td>
        </tr>
        <tr>
            <td class="style7">
                <span class="style8">Форма для АКП №3</span><br />
                <i>login</i>: akp3<br />
                <i>Pass</i>: 123456</td>
        </tr>
        <tr>
            <td class="style7">
                <span class="style4"><span class="style8">Форма для АКП №4</span><br />
                </span><span class="style5">login</span><span class="style6">: </span>akp4<br />
                <i>Pass</i>: 123456</td>
        </tr>
	<tr>
            <td class="style7">
                <span class="style8">Просмотр счетчиков СААРЦ</span><br />
                <i>login</i>: user<br />
                <i>Pass</i>: 12345678</td>
        </tr>
        <tr>
            <td class="style7">
                <span class="style8">Форма технологической диагностики АКП 2, 3, 4, 5</span><br />
                <i>login</i>: akptd<br />
                <i>Pass</i>: 123456</td>
        </tr>
        <tr>
            <td class="style7">
                <b>2. Сервер (система регистрации температуры внутреннее АКП)</b><br />
                <a href="https://scada-003.d0.vsw.ru">https://scada-003.d0.vsw.ru</a> или <a href="https://10.100.210.147">
                http://10.100.210.147</a> </td>
        </tr>
        <tr>
            <td class="style7">
                <span class="style8">Форма для внутреннего покрытия</span><br />
                <i>login</i>: akpvn<br />
                <i>Pass</i>: 123456</td>
        </tr>
        <tr>
            <td class="style7">
                <span class="style8">Форма для станков КЖ</span><br />
                <i>login</i>: stkg<br />
                <i>Pass</i>: 123456</td>
        </tr>
	<tr>
            <td class="style7">
                <span class="style8">Форма технологической диагностики внутреннего АКП</span><br />
                <i>login</i>: akptd<br />
                <i>Pass</i>: 123456</td>
        </tr>
    </table>
</div>
</asp:Content>

