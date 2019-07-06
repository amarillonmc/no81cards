--圣山的神像
local m=33700188
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,cm.lcheck)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(0x14000)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e1)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.splimcon)
	c:RegisterEffect(e2)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function cm.rmfilter(c,e,tp,zone)
	return zone>0 and c:IsFacedown() and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP,tp,zone) and Duel.GetLocationCountFromEx(tp)>0
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_EXTRA,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_EXTRA,nil,e,tp,zone)
	if g:GetCount()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=g:RandomSelect(tp,1):GetFirst()
	if Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP,zone) then
		e:GetHandler():SetCardTarget(tc)
		e:SetLabelObject(tc)
		Duel.SpecialSummonComplete()
	end
end
function cm.splimcon(e)
	local tc=e:GetLabelObject():GetLabelObject()
	return tc and e:GetHandler():GetCardTarget():IsContains(tc)
end
