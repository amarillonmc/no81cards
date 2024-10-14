--极境的体感
local cm,m=GetID()
function cm.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.discon)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	if re:IsHasCategory(CATEGORY_NEGATE) or re:IsHasCategory(CATEGORY_DISABLE_SUMMON) then return true end
	local op=re:GetOperation()
	if Duel.GetCurrentPhase()~=PHASE_BATTLE_STEP or not op then return false end
	secret_sensation=false
	local _Duel={}
	for i,f in pairs(Duel) do
		_Duel[i]=f
		Duel[i]=aux.TRUE
	end
	Duel.NegateAttack=function() secret_sensation=true error() end
	pcall(op,e,tp,eg,ep,ev,re,r,rp)
	local res=secret_sensation
	secret_sensation=false
	for i,f in pairs(_Duel) do
		Duel[i]=_Duel[i]
	end
	return res
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp-100,true) end
	e:SetLabel(lp-100)
	Duel.PayLPCost(tp,lp-100,true)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,rp,LOCATION_ONFIELD,0,1,re:GetHandler()) end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
end