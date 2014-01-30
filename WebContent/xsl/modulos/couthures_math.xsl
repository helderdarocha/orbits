<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <!-- By Alain Couthures -->

    <xsl:variable name="eps">0.0000000000000001</xsl:variable>
    
    <xsl:template name="sqrt_2">
        <xsl:param name="x"/>
        <xsl:param name="u1" select="$x"/>
        <xsl:param name="u2" select="1"/>
        <xsl:choose>
            <xsl:when test="$x &lt; 0">NaN</xsl:when>
            <xsl:when test="(($u2 - $u1)*(number($u2 &gt; $u1) * 2 - 1)) &gt; $eps">
                <xsl:call-template name="sqrt_2">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="u1" select="$u2"/>
                    <xsl:with-param name="u2" select="($u2 + $x div $u2) div 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$u2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
   
</xsl:stylesheet>