<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="CISCO2.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <style type="text/css">

 p.MsoNormal
	{margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";
	        margin-left: 0cm;
            margin-right: 0cm;
            margin-top: 0cm;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">



    <table border="0" cellpadding="0" cellspacing="0" class="MsoNormalTable" 
        style="WIDTH: 560pt; BORDER-COLLAPSE: collapse; MARGIN-LEFT: 4.65pt; mso-yfti-tbllook: 1184; mso-padding-alt: 0cm 5.4pt 0cm 5.4pt" 
        width="747">
        <tr style="HEIGHT: 15.75pt; mso-yfti-irow: 0; mso-yfti-firstrow: yes">
            <td colspan="4" 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15.75pt; BORDER-TOP: windowtext 1pt solid; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext 1.0pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b><span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black">Список 
                    критичных узлов ВМЗ<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 1">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    № узла<o:p></o:p></span></b></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Название узла<o:p></o:p></span></b></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span class="SpellE"><b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Местоположеник</span></b></span><b><span 
                        style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt"> 
                    узла<o:p></o:p></span></b></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Доступность<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 2">
            <td colspan="4" 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext .5pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ТЭСЦ-2(1,2 стан)<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 3">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ТЭСЦ-2 (отгрузка)<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Ключ у нач. 1-2 стана, ряд Е-К, 23 ось<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 4">
            <td colspan="4" 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext .5pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ТЭСЦ-2(3,4 стан)<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 5">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ТЭСЦ-2 (АБК)<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    аппаратная связи<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Ключ у секретаря<span style="mso-spacerun: yes"> </span>ТЭСЦ-2 (АБК) 9-41-46<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 6">
            <td colspan="4" 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext .5pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ТЭСЦ-3<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 45pt; mso-yfti-irow: 7">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    МС3.11-1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЭМП-5<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ряд Б-В оси 12-13<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    дежурные электрики<span style="mso-spacerun: yes"> </span>Горелов Антон (мастер) 
                    9-41-14, 8 (910) 793-35-80<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 8">
            <td colspan="4" 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext .5pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ТЭСЦ-4<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 9; mso-height-source: userset">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC4.3-1<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Комната оперативок УАПТ<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="top" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ряд Л-Л<sup>/</sup>оси 17-18<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    всегда открыто<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 17.25pt; mso-yfti-irow: 10">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC4.7-1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АСУ-10<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ряд Л-Л<sup>/</sup> оси 42-43<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ключ у дежурных поддержки ТЭСЦ-4
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 11">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    МC4.13-1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АСУ-12<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ряд А-Б<span class="GramE"> ,</span> оси 35-36<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ключ у дежурных поддержки ТЭСЦ-4<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 12">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC4.16-1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК ТЭСЦ-4<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="top" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК ТЭСЦ-4 3 этаж<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    к.301<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 13">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC4.18-1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ИАП и СПУ<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ряд <span class="GramE">А-Б</span>, ось 52<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ключ у дежурных поддержки ТЭСЦ-4<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 14">
            <td colspan="4" 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext .5pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ТЭСЦ-5<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 17.25pt; mso-yfti-irow: 15">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC8.17<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Комната оперативок отделки
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ось 37-38 ряд <span class="GramE">Е-Е</span><sup>/</sup><o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    всегда открыто<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 17.25pt; mso-yfti-irow: 16">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC8.19<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Главный пульт стана<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ось 61-62, ряд <span class="GramE">Е-Е</span><sup>/</sup><o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    всегда открыто<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 17.25pt; mso-yfti-irow: 17">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC8.20<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Комната оперативок ОТК<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ось 40-41 ряд <span class="GramE">Ж-К</span><sup>/</sup><o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 17.25pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    всегда открыто<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 18">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    МC8.18<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК ТЭСЦ-5 2 этаж<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Ключ у дежурного, АБК ТЭСЦ-5, 1 этаж<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 19">
            <td colspan="4" 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext .5pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    КПЦ<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 20">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    МC22.19<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК левое крыло
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК левое крыло
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    поддержка, ЗУ№2 ,к.407<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 30pt; mso-yfti-irow: 21">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    НC22.20<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК правое крыло
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК правое крыло
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    поддержка КПЦ<span style="mso-spacerun: yes"> </span>Кузин Александр 9-50-76, 8 
                    (910) 129-36-68<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 22">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    НC22.3<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Приёмка МПС<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ряд <span class="GramE">Л-М</span>, оси 22-23<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    всегда открыто<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 30pt; mso-yfti-irow: 23">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    НC22.8<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Архив 2-ой ярус<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ряд <span class="GramE">Ж-И</span>, оси 19-20<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    участок по ремонту автоматики, Сударкин Александр <span class="SpellE">Евгеневич</span>, 
                    4038, 8 (910) 7949878<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 24">
            <td colspan="4" 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext .5pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЗУ№2<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 25">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC14.2-1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЗУ№2 2 этаж<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЗУ№2 2 этаж к.221<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    поддержка, ЗУ№2 ,к.407<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 26">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC14.5-1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЗУ№2 5 этаж<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЗУ№2 5 этаж к.505в<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК ЦТД к.201 кросс<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 27">
            <td colspan="4" 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext .5pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ИК<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 28">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC.110а-1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ИК ком.110<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ИК ком.110<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    поддержка ИК<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 29">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    МС202а-1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ИК ком. 202<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="top" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ИК ком. 202<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    поддержка ИК<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 30">
            <td colspan="4" 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext .5pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Мартен<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 30pt; mso-yfti-irow: 31">
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC27<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК мартена<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК 4 этаж, аппаратная связи<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК ЦТД к.201 кросс<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 32">
            <td colspan="4" nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 560pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: black 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: windowtext .5pt; mso-border-left-alt: windowtext 1.0pt; mso-border-bottom-alt: windowtext .5pt; mso-border-right-alt: black 1.0pt; mso-border-style-alt: solid" 
                width="747">
                <p align="center" class="MsoNormal" style="TEXT-ALIGN: center">
                    <b>
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Другие объекты ВПП<o:p></o:p></span></b></p>
            </td>
        </tr>
        <tr style="HEIGHT: 30pt; mso-yfti-irow: 33">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span class="GramE">
                    <span style="FONT-FAMILY: 'Arial CYR','sans-serif'; FONT-SIZE: 11pt">
                    Выкса-промышленная</span></span><span 
                        style="FONT-FAMILY: 'Arial CYR','sans-serif'; FONT-SIZE: 11pt"> пост ИЦ<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    3 здание, 2 этаж, <span class="GramE">связевая</span><o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Иванов Денис 8 (951) 915-48-68<span style="mso-spacerun: yes"> </span>Иванов 
                    Дмитрий 8 (951) 908-31-61<span style="mso-spacerun: yes"> </span>
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 34">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Серверная ЦТД<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК ЦТД, 3 этаж<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК ЦТД к.201 кросс<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 35">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; BACKGROUND: #c5d9f1; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; BACKGROUND: #c5d9f1; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Серверная ЦЗЛ<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; BACKGROUND: #c5d9f1; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЦЗЛ, 2 этаж, к.203<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; BACKGROUND: #c5d9f1; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК ЦТД к.201 кросс<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 45pt; mso-yfti-irow: 36">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Серверная МКС-5000<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК МКС-5000, 2 этаж<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    поддержка, ЗУ№2 ,к.407<span style="mso-spacerun: yes"> </span>поддержка МКС-5000<span 
                        style="mso-spacerun: yes"> </span>Ильинский Сергей 9-50-38, 8 (915) 
                    952-60-86<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 30pt; mso-yfti-irow: 37">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЭП-2<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЭП-2<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    поддержка МКС-5000<span style="mso-spacerun: yes"> </span>Ильинский Сергей 
                    9-50-38, 8 (915) 952-60-86<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 30pt; mso-yfti-irow: 38">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC 24.1
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Arial CYR','sans-serif'; FONT-SIZE: 11pt">АБК КСЦ<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Arial CYR','sans-serif'; FONT-SIZE: 11pt">АБК КСЦ , 1 
                    этаж<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ИТ<span class="GramE">О ООО</span> ЧОП &quot;Булат&quot;, КСЦ<span 
                        style="mso-spacerun: yes"> </span>Исаев Артем Александрович<span 
                        style="mso-spacerun: yes"> </span>8 (910) 383-85-72<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 30pt; mso-yfti-irow: 39">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: medium none; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC 22.1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Arial CYR','sans-serif'; FONT-SIZE: 11pt">АБК
                    <span class="GramE">Мебельного</span> 1 этаж<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Arial CYR','sans-serif'; FONT-SIZE: 11pt">АБК
                    <span class="GramE">Мебельного</span> 1 этаж<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 30pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ИТ<span class="GramE">О ООО</span> ЧОП &quot;Булат&quot;, КСЦ<span 
                        style="mso-spacerun: yes"> </span>Исаев Артем Александрович<span 
                        style="mso-spacerun: yes"> </span>8 (910) 383-85-72<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15pt; mso-yfti-irow: 40">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    <o:p>
                    </o:p>
                    </span>
                </p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Бизнес Аудит<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Корнилова, 100А, цоколь<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; BACKGROUND: white; HEIGHT: 15pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-bottom-alt: solid windowtext .5pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Администратор &quot;Бизнес-аудит&quot;<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 45pt; mso-yfti-irow: 41">
            <td nowrap 
                style="BORDER-BOTTOM: medium none; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; BACKGROUND: #c5d9f1; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-left-alt: solid windowtext 1.0pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC 21.1-1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: medium none; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; BACKGROUND: #c5d9f1; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЦЗЛ<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: medium none; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; BACKGROUND: #c5d9f1; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЦЗЛ, 1 этаж, к.152<o:p></o:p></span></p>
            </td>
            <td style="BORDER-BOTTOM: medium none; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; BACKGROUND: #c5d9f1; HEIGHT: 45pt; BORDER-TOP: medium none; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span class="SpellE">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    Солоницина</span></span><span 
                        style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt"> 
                    Лариса Николаевна (<span class="SpellE">нач<span class="GramE">.л</span>аборатории</span> 
                    СИГВ) 9-24-07, 9-49-04,<span style="mso-spacerun: yes"> </span>8 (910) 8710984<o:p></o:p></span></p>
            </td>
        </tr>
        <tr style="HEIGHT: 15.75pt; mso-yfti-irow: 42; mso-yfti-lastrow: yes">
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: windowtext 1pt solid; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 52pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15.75pt; BORDER-TOP: windowtext 1pt solid; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: .5pt; mso-border-left-alt: 1.0pt; mso-border-bottom-alt: 1.0pt; mso-border-right-alt: .5pt; mso-border-style-alt: solid; mso-border-color-alt: windowtext" 
                valign="bottom" width="69">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    IC 13.1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 150pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15.75pt; BORDER-TOP: windowtext 1pt solid; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext 1.0pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="200">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЗУ№1<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 128pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15.75pt; BORDER-TOP: windowtext 1pt solid; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext 1.0pt; mso-border-right-alt: solid windowtext .5pt" 
                valign="bottom" width="171">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    ЗУ№1 1 этаж<o:p></o:p></span></p>
            </td>
            <td nowrap 
                style="BORDER-BOTTOM: windowtext 1pt solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 0cm; PADDING-LEFT: 5.4pt; WIDTH: 230pt; PADDING-RIGHT: 5.4pt; HEIGHT: 15.75pt; BORDER-TOP: windowtext 1pt solid; BORDER-RIGHT: windowtext 1pt solid; PADDING-TOP: 0cm; mso-border-top-alt: solid windowtext .5pt; mso-border-bottom-alt: solid windowtext 1.0pt; mso-border-right-alt: solid windowtext 1.0pt" 
                valign="bottom" width="307">
                <p class="MsoNormal">
                    <span style="FONT-FAMILY: 'Calibri','sans-serif'; COLOR: black; FONT-SIZE: 11pt">
                    АБК ЦТД к.201 кросс<o:p></o:p></span></p>
            </td>
        </tr>
    </table>



</asp:Content>

