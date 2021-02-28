--星系守护神 半人马星神
local m=64800042
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(0x14000+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.sptg1)
	e2:SetOperation(cm.spop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e5)
end
function cm.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	Debug.Message(#g)
	Debug.Message(eg:IsExists(cm.filter,1,nil,tp,rp))
	return #g==0 and eg:IsExists(cm.filter,1,nil,tp,rp) and Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)==0
end
function cm.filter(c,tp,rp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp  and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) then
	Duel.SetChainLimit(function(e,ep,tp)
	return tp==ep
end)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,c)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end