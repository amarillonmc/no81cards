--狩猎游戏加载中
function c12877030.initial_effect(c)
	--activate:search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12877030+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12877030.target)
	e1:SetOperation(c12877030.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c12877030.reptg)
	e2:SetValue(c12877030.repval)
	e2:SetOperation(c12877030.repop)
	c:RegisterEffect(e2)
end
function c12877030.thfilter(c)
	return c:IsSetCard(0x9a7b) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c12877030.rlfilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then val=re:GetValue() end
	return c:IsReleasableByEffect() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and (val==nil or val(re,c)~=true))
end
function c12877030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12877030.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c12877030.rlfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c12877030.pfilter(c,atk)
	return c:IsSetCard(0x9a7b) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAttackBelow(atk)
end
function c12877030.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c12877030.rlfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	if Duel.Release(g,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c12877030.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if Duel.IsExistingMatchingCard(c12877030.pfilter,tp,LOCATION_EXTRA,0,1,nil,tc:GetAttack()) and Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==0 and Duel.SelectYesNo(tp,aux.Stringid(12877030,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local pc=Duel.SelectMatchingCard(tp,c12877030.pfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetAttack()):GetFirst()
			if pc then Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
		end
	end
end
function c12877030.repfilter(c,tp)
	return c:IsSetCard(0x9a7b) and c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c12877030.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c12877030.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c12877030.repval(e,c)
	return c12877030.repfilter(c,e:GetHandlerPlayer())
end
function c12877030.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,12877030)
end
