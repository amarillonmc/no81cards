--结界的升华
function c10150047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c10150047.condition)
	e1:SetTarget(c10150047.target)
	e1:SetOperation(c10150047.activate)
	c:RegisterEffect(e1)	
end
function c10150047.cfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and c:IsControler(tp)
end
function c10150047.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or tg:GetCount()<=0 then return false end
	return tg:IsExists(c10150047.cfilter,1,nil,tp)
end
function c10150047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tg=eg:Filter(c10150047.cfilter,nil,tp)
	Duel.SetTargetCard(tg)
end
function c10150047.cfilter2(c,e,tp)
	return c:IsControler(tp) and c:IsRelateToEffect(e)
end
function c10150047.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c10150047.cfilter2,nil,e,tp)
	if g:GetCount()<=0 then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_LIGHT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c10150047.efilter)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2) 
	end 
end
function c10150047.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
