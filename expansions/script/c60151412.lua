--LUKA Just Be Friends
function c60151412.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.NonTuner(Card.IsSetCard,0x3b28),1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c60151412.regop)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60151412.condition)
	e2:SetOperation(c60151412.operation)
	c:RegisterEffect(e2)
	--dm
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c60151412.acop)
	c:RegisterEffect(e3)
end
function c60151412.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TO_DECK)
	e1:SetReset(RESET_EVENT+0x1fc0000+RESET_CHAIN)
	e1:SetValue(1)
	e:GetHandler():RegisterEffect(e1)
end
function c60151412.condition(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsOnField() and tc:IsControler(tp)
end
function c60151412.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c60151412.operation(e,tp,eg,ep,ev,re,r,rp)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if Duel.SelectYesNo(tp,aux.Stringid(60151412,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c60151412.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
		Duel.ChangeTargetCard(ev,Group.FromCards(g:GetFirst()))
	end
end
function c60151412.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c60151412.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c60151412.cfilter,nil)
	if ct>0 then
		Duel.Hint(HINT_CARD,0,60151412)
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end