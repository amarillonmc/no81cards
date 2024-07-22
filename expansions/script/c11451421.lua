--crad guard of dragon palace
local cm,m=GetID()
function cm.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,m-15)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(0)
	e4:SetCondition(cm.condition0)
	c:RegisterEffect(e4)
	cm.hand_effect=cm.hand_effect or {}
    cm.hand_effect[c]=e1
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(cm.condition2)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function cm.filter2(c)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function cm.filter3(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.filter4(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and not e:GetHandler():IsPublic() and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.condition0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,11451425) and not e:GetHandler():IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local c=g:GetFirst()
	Duel.ConfirmCards(1-tp,c)
	Duel.ShuffleHand(tp)
	if tp==Duel.GetTurnPlayer() then Duel.IsPlayerAffectedByEffect(tp,11451425):GetHandler():RegisterFlagEffect(11451425,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTarget(function(e,c) return c:IsSetCard(0x6978) and c:IsFaceup() end)
	e3:SetValue(function(e,re,r,rp) if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then return 1 else return 0 end end)
	Duel.RegisterEffect(e3,tp)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter3,1,nil,1-tp) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and not eg:IsContains(e:GetHandler())
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter4,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter4,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g4=g2:Select(tp,1,1,nil)
		local g3=g1:Select(tp,1,1,nil)
		g3:Merge(g4)
		Duel.ConfirmCards(1-tp,g3)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local g5=g3:RandomSelect(1-tp,1)
		Duel.ShuffleDeck(tp)
		local tc=g5:GetFirst()
		if tc:IsAbleToHand() then
			tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end