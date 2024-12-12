local m=31400028
local cm=_G["c"..m]
cm.name="神风的牵绊 薇茵"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lmfilter,2,2,cm.lcheck)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.lmfilter(c)
	return c:IsLinkAttribute(ATTRIBUTE_WIND)
end
function cm.matcheck(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsLinkRace(RACE_SPELLCASTER)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_SPELLCASTER)
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or mg:IsExists(cm.matcheck,1,nil) and not mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.spfilter(c,e,tp,mc)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x10) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--[[
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31400028,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_LINK)
	e1:SetCondition(cm.lspcon)
	e1:SetOperation(cm.lspop)
	c:RegisterEffect(e1)
function cm.lffilter(c,tp,tc)
	return c:IsCanBeLinkMaterial(tc) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER) and Duel.GetLocationCountFromEx(tp,tp,c,tc)>0
end
function cm.lhfilter(c,tp,tc)
	return c:IsCanBeLinkMaterial(tc) and c:IsAttribute(ATTRIBUTE_WIND)
end
function cm.lspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.lffilter,tp,LOCATION_MZONE,0,1,nil,tp,c) and Duel.IsExistingMatchingCard(cm.lhfilter,tp,LOCATION_HAND,0,1,nil,tp,c)
end
function cm.lspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.lffilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local g2=Duel.SelectMatchingCard(tp,cm.lhfilter,tp,LOCATION_HAND,0,1,1,nil,tp,c)
	g:Merge(g2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
end
--]]