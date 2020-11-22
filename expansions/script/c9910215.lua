--天空漫步者-缠斗
function c9910215.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910215,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910215+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910215.condition)
	e1:SetTarget(c9910215.target)
	e1:SetOperation(c9910215.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910215,1))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9910215+EFFECT_COUNT_CODE_OATH)
	e2:SetOperation(c9910215.activate2)
	c:RegisterEffect(e2)
end
function c9910215.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsRace(RACE_PSYCHO))
end
function c9910215.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910215.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910215.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsFaceup() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910215.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c9910215.activate2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c9910215.chainop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(c9910215.chop)
	e2:SetLabel(0)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetCondition(c9910215.descon)
	e3:SetOperation(c9910215.desop)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,tp)
end
function c9910215.chainop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==1 then
		Duel.SetChainLimit(c9910215.chainlm)
	end
end
function c9910215.chainlm(e,rp,tp)
	return tp==rp
end
function c9910215.chop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==2 and re and rp==tp then
		e:SetLabel(1)
	end
end
function c9910215.descon(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(0)
	return res==1
end
function c9910215.cfilter(c)
	return c:IsSetCard(0x955) and c:IsDiscardable()
end
function c9910215.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if Duel.IsExistingMatchingCard(c9910215.cfilter,tp,LOCATION_HAND,0,1,nil)
		and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910215,2)) then
		Duel.Hint(HINT_CARD,0,9910215)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c9910215.cfilter,tp,LOCATION_HAND,0,1,1,nil)
		if Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
