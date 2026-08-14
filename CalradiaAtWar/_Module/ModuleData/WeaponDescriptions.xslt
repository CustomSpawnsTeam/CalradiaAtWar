<xsl:stylesheet
    version="1.1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ext="http://exslt.org/common"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    exclude-result-prefixes="ext msxsl">

    <xsl:output omit-xml-declaration="yes" indent="yes"/>

    <!-- ========== TOKENIZER ========== -->
    <xsl:template name="tokenize">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, ',')">
                <id value="{substring-before($text, ',')}"/>
                <xsl:call-template name="tokenize">
                    <xsl:with-param name="text" select="substring-after($text, ',')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <id value="{$text}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ========== WHITELIST DEFINITIONS ========== -->

    <!-- Horses -->
    <xsl:variable name="whitelist-horses" select="concat(
        'aserai_horse,',
        'camel,',
        'charger,',
        'horse_harness_e,',
        'khuzait_horse,',
        'mule,',
        'mule_unmountable,',
        'pack_camel,',
        'pack_camel_unmountable,',
        'sumpter_horse,',
        'vlandia_horse,'
    )"/>

    <!-- Siege Equipment -->
    <xsl:variable name="whitelist-siege" select="concat(
        'ballista_c_projectile_grape_projectile,',
        'ballista_projectile,',
        'boulder,',
        'boulder_projectile,',
        'grapeshot_fire_projectile,',
        'grapeshot_fire_stack,',
        'grapeshot_projectile,',
        'grapeshot_stack,',
        'grappling_hook,',
        'pot,',
        'pot_projectile,'
    )"/>

    <!-- Native Weapons -->
    <xsl:variable name="whitelist-weapons" select="concat(
        'battania_mace_1_t2,',
        'campaign_banner_small,',
        'cleaver_sword_t3,',
        'falchion_sword_t2,',
        'horse_whip,',
        'leather_round_shield,',
        'short_sword_t3,',
        'torch,',
        'vlandia_lance_2_t4,',
        'wooden_sword_t1,'
    )"/>

    <!-- Native Ranged -->
    <xsl:variable name="whitelist-ranged" select="concat(
        'blunt_arrows,',
        'leafblade_throwing_knife,',
        'nordic_shortbow,',
        'pugio,'
    )"/>

    <!-- Native Goods -->
    <xsl:variable name="whitelist-goods" select="concat(
        'butter,',
        'cheese,',
        'chicken,',
        'cotton,',
        'cow,',
        'fish,',
        'fur,',
        'goose,',
        'grain,',
        'hardwood,',
        'hog,',
        'iron,',
        'leather,',
        'linen,',
        'meat,',
        'pottery,',
        'salt,',
        'sheep,',
        'wine,',
        'wool,'
    )"/>

    <!-- Native Armour -->
    <xsl:variable name="whitelist-armour" select="concat(
        'desert_lamellar,',
        'leather_cavalier_boots,',
        'nasal_helmet_with_mail,',
        'reinforced_mail_mitten,',
        'short_padded_robe'
    )"/>

    <!-- Merge all categories -->
    <xsl:variable name="whitelist-raw" 
        select="concat(
            $whitelist-horses,
            $whitelist-siege,
            $whitelist-weapons,
            $whitelist-ranged,
            $whitelist-goods,
            $whitelist-armour
        )"/>

    <!-- Build node-set from raw string -->
    <xsl:variable name="whitelist-fragment">
        <xsl:call-template name="tokenize">
            <xsl:with-param name="text" select="$whitelist-raw"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="whitelist" select="msxsl:node-set($whitelist-fragment)/id"/>

    <!-- ========== TRANSFORM LOGIC ========== -->

    <!-- Identity transform -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Item and CraftedItem: copy only if whitelisted -->
    <xsl:template match="Item|CraftedItem">
        <xsl:if test="@id = $whitelist/@value">
            <xsl:copy-of select="."/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
