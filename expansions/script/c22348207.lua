--植实兽 利切拉
function c22348207.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348207,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348207)
	e1:SetTarget(c22348207.sptg)
	e1:SetOperation(c22348207.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348207,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,22348207)
	e2:SetCondition(c22348207.spcon)
	e2:SetTarget(c22348207.sptg)
	e2:SetOperation(c22348207.spop2)
	c:RegisterEffect(e2)
	--Search Card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348207,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22348207.sccon)
	e3:SetCost(c22348207.sccost)
	e3:SetTarget(c22348207.sctg)
	e3:SetOperation(c22348207.scop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCountLimit(1,22350205)
	e4:SetDescription(aux.Stringid(22348205,2))
	e4:SetCondition(c22348207.sccon2)
	c:RegisterEffect(e4)
	c22348207.discard_effect=e3
	--count
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_TO_HAND)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCondition(c22348207.checkcon)
		e4:SetOperation(c22348207.checkop)
		c:RegisterEffect(e4)
end
function c22348207.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c22348207.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(22348207,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22348207,5))
end
function c22348207.tgfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:Is(LOCATION_ONFIELD))
end
function c22348207.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348207.tgfilter,1,nil)
end
function c22348207.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348207.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(22348207,2)) then
		Duel.BreakEffect()
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
function c22348207.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local g=ag:Filter(Card.IsType,nil,TYPE_MONSTER)
	local gg=g:Filter(Card.IsAbleToHand,nil)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(22348207,3)) then
		Duel.BreakEffect()
		Duel.SendtoHand(gg,tp,REASON_EFFECT)
	end
end
function c22348207.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22348207)>0
end
function c22348207.sccon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22348205)
end
function c22348207.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c22348207.filter(c)
	return c:IsSetCard(0x707) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(22348207)
end
function c22348207.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c22348207.scop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c22348207.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22348207.filter11(c)
	return c:IsSetCard(0x707) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(22348207)
end
function c22348207.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348207)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348207.filter11),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
