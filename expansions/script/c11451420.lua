--shrimp captain of dragon palace
local m=11451420
local cm=_G["c"..m]
function cm.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,m-15)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.condition2)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsPublic()
end
function cm.filter2(c)
	return c:IsSetCard(0x6978) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return (tp~=Duel.GetTurnPlayer() or Duel.IsPlayerAffectedByEffect(tp,11451425)) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) and not e:GetHandler():IsPublic() and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local c=g:GetFirst()
	Duel.ConfirmCards(1-tp,c)
	Duel.ShuffleHand(tp)
	if tp==Duel.GetTurnPlayer() then Duel.IsPlayerAffectedByEffect(tp,11451425):GetHandler():RegisterFlagEffect(11451425,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAINING)
			e2:SetOperation(cm.chainop)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and ep==tp then
		Duel.SetChainLimit(function(e,rp,tp) return tp==rp end)
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,LOCATION_DECK)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)<5 then return end
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:GetCount()>0 and g:IsExists(cm.filter2,1,nil) and Duel.SelectYesNo(p,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local g2=g:FilterSelect(p,cm.filter2,1,1,nil)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,g2)
	end
	Duel.ShuffleDeck(p)
end