--命运英雄 恐惧小子
function c98920084.initial_effect(c)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE,EFFECT_FLAG2_WICKED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c98920084.adval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e5)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920084,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c98920084.cost)
	e1:SetTarget(c98920084.target)
	e1:SetOperation(c98920084.operation)
	c:RegisterEffect(e1)
	--change effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(98920084)
	e5:SetRange(0xff)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	c:RegisterEffect(e5)
	--workaround
	if not aux.name_hack_check then
		aux.name_hack_check=true
		_code=Card.IsCode
		function Card.IsCode(c,code)
			if Duel.IsPlayerAffectedByEffect(c:GetControler(),98920084) and code==75041269 then
				return _code(c,98920084) or _code(c,75041269)
			end
			return _code(c,code)
		end
	end
end
function c98920084.negfilter(c)
	return aux.NegateMonsterFilter(c) and c:IsType(TYPE_XYZ)
end
function c98920084.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c98920084.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c98920084.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsCode(98920084)
end
function c98920084.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsCode(40591390)
end
function c98920084.sfilter(c)
	return c:IsFaceup() and not c:IsCode(98920084) and c:IsSetCard(0xc008)
end
function c98920084.adval(e,c)
	local g=Duel.GetMatchingGroup(c98920084.sfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then
		return 0
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val+0
	end
end
function c98920084.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920084.filter(c)
	return c:IsSetCard(0xc008) and c:IsLevel(8) and c:IsAbleToHand()
end
function c98920084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920084.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920084.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920084.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		tc=g:GetFirst()
		if tc:IsCode(40591390) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)		   
		end
	end
end