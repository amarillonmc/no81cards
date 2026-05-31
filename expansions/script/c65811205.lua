function c65811205.initial_effect(c)
	c:SetUniqueOnField(1,0,65811205)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_CHAIN_END+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65811205,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c65811205.thtg)
	e2:SetOperation(c65811205.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65811205,1))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c65811205.tgtg)
	e3:SetOperation(c65811205.tgop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(65811205,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(c65811205.tstg)
	e4:SetOperation(c65811205.tsop)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(65811205,3))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c65811205.skcon)
	e6:SetOperation(c65811205.skop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_REMOVE_TYPE)
	e9:SetValue(TYPE_QUICKPLAY)
	c:RegisterEffect(e9)
	--act qp in hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetCondition(c65811205.handcon)
	c:RegisterEffect(e5)
	local e0=e5:Clone()
	e0:SetCode(65811205)
	c:RegisterEffect(e0)
	--activate cost
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_ACTIVATE_COST)
	e10:SetRange(LOCATION_SZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(1,0)
	e10:SetCost(c65811205.costchk)
	e10:SetTarget(c65811205.costtg)
	e10:SetOperation(c65811205.costop)
	c:RegisterEffect(e10)
end
function c65811205.thfilter(c,tp)
	return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c65811205.thfilter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c65811205.thfilter2(c,tc)
	return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(tc:GetCode())
end
function c65811205.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65811205.thfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65811205.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c65811205.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c65811205.thfilter2,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst())
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c65811205.tgfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup() and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c65811205.tgfilter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c65811205.tgfilter2(c,tc)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGrave() and not c:IsCode(tc:GetCode())
end
function c65811205.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65811205.tgfilter,tp,LOCATION_REMOVED,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65811205.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65811205.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c65811205.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst())
		if tg:GetCount()>0 then
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end
function c65811205.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,118658527) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65811205.tsop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,118658527)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65811205.repcfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c65811205.repcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65811205.repcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c65811205.repfilter(c)
	return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and c:IsFaceup() and c:IsAbleToDeck()
end
function c65811205.reptg(e,c)
	if not Duel.IsExistingMatchingCard(c65811205.repfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,2,nil) then return false end
	if not c:IsSetCard(0x306e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c65811205.actarget)
		e1:SetOperation(c65811205.costop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		return true
	end
	return false
end
function c65811205.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function c65811205.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65811205)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c65811205.repfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()==2 then
		Duel.SendtoDeck(g,nil,nil,REASON_EFFECT)
	end
end
function c65811205.skcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return tp~=Duel.GetTurnPlayer()
end
function c65811205.skop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end

function c65811205.cofilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x306e) and c:IsAbleToDeckAsCost()
end
function c65811205.handcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c65811205.costtg(e,te,tp)
	local tc=te:GetHandler()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
		and tc:IsLocation(LOCATION_HAND) and tc:GetEffectCount(65811205)>0
		and ((tc:GetEffectCount(EFFECT_QP_ACT_IN_NTPHAND)<=tc:GetEffectCount(65811205) and tc:IsType(TYPE_QUICKPLAY)))
end
function c65811205.costchk(e,te_or_c,tp)
	return Duel.IsExistingMatchingCard(c65811205.cofilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,2,nil)
end
function c65811205.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65811205)
	Duel.Hint(HINT_SELECTMSG,e:GetHandlerPlayer(),HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c65811205.cofilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
