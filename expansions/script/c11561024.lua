--梦幻崩影·骑士
function c11561024.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,nil,c11561024.lcheck)
	c:EnableReviveLimit()   
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11561024)
	e1:SetCondition(function(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD) end)
	e1:SetTarget(c11561024.sptg)
	e1:SetOperation(c11561024.spop)
	c:RegisterEffect(e1) 
	--limit 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE) 
	e2:SetTarget(function(e,c) 
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsLinkState() end)
	e2:SetValue(1) 
	c:RegisterEffect(e2) 
end
function c11561024.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c11561024.spfilter(c,e,tp,zone)
	return c:IsType(TYPE_LINK) and c:IsLinkBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c11561024.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11561024.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11561024.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	if e:GetHandler():GetMutualLinkedGroupCount()>0 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetLabel(1)
	else
		e:SetCategory(0)
		e:SetLabel(0)
	end 
end
function c11561024.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2,true)
		if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(11561024,0)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end 
end


