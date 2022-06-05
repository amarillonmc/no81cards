local m=25000405
local cm=_G["c"..m]
cm.name="零二龙 程式升蝗"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,function(c)return c:GetLevel()>0 and c:IsRace(RACE_PSYCHO)end,function(g)return g:GetClassCount(Card.GetLevel)==1 end,3,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetCondition(function(e)return e:GetHandler():GetFlagEffect(m)==0 end)
	e1:SetValue(114514)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)&LOCATION_ONFIELD~=0 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc:IsRelateToEffect(te) then dg:AddCard(tc) end
	end
	Duel.SetTargetCard(dg)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	while Duel.CheckRemoveOverlayCard(p,1,1,1,REASON_EFFECT) do
		if not Duel.CheckRemoveOverlayCard(p,1,0,1,REASON_EFFECT) or not Duel.SelectYesNo(p,aux.Stringid(m,1)) then break end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DEATTACHFROM)
		local sg=Duel.SelectMatchingCard(p,Card.CheckRemoveOverlayCard,p,LOCATION_MZONE,0,1,1,nil,p,1,REASON_EFFECT)
		Duel.HintSelection(sg)
		if sg:GetFirst():RemoveOverlayCard(p,1,1,REASON_EFFECT) then p=1-p else break end
	end
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp==p and Duel.NegateActivation(i) and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then dg:AddCard(tc) end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttackTarget()~=nil then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
