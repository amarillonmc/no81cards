--镇压革命
local m=11451450
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99518961)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c,e,tp)
	return c:IsCode(11451446) and c:IsType(TYPE_MONSTER) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,1-tp,c) and (c:GetOwner()==tp or c:IsLocation(LOCATION_DECK))
end
function cm.filter2(c,e,tp)
	return c:IsCode(11451446) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,58538870) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,12143771) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,85936485)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>=2 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,2,nil,e,tp) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local m=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local sg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	if m>0 and sg:GetCount()>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=sg:Select(tp,2,2,nil)
		Duel.SpecialSummon(g1,0,tp,1-tp,true,false,POS_FACEUP)
	end
	--avoid damage
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.damval(e,re,val,r,rp)
	if r&REASON_EFFECT==REASON_EFFECT and re and re:GetHandler():IsCode(99518961) and rp and rp==e:GetHandlerPlayer() then return 0 end
	return val
end