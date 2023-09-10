--始 于 墓 园 的 归 宿
local m=22348131
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348131+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c22348131.target)
	e1:SetOperation(c22348131.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22348131.actcon)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetTarget(c22348131.settg)
	e3:SetOperation(c22348131.setop)
	c:RegisterEffect(e3)
	
end
function c22348131.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x703)
end
function c22348131.actcon(e)
	return Duel.IsExistingMatchingCard(c22348131.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c22348131.tgfilter(c)
	return c:IsSetCard(0x703) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c22348131.spfilter(c,e,tp)
	return c:IsCode(22348080) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348131.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348131.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,0)
end
function c22348131.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	local rg=Duel.SelectMatchingCard(tp,c22348131.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,ct1,c)
	local ct2=Duel.SendtoGrave(rg,REASON_EFFECT)
	if ct2==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,ct2,ct2,nil)
	Duel.HintSelection(dg)
	local ct3=Duel.SendtoGrave(dg,REASON_EFFECT)
	if ct3~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and dg:GetFirst():IsLocation(LOCATION_GRAVE) then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348131.spfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,ct3,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
function c22348131.settgfilter(c)
	return c:IsSetCard(0x703) and c:IsAbleToGrave()
end
function c22348131.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() and 
	Duel.IsExistingMatchingCard(c22348131.settgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c22348131.settgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c22348131.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c22348131.settgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if Duel.SendtoGrave(tg,REASON_EFFECT) and tg:GetFirst():IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKSHF)
		c:RegisterEffect(e1)
	end
end



