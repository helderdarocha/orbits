<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <!-- By Alain Couthures -->
    
    <xsl:variable name="pi">3.141592653589793</xsl:variable>
    <xsl:variable name="eps">0.0000000000000001</xsl:variable>

    <!-- cos (x) -->
    <xsl:template name="cos">
        <xsl:param name="x"/>
        
        <xsl:variable name="x0" select="($x div $pi div 2 - floor($x div $pi div 2)) * $pi * 2"/>
        <xsl:variable name="x1">
            <xsl:choose>
                <xsl:when test="$x0 = 0 or $x0 = $pi">0</xsl:when>
                <xsl:when test="$x0 &gt; $pi div 2 and $x0 &lt; $pi">
                    <xsl:value-of select="$x0 - $pi"/>
                </xsl:when>
                <xsl:when test="$x0 &gt; $pi and $x0 &lt; $pi * 1.5">
                    <xsl:value-of select="$pi - $x0"/>
                </xsl:when>
                <xsl:when test="$x0 &gt; $pi">
                    <xsl:value-of select="$pi * 2 - $x0"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$x0"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$x1 = 0">1</xsl:when>
            <xsl:when test="$x1 = $pi div 2">0</xsl:when>
            <xsl:when test="$x1 = $pi">-1</xsl:when>
            <xsl:when test="$x1 = $pi * 1.5">0</xsl:when>
            <xsl:when test="$x1 &gt; 0">
                <xsl:call-template name="sincostan">
                    <xsl:with-param name="res">cos</xsl:with-param>
                    <xsl:with-param name="x" select="$x1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>-</xsl:text>
                <xsl:call-template name="sincostan">
                    <xsl:with-param name="res">cos</xsl:with-param>
                    <xsl:with-param name="x" select="-$x1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- sin (x) -->
    <xsl:template name="sin">
        <xsl:param name="x"/>
        <xsl:variable name="x0" select="($x div $pi div 2 - floor($x div $pi div 2)) * $pi * 2"/>
        <xsl:variable name="x1">
            <xsl:choose>
                <xsl:when test="$x0 = 0 or $x0 = $pi">0</xsl:when>
                <xsl:when test="$x0 &gt; $pi div 2 and $x0 &lt; $pi * 1.5">
                    <xsl:value-of select="$pi - $x0"/>
                </xsl:when>
                <xsl:when test="$x0 &gt; $pi * 1.5">
                    <xsl:value-of select="$x0 - $pi * 2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$x0"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$x1 = 0">0</xsl:when>
            <xsl:when test="$x1 = $pi div 2">1</xsl:when>
            <xsl:when test="$x1 = $pi">0</xsl:when>
            <xsl:when test="$x1 = $pi * 1.5">-1</xsl:when>
            <xsl:when test="$x1 &gt; 0">
                <xsl:call-template name="sincostan">
                    <xsl:with-param name="res">sin</xsl:with-param>
                    <xsl:with-param name="x" select="$x1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>-</xsl:text>
                <xsl:call-template name="sincostan">
                    <xsl:with-param name="res">sin</xsl:with-param>
                    <xsl:with-param name="x" select="-$x1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- Internal templates -->
    
    <xsl:template name="k">
        <xsl:param name="x"/>
        <xsl:param name="k"/>
        <xsl:choose>
            <xsl:when test="$k &gt;= $x">
                <xsl:call-template name="k">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="k" select="$k div 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$k"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="atan">
        <xsl:param name="x"/>
        <xsl:param name="k" select="3"/>
        <xsl:param name="y" select="$x * $x"/>
        <xsl:param name="i" select="-1"/>
        <xsl:param name="u" select="$x * $y"/>
        <xsl:choose>
            <xsl:when test="$u &gt; $eps">
                <xsl:call-template name="atan">
                    <xsl:with-param name="x" select="$x + $u * $i div $k"/>
                    <xsl:with-param name="k" select="$k + 2"/>
                    <xsl:with-param name="y" select="$y"/>
                    <xsl:with-param name="u" select="$u * $y"/>
                    <xsl:with-param name="i" select="-$i"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$x"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="sincostan">
        <xsl:param name="res"/>
        <xsl:param name="x"/>
        <xsl:param name="k" select="0.5"/>
        <xsl:param name="xx" select="1"/>
        <xsl:param name="yy" select="0"/>
        <xsl:choose>
            <xsl:when test="$x &gt; $eps">
                <xsl:variable name="k1">
                    <xsl:call-template name="k">
                        <xsl:with-param name="x" select="$x"/>
                        <xsl:with-param name="k" select="$k"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="x1">
                    <xsl:call-template name="atan">
                        <xsl:with-param name="x" select="$k1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="q">
                    <xsl:call-template name="sqrt_2">
                        <xsl:with-param name="x" select="1 + $k1 * $k1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="sincostan">
                    <xsl:with-param name="res" select="$res"/>
                    <xsl:with-param name="x" select="$x - $x1"/>
                    <xsl:with-param name="k" select="$k1"/>
                    <xsl:with-param name="xx" select="($xx - $yy * $k1) div $q"/>
                    <xsl:with-param name="yy" select="($xx * $k1 + $yy) div $q"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$res = 'sin'"><xsl:value-of select="$yy"/></xsl:when>
                    <xsl:when test="$res = 'cos'"><xsl:value-of select="$xx"/></xsl:when>
                    <xsl:when test="$res = 'tan'"><xsl:value-of select="$yy div $xx"/></xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
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