$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$outputDirectory = Join-Path $PSScriptRoot '../documents'
[System.IO.Directory]::CreateDirectory($outputDirectory) | Out-Null
$outputPath = [System.IO.Path]::GetFullPath((Join-Path $outputDirectory 'RSVP_Ahmed_Asmaa.xlsx'))
if (Test-Path -LiteralPath $outputPath) {
    throw "Workbook already exists. Preserve guest data; choose a new output filename before regenerating."
}

$archive = [System.IO.Compression.ZipFile]::Open($outputPath, [System.IO.Compression.ZipArchiveMode]::Create)
function Add-XmlEntry([string]$name, [string]$xml) {
    $entry = $archive.CreateEntry($name)
    $writer = [System.IO.StreamWriter]::new($entry.Open(), [System.Text.UTF8Encoding]::new($false))
    try { $writer.Write($xml.Trim()) } finally { $writer.Dispose() }
}

try {
    Add-XmlEntry '[Content_Types].xml' @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/worksheets/sheet2.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/worksheets/sheet3.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/tables/table1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.table+xml"/>
</Types>
'@
    Add-XmlEntry '_rels/.rels' @'
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>
'@
    Add-XmlEntry 'xl/workbook.xml' @'
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
<bookViews><workbookView activeTab="0"/></bookViews>
<sheets><sheet name="Guest List" sheetId="1" r:id="rId1"/><sheet name="Summary" sheetId="2" r:id="rId2"/><sheet name="Instructions" sheetId="3" r:id="rId3"/></sheets>
<calcPr calcId="191029" fullCalcOnLoad="1"/>
</workbook>
'@
    Add-XmlEntry 'xl/_rels/workbook.xml.rels' @'
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet2.xml"/>
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet3.xml"/>
<Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
'@
    Add-XmlEntry 'xl/styles.xml' @'
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<numFmts count="1"><numFmt numFmtId="164" formatCode="yyyy-mm-dd hh:mm"/></numFmts>
<fonts count="3"><font><sz val="11"/><name val="Calibri"/><color rgb="FF4B4436"/></font><font><b/><sz val="11"/><name val="Calibri"/><color rgb="FFFAF7EF"/></font><font><b/><sz val="20"/><name val="Calibri"/><color rgb="FF947238"/></font></fonts>
<fills count="3"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill><fill><patternFill patternType="solid"><fgColor rgb="FF947238"/><bgColor indexed="64"/></patternFill></fill></fills>
<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>
<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
<cellXfs count="5"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/><xf numFmtId="0" fontId="1" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1"/><xf numFmtId="49" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/><xf numFmtId="164" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/><xf numFmtId="0" fontId="2" fillId="0" borderId="0" xfId="0" applyFont="1"/></cellXfs>
<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>
<dxfs count="0"/><tableStyles count="0" defaultTableStyle="TableStyleMedium4" defaultPivotStyle="PivotStyleLight16"/>
</styleSheet>
'@
    Add-XmlEntry 'xl/worksheets/sheet1.xml' @'
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
<dimension ref="A1:F2"/><sheetViews><sheetView workbookViewId="0" showGridLines="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/><selection pane="bottomLeft" activeCell="A2" sqref="A2"/></sheetView></sheetViews>
<cols><col min="1" max="1" width="28" customWidth="1" style="2"/><col min="2" max="2" width="18" customWidth="1"/><col min="3" max="3" width="16" customWidth="1"/><col min="4" max="4" width="23" customWidth="1" style="2"/><col min="5" max="5" width="45" customWidth="1" style="2"/><col min="6" max="6" width="26" customWidth="1" style="3"/></cols>
<sheetData><row r="1" ht="28" customHeight="1"><c r="A1" s="1" t="inlineStr"><is><t>Name</t></is></c><c r="B1" s="1" t="inlineStr"><is><t>Attendance</t></is></c><c r="C1" s="1" t="inlineStr"><is><t>Party size</t></is></c><c r="D1" s="1" t="inlineStr"><is><t>Phone (optional)</t></is></c><c r="E1" s="1" t="inlineStr"><is><t>Notes</t></is></c><c r="F1" s="1" t="inlineStr"><is><t>Submitted at (Cairo)</t></is></c></row><row r="2"><c r="A2" s="2"/><c r="B2"/><c r="C2"/><c r="D2" s="2"/><c r="E2" s="2"/><c r="F2" s="3"/></row></sheetData>
<dataValidations count="2"><dataValidation type="list" allowBlank="1" showErrorMessage="1" errorTitle="Choose attendance" error="Select Attending or Declined." sqref="B2:B10001"><formula1>"Attending,Declined"</formula1></dataValidation><dataValidation type="whole" operator="greaterThanOrEqual" allowBlank="1" showErrorMessage="1" errorTitle="Invalid party size" error="Enter a whole number of zero or more." sqref="C2:C10001"><formula1>0</formula1></dataValidation></dataValidations>
<tableParts count="1"><tablePart r:id="rId1"/></tableParts>
</worksheet>
'@
    Add-XmlEntry 'xl/worksheets/_rels/sheet1.xml.rels' @'
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/table" Target="../tables/table1.xml"/></Relationships>
'@
    Add-XmlEntry 'xl/tables/table1.xml' @'
<table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" id="1" name="GuestResponses" displayName="GuestResponses" ref="A1:F2" totalsRowShown="0"><autoFilter ref="A1:F2"/><tableColumns count="6"><tableColumn id="1" name="Name"/><tableColumn id="2" name="Attendance"/><tableColumn id="3" name="Party size"/><tableColumn id="4" name="Phone (optional)"/><tableColumn id="5" name="Notes"/><tableColumn id="6" name="Submitted at (Cairo)"/></tableColumns><tableStyleInfo name="TableStyleMedium4" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
'@
    Add-XmlEntry 'xl/worksheets/sheet2.xml' @'
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetViews><sheetView workbookViewId="0" showGridLines="0"/></sheetViews><cols><col min="1" max="1" width="38" customWidth="1"/><col min="2" max="2" width="22" customWidth="1"/></cols><sheetData>
<row r="1" ht="35" customHeight="1"><c r="A1" s="4" t="inlineStr"><is><t>Ahmed, Asmaa - RSVP</t></is></c></row>
<row r="3"><c r="A3" t="inlineStr"><is><t>Total responses with a name</t></is></c><c r="B3"><f>COUNTA('Guest List'!A:A)-1</f><v>0</v></c></row>
<row r="4"><c r="A4" t="inlineStr"><is><t>Attending responses</t></is></c><c r="B4"><f>COUNTIFS('Guest List'!B:B,"Attending",'Guest List'!A:A,"&lt;&gt;")</f><v>0</v></c></row>
<row r="5"><c r="A5" t="inlineStr"><is><t>Total people attending</t></is></c><c r="B5"><f>SUMIFS('Guest List'!C:C,'Guest List'!B:B,"Attending",'Guest List'!A:A,"&lt;&gt;")</f><v>0</v></c></row>
<row r="6"><c r="A6" t="inlineStr"><is><t>Declined responses</t></is></c><c r="B6"><f>COUNTIFS('Guest List'!B:B,"Declined",'Guest List'!A:A,"&lt;&gt;")</f><v>0</v></c></row>
<row r="8"><c r="A8" t="inlineStr"><is><t>No RSVP connection is configured yet.</t></is></c></row>
</sheetData><mergeCells count="1"><mergeCell ref="A1:B1"/></mergeCells></worksheet>
'@
    $instructions = @(
        'Ahmed, Asmaa - guest list instructions',
        'This workbook is a local template. It is not connected to the invitation.',
        'No real guest replies have been added. Totals start at zero.',
        'Enter one response per row in Guest List, starting at row 2.',
        'Select Attending or Declined from the Attendance dropdown.',
        'Party size includes the person replying. Use 0 for declined responses.',
        'Phone is optional and formatted as text to preserve leading zeroes.',
        'Enter submission times as Cairo local time (Africa/Cairo).',
        'Summary totals recalculate in Excel. Filter Attendance to Attending to see who is coming.',
        'The list can show replies only; it cannot identify non-responders without an invitation roster.',
        'Upload this file to your own OneDrive to use it in Excel Online.',
        'Uploading alone does not connect RSVP submissions; an online integration is still needed.',
        'Keep workbook access limited to the organizers; guests only need the invitation link.',
        'Attendance and party-size validation are prepared through row 10001.'
    )
    $rows = for ($i = 0; $i -lt $instructions.Count; $i++) {
        $row = $i + 1
        $escaped = [System.Security.SecurityElement]::Escape($instructions[$i])
        "<row r=`"$row`" ht=`"26`" customHeight=`"1`"><c r=`"A$row`" t=`"inlineStr`"><is><t>$escaped</t></is></c></row>"
    }
    Add-XmlEntry 'xl/worksheets/sheet3.xml' ('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetViews><sheetView workbookViewId="0" showGridLines="0"/></sheetViews><cols><col min="1" max="1" width="125" customWidth="1"/></cols><sheetData>' + ($rows -join '') + '</sheetData></worksheet>')
} finally {
    $archive.Dispose()
}

Write-Output "Created $outputPath"
