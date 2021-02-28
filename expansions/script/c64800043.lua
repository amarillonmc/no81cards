--杰作拼图1001-『星星』
local m=64800043
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,4)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(cm.condition)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetLabelObject(e3)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,tp,0,0)
	local z=e:GetHandler():GetLinkedZone()
	local sg=eg:Filter(cm.cfilter,nil,tp,z)
	local code=sg:GetFirst():GetOriginalCode()
	e:SetLabel(code)
end
function cm.cfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function cm.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetLabelObject():GetLabel()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,code) 
	if chk==0 then return b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabelObject():GetLabel()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,code)
	if b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,code)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--e2
function cm.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and cm.rmfilter(chkc) end
	local ct=e:GetHandler():GetLinkedGroupCount()
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,nil) and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),nil,LOCATION_GRAVE+LOCATION_MZONE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
	local c=e:GetHandler()
	if ct>0 then
	local tsp=tp
		if Duel.IsExistingMatchingCard(cm.sumfilter,tsp,LOCATION_HAND,0,1,nil,e,tsp)
			and Duel.SelectYesNo(tsp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tsp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tsp,cm.sumfilter,tsp,LOCATION_HAND,0,1,1,nil,e,tsp)
			Duel.SpecialSummon(g1,0,tsp,tsp,false,false,POS_FACEUP) 
		end
		tsp=1-tp
		if Duel.IsExistingMatchingCard(cm.sumfilter,tsp,LOCATION_HAND,0,1,nil,e,tsp)
			and Duel.SelectYesNo(tsp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tsp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tsp,cm.sumfilter,tsp,LOCATION_HAND,0,1,1,nil,e,tsp)
			Duel.SpecialSummon(g2,0,tsp,tsp,false,false,POS_FACEUP) 
		end
	end
end
function cm.sumfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end