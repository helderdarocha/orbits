<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <!-- Valor de referencia - Diametro do sol (maior diametro geral) -->
    <xsl:variable name="diametroDoSol" select="//*[@diametrokm][not(@diametrokm &lt; //*/@diametrokm)]/@diametrokm" />
    <!-- Valor de referencia - Diametro de jupiter (atualmente, maior diametro de planeta) -->
    <xsl:variable name="diametroDeJupiter" select="//planeta[@diametrokm][not(@diametrokm &lt; //planeta/@diametrokm)]/@diametrokm" />
    
    <!-- Valor de referencia - Menor orbita (atualmente - 2010 - corresponde a orbita de Mercurio) -->
    <xsl:variable name="orbitaDeMercurio" select="//*[@afelioUA][not(@afelioUA &gt; //*/@afelioUA)]/@afelioUA" />
    <!-- Valor de referencia - Orbita de Netuno -->
    <xsl:variable name="orbitaDeNetuno" select="//planeta[@nome = 'Netuno']/@afelioUA" />
    <!-- Valor de referencia - Orbita de Sedna -->
    <xsl:variable name="orbitaDeSedna" select="//*[@nome = 'Sedna']/@afelioUA" />
    <!-- Valor de referencia - Maior orbita -->
    <xsl:variable name="maiorOrbita" select="//*[@afelioUA][not(@afelioUA &lt; //*/@afelioUA)]/@afelioUA" />
    
    <!-- Valor de referencia - Massa de Jupiter (maior massa planetaria) -->
    <xsl:variable name="massaDeJupiter" select="//planeta[@massaKg][not(@massaKg &lt; //planeta/@massaKg)]/@massaKg" />
    <!-- Valor de referencia - Massa do Sol (maior massa geral) -->
    <xsl:variable name="massaDoSol" select="//*[@massaKg][not(@massaKg &lt; //*/@massaKg)]/@massaKg" />
    <xsl:variable name="massaDoSolGM" select="//estrela[@nome='Sol']/@massaGM" />
    
    <!-- Constante gravitacional:
           massaGM = massaKg * G
           massaKg = massaGM / G
    -->
    <xsl:variable name="G">6.673e-20</xsl:variable> <!-- km^3 / (s^2 * kg) -->
</xsl:stylesheet>