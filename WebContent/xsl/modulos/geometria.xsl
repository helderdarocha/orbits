<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:import href="matematica.xsl"/>
    
    <!-- Calcula semi-eixo menor do elipse (raio menor) dado o semi-eixo maior e distancia focal -->
    <xsl:template name="calcularSemiEixoMenor">
        <xsl:param name="distanciaFocal" />
        <xsl:param name="semiEixoMaior" />
        
        <xsl:variable name="exc" select="$distanciaFocal div ($semiEixoMaior * 2)" /> <!-- excentricidade do elipse -->
        
        <xsl:variable name="raizQuadrada">
            <xsl:call-template name="sqrt">
                <xsl:with-param name="num" select="1 - ($exc * $exc)"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="($semiEixoMaior * 2 * $raizQuadrada) div 2"/>
    </xsl:template>
    
    <!-- Calcula a distancia entre os focos do elipse, dados o apogeu e o perigeu -->
    <xsl:template name="calcularDistanciaFocal">
        <xsl:param name="afelio" />
        <xsl:param name="perielio" />
        
        <xsl:variable name="semiEixoMaior" select="($afelio + $perielio) div 2" />
        <xsl:value-of select="($semiEixoMaior - $perielio) * 2" />
    </xsl:template>
    
</xsl:stylesheet>