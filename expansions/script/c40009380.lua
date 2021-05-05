--真武神决战
function c40009380.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c40009380.target)
	e1:SetOperation(c40009380.activate)
	c:RegisterEffect(e1)
end
function c40009380.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x88)
end
function c40009380.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c40009380.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009380.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40009380.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c40009380.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(40009380,0))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetTarget(c40009380.rmtg)
		e1:SetOperation(c40009380.rmop)
		e1:SetReset(RESET_EVENT+0x1620000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c40009380.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
		 and bc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function c40009380.rmfilter(c,code)
	return c:IsCode(code) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c40009380.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(c40009380.rmfilter,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,nil,tc:GetCode())
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

