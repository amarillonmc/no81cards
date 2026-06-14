--圣垠界域
function c11182305.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_FZONE)
	e1:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCountLimit(1,11182305)
	e1:SetCondition(c11182305.atkcon)
	e1:SetTarget(c11182305.atktg)
	e1:SetOperation(c11182305.atkop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DISCARD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11182305+1)
	e2:SetTarget(c11182305.tgtg)
	e2:SetOperation(c11182305.tgop)
	c:RegisterEffect(e2)
	--change cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(11182305)
	e3:SetCountLimit(2,11182305+2)
	e3:SetTarget(c11182305.repfilter)
	e3:SetTargetRange(0x30,0)
	c:RegisterEffect(e3)
end
function c11182305.repfilter(e,c)
	return true
end
function c11182305.tgfilter(c)
	return c:IsSetCard(0x6454) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c11182305.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182305.tgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11182305.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c11182305.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			else
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end
			tc=g:GetNext()
		end
	end
end
function c11182305.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase()
end
function c11182305.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6454)
end
function c11182305.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182305.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c11182305.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11182305.atkfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetCount()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct*500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end