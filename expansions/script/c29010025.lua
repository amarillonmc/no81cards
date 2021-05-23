--急袭猛禽-穹顶轰击
if not pcall(function() require("expansions/script/c29010000") end) then require("script/c29010000") end
local m,cm = rscf.DefineCard(29010025)
function cm.initial_effect(c)
	local e1 = rsef.A(c,nil,nil,nil,"sp","tg",nil,nil,
		rstg.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.act)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(cm.imcon)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xba) and c:IsRankAbove(6) and rscf.spfilter2()(c,e,tp) and e:GetHandler():IsCanOverlay()
end
function cm.spfilter2(c,e,tp,matc)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,matc,c) > 0 and matc:IsCanBeXyzMaterial(c)
		and c:IsRank(matc:GetRank() + 1) and aux.MustMaterialCheck(matc,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsSetCard(0xba)
end
function cm.act(e,tp)
	local c,tc = rscf.GetSelf(e), rscf.GetTargetCard()
	if not tc or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) <= 0 or not tc:IsType(TYPE_XYZ) or not c or rsop.Overlay(e,tc,c) <= 0 then return end
	rsop.SelectExPara("sp",true)
	local og,sc = rsop.SelectCards("sp",tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	if not sc then return end
	rsop.Overlay(nil,sc,tc,true,true)
	Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function cm.imcon(e)
	return e:GetHandler():IsSetCard(0xba)
end