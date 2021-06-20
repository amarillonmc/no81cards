--竹子 临冰的决意
function c60002005.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,99,c60002005.lcheck)
	c:EnableReviveLimit()
	--immuse
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c60002005.econ)
	e1:SetValue(c60002005.efilter)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,60002005)
	e2:SetCost(c60002005.cncost)
	e2:SetTarget(c60002005.cntg)
	e2:SetOperation(c60002005.cnop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10002005)
	e3:SetCost(c60002005.cxcost)
	e3:SetTarget(c60002005.cxtg)
	e3:SetOperation(c60002005.cxop)
	c:RegisterEffect(e3)
end
function c60002005.lcheck(g)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_PLANT)
end
function c60002005.econ(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c60002005.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c60002005.cncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(60002005,0))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(60002005,0))
end
function c60002005.cntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c60002005.cnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c60002005.actfilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60002005.actfilter(e,c)
	return not c:IsLevelAbove(1)
end
function c60002005.cxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(60002005,1))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(60002005,1))
end
function c60002005.cxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsLevelAbove,tp,LOCATION_MZONE,0,1,nil,1) and Duel.IsExistingTarget(Card.IsLevelAbove,tp,0,LOCATION_MZONE,1,nil,1) end
	local tc1=Duel.SelectTarget(tp,Card.IsLevelAbove,tp,LOCATION_MZONE,0,1,1,nil,1)
	local tc2=Duel.SelectTarget(tp,Card.IsLevelAbove,tp,0,LOCATION_MZONE,1,1,nil,1)
	local g=Group.FromCards(tc1,tc2)
	Duel.SetTargetCard(g)
end
function c60002005.cxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c60002005.discon)
	e2:SetOperation(c60002005.disop)
	e2:SetLabelObject(tc)
	Duel.RegisterEffect(e2,tp)
	tc=g:GetNext()
	end
end
function c60002005.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetOriginalCodeRule())
end
function c60002005.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60002005)
	Duel.ChangeChainOperation(ev,c60002005.repop)
end
function c60002005.repop(e,tp,eg,ep,ev,re,r,rp)
end




