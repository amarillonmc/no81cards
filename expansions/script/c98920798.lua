--极意之指名者
function c98920798.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c98920798.drcost)
	e1:SetTarget(c98920798.target)
	e1:SetOperation(c98920798.activate)
	c:RegisterEffect(e1)	
end
function c98920798.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c98920798.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local aat=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL&~e:GetHandler():GetAttribute())
	e:SetLabel(aat)
end
function c98920798.activate(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c98920798.discon)
	e2:SetOperation(c98920798.disop)
	e2:SetLabel(att)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c98920798.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.IsChainNegatable(ev) and re:GetHandler():IsAttribute(e:GetLabel())
end
function c98920798.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end