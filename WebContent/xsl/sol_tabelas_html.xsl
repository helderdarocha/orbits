<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- 
         Gera tabelas com dados extraidos de sol_2010.2.2.xml 
         Para configurar, use o arquivo parametros_sol_tabelas.xsl
         
         @author Helder da Rocha (helder.darocha@gmail.com)
         @version 0.2 2010-12-23
    -->

    <xsl:import href="modulos/parametros_sol_tabelas.xsl"/>
    
    <xsl:decimal-format decimal-separator="." grouping-separator="," NaN=""/>
    
    <xsl:output method="html" indent="yes" encoding="iso-8859-1" standalone="no"/>
    
    <xsl:strip-space elements="*"/>


    <!-- Selecao dos dados escolhidos para exibicao -->
    <xsl:variable name="objetosEscolhidos"
        select="//estrela [$estrela] | 
        //planetas/planeta-anao[$planetaAnao] | 
        //trans-netunianos/objeto [$tno] | 
        //cometas/cometa [$cometa] | 
        //centauros/objeto [$centauro] | 
        //asteroides/asteroide[$asteroide] |
        //asteroides/asteroide[$asteroide] |
        //planetas/planeta[$planeta]"/>

    <!-- DIMENSOES ABSOLUTAS (UA) -->
    <!-- Calculo das dimensoes das orbitas escolhidas -->
    <xsl:variable name="itensMostrados"
        select="$objetosEscolhidos[(@periodoOrbitalD) and (@afelioUA &gt; $minOrbita) and (@afelioUA &lt;= $maxOrbita) and (@diametrokm &gt;= $minDiametro or self::cometa) and (@diametrokm &lt;= $maxDiametro) or self::estrela]"/>

    <!-- TEMPLATES -->
    <xsl:template match="/">
        <html>
            <head>
               <title>
                   <xsl:value-of select="$titulo"/>
               </title>
                <script type="text/javascript" src="/js/jquery-1.4.4.min.js"></script> 
                <script type="text/javascript" src="/js/jquery.tablesorter.min.js"></script> 
                <xsl:if test="not($satelite)">
                <script>
                    $(document).ready(function() { 
                        $("tabela").tablesorter({ 
                            headers: { 
                                6: {sorter: false}, 
                                7: {sorter: false} 
                            } 
                        }); 
                    });
                </script>
                </xsl:if>
               <style type="text/css">
                * { font-family: calibri, sans-serif; }
                td, th {border: solid 1px rgb(180,180,180); 
                        padding: 5px; vertical-align: top}
                tr {font-size: <xsl:value-of select="$tamFonte"/>pt;}
                table {border: solid 2px black}
                
                .planeta, .planeta-anao, .estrela {
                                font-weight: bold; 
                                height: <xsl:value-of select="$tamFonte + 40"/>px;
                                font-size: <xsl:value-of select="$tamFonte + 2"/>pt;}
                .planeta       {background-color: <xsl:value-of select="$corPlaneta"/>; color: <xsl:value-of select="$corTextoPlaneta"/>;}
                .planeta-anao  {background-color: <xsl:value-of select="$corPlanetaAnao"/>; color: <xsl:value-of select="$corTextoPlanetaAnao"/>;} 

                
                .asteroide     {background-color: <xsl:value-of select="$corAsteroide"/>; color: <xsl:value-of select="$corTextoAsteroide"/>}
                .cometa        {background-color: <xsl:value-of select="$corCometa"/>; color: <xsl:value-of select="$corTextoCometa"/>}
                .objeto        {background-color: <xsl:value-of select="$corObjeto"/>; color: <xsl:value-of select="$corTextoObjeto"/>}
                .centauro      {background-color: <xsl:value-of select="$corCentauro"/>; color: <xsl:value-of select="$corTextoCentauro"/>}
                .satelite      {background-color: <xsl:value-of select="$corSatelite"/>; color: <xsl:value-of select="$corTextoSatelite"/>}
                .estrela       {background-color: <xsl:value-of select="$corEstrela"/>; color: <xsl:value-of select="$corTextoEstrela"/>}
                   
                .satelite      {background-color: rgba(255,255,255,0.3); color: black}
                .redondo       {font-weight: bold; font-size: <xsl:value-of select="$tamFonte + 1"/>pt;}
               </style>
            </head>
            
            <body>
                <h1><xsl:value-of select="$titulo"/></h1> 
                <xsl:choose>
                    <xsl:when test="not($subtitulo)">
                        <p>Orbitas entre <xsl:value-of select="format-number($minOrbita,'0.###')"/> e
                            <xsl:value-of select="format-number($maxOrbita,'0.###')"/>
                            UA. Exibindo 
                            <xsl:value-of select="count($itensMostrados)"/>
                            <xsl:text> objetos</xsl:text>
                            <xsl:if test="$minDiametro &gt; 0">
                                <xsl:text> com diametro maior que </xsl:text>
                                <xsl:value-of select="format-number($minDiametro,'###.###,###')"/>
                                <xsl:text> km</xsl:text>
                                <xsl:if test="$maxDiametro &lt; $diametroDoSol">
                                    <xsl:text> e menor que </xsl:text>
                                    <xsl:value-of
                                        select="format-number($maxDiametro,'###.###,###')"/>
                                    <xsl:text> km</xsl:text>
                                </xsl:if>
                            </xsl:if>
                            <xsl:text>.</xsl:text>
                        </p>
                    </xsl:when>
                    <xsl:otherwise>
                        <text y="50" font-size="12pt">
                            <xsl:value-of select="$subtitulo"/>
                        </text>
                    </xsl:otherwise>
                </xsl:choose>
                
                <table id="tabela" class="tablesorter" cellpadding="0" cellspacing="0">
                    <thead>
                    <tr>
                        <th></th>
                        <xsl:if test="$nome">
                            <th>Nome</th>
                        </xsl:if>
                         <th>Tipo</th>
                        <xsl:if test="$categoria">
                            <th>Categoria</th>
                        </xsl:if>
                        <xsl:if test="$numero">
                            <th>Número</th>
                        </xsl:if> <!-- exceto planetas e planetas-anao -->
                        <xsl:if test="$designacao">
                            <th>Designação</th>
                        </xsl:if> <!-- so asteroides e objetos -->
                        <xsl:if test="$diametrokm">
                            <th>Diâmetro (km)</th>
                        </xsl:if>
                        <xsl:if test="$massaGM">
                            <th>Massa (GM)</th>
                        </xsl:if> <!-- exceto cometas -->
                        <xsl:if test="$massaKg">
                            <th>Massa (kg)</th>
                        </xsl:if> <!-- exceto cometas -->
                        <xsl:if test="$volume">
                            <th>Volume</th>
                        </xsl:if>   <!-- so planetas e planetas-anao -->
                        <xsl:if test="$densidade">
                            <th>Densidade</th>
                        </xsl:if> <!-- so planetas e planetas-anao -->
                        <xsl:if test="$gravidadeEquatorial">
                            <th>Gravidade Equatorial</th>
                        </xsl:if>   <!-- so planetas e planetas-anao -->
                        <xsl:if test="$inclinacaoAxial">
                            <th>Inclinacao Axial</th>
                        </xsl:if>   <!-- so planetas e planetas-anao -->
                        <xsl:if test="$periodoRotacaoSideralH">
                            <th>Rotacao Sideral (h)</th>
                        </xsl:if> <!-- so planetas -->
                        
                        
                        <xsl:if test="$afelioUA">
                            <th>Afélio (UA)</th>
                        </xsl:if>
                        <xsl:if test="$perielioUA">
                            <th>Periélio (UA)</th>
                        </xsl:if>
                        <xsl:if test="$raioMedUA">
                            <th>Raio Médio (UA)</th>
                        </xsl:if>
                        <xsl:if test="$excentricidade">
                            <th>Excentricidade</th>
                        </xsl:if>
                        <xsl:if test="$periodoOrbitalD">
                            <th>Periodo Orbital (dias)</th>
                        </xsl:if>
                        
                        <xsl:if test="$inclinacao">
                            <th>Inclinação Orbital</th>
                        </xsl:if>
                        <xsl:if test="$anomaliaMedia">
                            <th>Anomalia Média</th>
                        </xsl:if>
                        <xsl:if test="$argumentoPerielio">
                            <th>Argumento do Periélio</th>
                        </xsl:if>
                        <xsl:if test="$longitudeNoAscendente">
                            <th>Longitude do Nó Ascendente</th>
                        </xsl:if>
                        
                        <xsl:if test="$anoDescobrimento">
                            <th>Ano do Descobrimento</th>
                        </xsl:if>
                        <xsl:if test="$descobertoPor">
                            <th>Descoberto Por</th>
                        </xsl:if>
                    </tr>
                    </thead>
                    <tbody>
                    <xsl:for-each select="$itensMostrados">
                        
                        <xsl:sort select="@raioMedUA" order="ascending" data-type="number" /> 

                        <tr class="{name()} {@categoria}">
                            <td>
                                <xsl:if test="$satelite and child::satelite">
                                    <xsl:attribute name="rowspan">2</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="position()"/>. </td>
                            <xsl:if test="$nome">
                                <td>
                                    <xsl:if test="$satelite and child::satelite">
                                        <xsl:attribute name="rowspan">2</xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="@nome" />
                                    <xsl:if test="child::imagem and $exibirImagens">
                                        <br/><img src="{$urlImagens}{child::imagem/@href}" width="150"/>
                                    </xsl:if>
                                </td>
                            </xsl:if>
                            <td>
                                <xsl:value-of select="name()"/>
                            </td>
                            <xsl:if test="$categoria">
                                <td><xsl:value-of select="@categoria" /></td>
                            </xsl:if>
                            <xsl:if test="$numero">
                                <td style="text-align: right"><xsl:value-of select="@numero" /></td>
                            </xsl:if> <!-- exceto planetas e planetas-anao -->
                            <xsl:if test="$designacao">
                                <td><xsl:value-of select="@designacao" /></td>
                            </xsl:if> <!-- so asteroides e objetos -->
                            <xsl:if test="$diametrokm">
                                <td style="text-align: right"><xsl:value-of select="format-number(@diametrokm, '0.00')" /></td>
                            </xsl:if>
                            <xsl:if test="$massaGM">
                                <td style="text-align: right"><xsl:value-of select="format-number(@massaGM, '0.00')" /></td>
                            </xsl:if> <!-- exceto cometas -->
                            <xsl:if test="$massaKg">
                                <td style="text-align: right"><xsl:value-of select="@massaKg" /></td>
                            </xsl:if> <!-- exceto cometas -->
                            <xsl:if test="$volume">
                                <td style="text-align: right"><xsl:value-of select="@volume" /></td>
                            </xsl:if>   <!-- so planetas e planetas-anao -->
                            <xsl:if test="$densidade">
                                <td style="text-align: right"><xsl:value-of select="format-number(@densidade, '0.000')" /></td>
                            </xsl:if> <!-- so planetas e planetas-anao -->
                            <xsl:if test="$gravidadeEquatorial">
                                <td style="text-align: right"><xsl:value-of select="format-number(@gravidadeEquatorial, '0.00')" /></td>
                            </xsl:if>   <!-- so planetas e planetas-anao -->
                            <xsl:if test="$inclinacaoAxial">
                                <td style="text-align: right"><xsl:value-of select="format-number(@inclinacaoAxial, '0.00')" /></td>
                            </xsl:if>   <!-- so planetas e planetas-anao -->
                            <xsl:if test="$periodoRotacaoSideralH">
                                <td style="text-align: right"><xsl:value-of select="format-number(@periodoRotacaoSideralH, '0.###')" /></td>
                            </xsl:if> <!-- so planetas -->
                            
                            
                            <xsl:if test="$afelioUA">
                                <td style="text-align: right"><xsl:value-of select="format-number(@afelioUA, '0.###')" /></td>
                            </xsl:if>
                            <xsl:if test="$perielioUA">
                                <td style="text-align: right"><xsl:value-of select="format-number(@perielioUA, '0.###')" /></td>
                            </xsl:if>
                            <xsl:if test="$raioMedUA">
                                <td style="text-align: right"><xsl:value-of select="format-number(@raioMedUA, '0.###')" /></td>
                            </xsl:if>
                            <xsl:if test="$excentricidade">
                                <td style="text-align: right"><xsl:value-of select="@excentricidade" /></td>
                            </xsl:if>
                            <xsl:if test="$periodoOrbitalD">
                                <td style="text-align: right"><xsl:value-of select="format-number(@periodoOrbitalD, '0.###')" /></td>
                            </xsl:if>
                            
                            <xsl:if test="$inclinacao">
                                <td style="text-align: right"><xsl:value-of select="@inclinacao" /></td>
                            </xsl:if>
                            <xsl:if test="$anomaliaMedia">
                                <td style="text-align: right"><xsl:value-of select="@anomaliaMedia" /></td>
                            </xsl:if>
                            <xsl:if test="$argumentoPerielio">
                                <td style="text-align: right"><xsl:value-of select="@argumentoPerielio" /></td>
                            </xsl:if>
                            <xsl:if test="$longitudeNoAscendente">
                                <td style="text-align: right"><xsl:value-of select="@longitudeNoAscendente" /></td>
                            </xsl:if>
                            
                            <xsl:if test="$anoDescobrimento">
                                <td style="text-align: right"><xsl:value-of select="@anoDescobrimento" /></td>
                            </xsl:if>
                            <xsl:if test="$descobertoPor">
                                <td><xsl:value-of select="@descobertoPor" /></td>
                            </xsl:if>

                        </tr>
                        <xsl:if test="$satelite and child::satelite">
                            <tr class="{name()} {@categoria}">
                                <td colspan="100" >Satélites naturais (luas)
                                    <table class="satelite" width="100%">
                                    <th></th>
                                    <th>Nome</th>
                                    <xsl:if test="$categoria">
                                        <th>Categoria</th>
                                    </xsl:if>
                                    <xsl:if test="$diametrokm">
                                        <th>Diametrokm</th>
                                    </xsl:if>
                                    <xsl:if test="$massaGM">
                                        <th>Massa (GM)</th>
                                    </xsl:if>
                                    <xsl:if test="$massaKg">
                                        <th>Massa (Kg)</th>
                                    </xsl:if>
                                    <xsl:if test="$volume">
                                        <th>Volume</th>
                                    </xsl:if>
                                    <xsl:if test="$densidade">
                                        <th>Densidade</th>
                                    </xsl:if>
                                    <xsl:if test="$gravidadeEquatorial">
                                        <th>Gravidade Equatorial</th>
                                    </xsl:if>
                                    <xsl:if test="$raioMedOrbitakm">
                                        <th>Raio Medio da Orbita (km)</th>
                                    </xsl:if>
                                    <xsl:if test="$periodoOrbitalD">
                                        <th>Periodo Orbital (dias)</th>
                                    </xsl:if>
                                    <xsl:if test="$anoDescobrimento">
                                        <th>Ano do Descobrimento</th>
                                    </xsl:if>
                                    <xsl:if test="$descobertoPor">
                                        <th>Descoberto Por</th>
                                    </xsl:if>
                                    <xsl:for-each select="satelite">
                                        <xsl:sort select="@raioMedOrbitakm" order="ascending" data-type="number" /> 
                                        <tr  class="{@categoria}"><td><xsl:value-of select="position()"/>. </td>
                                            <td><xsl:value-of select="@nome"/>
                                            <xsl:if test="child::imagem and $exibirImagens">
                                                <br/><img src="{$urlImagens}{child::imagem/@href}" width="150"/>
                                            </xsl:if>
                                            </td>
                                            <xsl:if test="$categoria">
                                                <td><xsl:value-of select="@categoria" /></td>
                                            </xsl:if>
                                            <xsl:if test="$diametrokm">
                                                <td style="text-align: right"><xsl:value-of select="@diametrokm" /></td>
                                            </xsl:if>
                                            <xsl:if test="$massaGM">
                                                <td style="text-align: right"><xsl:value-of select="@massaGM" /></td>
                                            </xsl:if>
                                            <xsl:if test="$massaKg">
                                                <td style="text-align: right"><xsl:value-of select="@massaKg" /></td>
                                            </xsl:if>
                                            <xsl:if test="$volume">
                                                <td style="text-align: right"><xsl:value-of select="@volume" /></td>
                                            </xsl:if>
                                            <xsl:if test="$densidade">
                                                <td style="text-align: right"><xsl:value-of select="@densidade" /></td>
                                            </xsl:if>
                                            <xsl:if test="$gravidadeEquatorial">
                                                <td style="text-align: right"><xsl:value-of select="@gravidadeEquatorial" /></td>
                                            </xsl:if>
                                            <xsl:if test="$raioMedOrbitakm">
                                                <td style="text-align: right"><xsl:value-of select="@raioMedOrbitakm" /></td>
                                            </xsl:if>
                                            <xsl:if test="$periodoOrbitalD">
                                                <td style="text-align: right"><xsl:value-of select="@periodoOrbitalD" /></td>
                                            </xsl:if>
                                            <xsl:if test="$anoDescobrimento">
                                                <td style="text-align: right"><xsl:value-of select="@anoDescobrimento" /></td>
                                            </xsl:if>
                                            <xsl:if test="$descobertoPor">
                                                <td><xsl:value-of select="@descobertoPor" /></td>
                                            </xsl:if>
                                        </tr>
                                    </xsl:for-each>
                                </table></td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="satelite">
        <tr>
            <td></td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
