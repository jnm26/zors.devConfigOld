<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes" />
<xsl:template match="/">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
<html>
<head>
  <title><xsl:value-of select="$title" /></title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fancyapps/fancybox@3.5.7/dist/jquery.fancybox.min.css" integrity="sha256-Vzbj7sDDS/woiFS3uNKo8eIuni59rjyNGtXfstRzStA=" crossorigin="anonymous"/>
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/@fancyapps/fancybox@3.5.7/dist/jquery.fancybox.min.js" integrity="sha256-yt2kYMy0w8AbtF89WXb2P1rfjcP/HTHLT7097U8Y5b8=" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/jszip@3.1.5/dist/jszip.min.js" integrity="sha256-PZ/OvdXxEW1u3nuTAUCSjd4lyaoJ3UJpv/X11x2Gi5c=" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/file-saver@2.0.5/dist/FileSaver.min.js" integrity="sha256-xoh0y6ov0WULfXcLMoaA6nZfszdgI8w2CEJ/3k8NBIE=" crossorigin="anonymous"></script>
  <style>img { display: block; }</style>
</head>
<body>
<h1 style="text-align: center;"><xsl:value-of select="$title"/></h1>
<div style="border-bottom: 1px solid gray; margin-bottom: 1rem;"></div>
<div style="display: flex; flex-wrap: wrap; gap: 2px; justify-content: center;">
<xsl:for-each select="list/file">
  <a href="{.}" data-fancybox="gallery">
  <xsl:choose>
  <xsl:when test="count(/list/directory[text() = 'thumbs'])">
    <img loading="lazy" src="thumbs/{.}"/>
  </xsl:when>
  <xsl:otherwise>
    <img loading="lazy" src="{.}" height="200"/>
  </xsl:otherwise>
  </xsl:choose>
  </a>
</xsl:for-each>
</div>
<script>
async function downloadAll() {
  const zip = JSZip();
  const folder = zip.folder('<xsl:value-of select="$title" />');
  const files = [
    <xsl:for-each select="list/file">
     '<xsl:value-of select="." />',
    </xsl:for-each>
  ];
  for(const i in files) {
    const file = files[i];
    const resp = await fetch(file);
    folder.file(file, resp.blob());
    $.fancybox.animate($.fancybox.getInstance().SlideShow.$progress.show(),{scaleX: i/files.length}, 0.1);
  }
  const zipFile = await zip.generateAsync({type: 'blob'});
  saveAs(zipFile, '<xsl:value-of select="$title" />' + '.zip');
  $.fancybox.animate($.fancybox.getInstance().SlideShow.$progress.show(),{scaleX: 0}, 0.1); 
}

$('[data-fancybox="gallery"]').fancybox({
  buttons: [
    "zoom",
    "slideShow",
    "fullScreen",
    "download",
    "downloadAll",
    "close"
  ],
  btnTpl: {
    downloadAll:
      '<a class="fancybox-button fancybox-button--download" title="Download All" href="javascript:downloadAll()">' +
      '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3M3 17V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z" style="fill:unset; stroke-width:2"/></svg>' +
      '</a>',
 },
});
$('[data-fancybox="gallery"]')[0].click();
</script>
</body>
</html>
</xsl:template>
</xsl:stylesheet>