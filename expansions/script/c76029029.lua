--辉翼天骑 秽血湮耀
local m=76029029
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,76029029)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1) 
	--set 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76029029,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,06029029)
	e1:SetCondition(c76029029.stcon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c76029029.sttg)
	e1:SetOperation(c76029029.stop)
	c:RegisterEffect(e1)
end
c76029029.named_with_Kazimierz=true 
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.IsChainNegatable(ev)
end
function c76029029.ckfil(c)
	return c.named_with_Kazimierz 
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76029029.ckfil,tp,LOCATION_REMOVED,0,1,nil) end 
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,0,nil)
	local xg=g:Select(tp,0,g:GetCount(),nil)
	local xg=g:Select(1-tp,0,g:GetCount(),nil)
	local x=g:FilterCount(c76029029.ckfil,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
	local dg=Group.CreateGroup()
	for i=1,ev do
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	dg:AddCard(tc)
	end
	local lg=dg:Select(tp,1,x,nil)
	local lc=lg:GetFirst()
	while lc do
	lc:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	lc=lg:GetNext()
	end
	for i=1,ev do
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	local p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	if tc:GetFlagEffect(m)~=0 then
	Duel.NegateActivation(i)
	end
	end
end
function c76029029.stcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp 
end
function c76029029.setfilter(c)
	return c.named_with_Kazimierz and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable() 
end
function c76029029.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76029029.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c76029029.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c76029029.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end






