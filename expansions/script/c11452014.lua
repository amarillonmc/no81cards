--二联性精神病-共犯妄想-
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(cm.cost)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
	--change effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.chcon)
	e4:SetOperation(cm.chop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetCondition(cm.clearcon)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_CHAIN_NEGATED)
		ge4:SetCondition(cm.rscon)
		ge4:SetOperation(cm.reset)
		Duel.RegisterEffect(ge4,0)
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	cm[ev]={re,rp}
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm[ev]={re,2}
end
function cm.clearcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	local i=1
	while cm[i] do
		cm[i]=nil
		i=i+1
	end
end
function cm.handcon(e)
	local tp=e:GetHandlerPlayer()
	local b1,b2
	for i=1,Duel.GetCurrentChain() do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp==tp then b1=true elseif tgp==1-tp then b2=true end
	end
	return b1 and b2 and Duel.GetTurnPlayer()==tp
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetCondition(cm.chcon)
	e4:SetOperation(cm.chop)
	e4:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e4,tp)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local i=Duel.GetCurrentChain()
	local ct=0
	if e:GetHandler()==re:GetHandler() then return false end
	while type(cm[i])=="table" do
		if cm[i][2]<=1 and cm[i][1]:GetHandler()~=e:GetHandler() then ct=ct+1 end
		i=i+1
	end
	if ct<=2 then e:SetLabel(ct) return true end
	return false
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	if e:GetLabel()<=1 then
		Duel.ChangeChainOperation(ev,cm.repop)
	else
		Duel.ChangeChainOperation(ev,cm.repop2)
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsType(TYPE_CONTINUOUS) then exc=aux.ExceptThisCard(e) end
	local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exc)
	Duel.HintSelection(sg)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function cm.repop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then Duel.Draw(1-tp,1,REASON_EFFECT) end
end