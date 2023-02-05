local m=53796094
local cm=_G["c"..m]
cm.name="尘花悦春"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(0,m)<1 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,m)>0 then return end
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(cm.rcon)
	e1:SetOperation(cm.rop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local le={Duel.IsPlayerAffectedByEffect(tp,m)}
	for _,v in pairs(le) do
		if v:GetLabel()==re:GetHandler():GetOriginalCodeRule() then return false end
	end
	return true
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetOriginalCodeRule()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(m)
	e0:SetLabel(code)
	e0:SetTargetRange(1,1)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local check=0
	if cm.check(re,ev) then check=1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetLabel(check,code)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local l,d=e:GetLabel()
	if re:GetHandler():GetOriginalCodeRule()~=d then return false end
	local res=false
	local le={Duel.IsPlayerAffectedByEffect(tp,m)}
	for _,v in pairs(le) do
		if v:GetLabel()==re:GetHandler():GetOriginalCodeRule() then res=true end
	end
	return res and ((l==0 and cm.check(re,ev)) or (l==1 and not cm.check(re,ev)))
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,aux.NULL)
end
function cm.check(re,ev)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex4=re:IsHasCategory(CATEGORY_DRAW)
	local ex5=re:IsHasCategory(CATEGORY_SEARCH)
	local ex6=re:IsHasCategory(CATEGORY_DECKDES)
	return ((ex2 and bit.band(dv2,LOCATION_DECK)==LOCATION_DECK)
		or (ex3 and bit.band(dv3,LOCATION_DECK)==LOCATION_DECK)
		or ex4 or ex5 or ex6)
end
