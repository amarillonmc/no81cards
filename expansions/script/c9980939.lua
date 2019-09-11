--幽灵骑士Specter·信长魂
function c9980939.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT),aux.NonTuner(Card.IsSetCard,0xcbc2),1)
	c:EnableReviveLimit()
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980939,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9980939.mtcon)
	e1:SetOperation(c9980939.mtop)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980939,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTarget(c9980939.destg)
	e3:SetOperation(c9980939.desop)
	c:RegisterEffect(e3)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c9980939.retreg)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980939.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980939.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980939,3))
end
function c9980939.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function c9980939.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:FilterCount(Card.IsType,nil,TYPE_SPIRIT)
	Duel.ShuffleDeck(tp)
	if ct>1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct-1)
		c:RegisterEffect(e1)
	elseif ct==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980939,4))
end
function c9980939.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9980939.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980939,4))
	end
end
function c9980939.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(aux.SpiritReturnCondition)
	e1:SetTarget(c9980939.rettg)
	e1:SetOperation(c9980939.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c9980939.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcbc2) and c:IsAbleToHand()
end
function c9980939.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.IsExistingMatchingCard(c9980939.thfilter,tp,LOCATION_DECK,0,1,nil) end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9980939.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980939.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoExtraP(c,nil,REASON_EFFECT)~=0
		and g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980939,4))
	end
end
