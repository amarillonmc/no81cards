local m=53750003
local cm=_G["c"..m]
cm.name="惜乐之森的名士"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.regcost)
	e1:SetTarget(cm.regtg)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.regcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function cm.thfilter(c)
	return c:IsSetCard(0x9532)
end
function cm.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetChainLimit(function(e,ep,tp)return tp==ep end)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.thcon)
	e1:SetOperation(cm.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.thfilter2(c)
	return cm.thfilter(c) and c:IsAbleToHand()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and loc&(LOCATION_HAND+LOCATION_GRAVE)~=0 and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function cm.costfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:GetType()==TYPE_SPELL and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c):GetFirst()
	Duel.SendtoGrave(Group.FromCards(c,tc),REASON_COST)
	local rc=re:GetHandler()
	if rc:IsType(TYPE_EFFECT) and tc:IsLocation(LOCATION_GRAVE) and tc:GetActivateEffect() then
		if rc:GetFlagEffect(m)==0 then rc:RegisterFlagEffect(m,RESET_CHAIN,0,1) end
		local le={tc:GetActivateEffect()}
		local ct=#le
		local ch=Duel.GetCurrentChain()
		for i,te in pairs(le) do
			local e1=Effect.CreateEffect(rc)
			if ct==1 then e1:SetDescription(aux.Stringid(m,2)) else e1:SetDescription(te:GetDescription()) end
			e1:SetCategory(te:GetCategory())
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
			e1:SetProperty(te:GetProperty())
			e1:SetLabel(1<<ch)
			e1:SetLabelObject(tc)
			e1:SetValue(i)
			e1:SetTarget(cm.spelltg)
			e1:SetOperation(cm.spellop)
			e1:SetReset(RESET_CHAIN)
			rc:RegisterEffect(e1)
		end
	end
end
function cm.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local ftg=ae:GetTarget()
	local flag=e:GetHandler():GetFlagEffectLabel(m)
	if chk==0 then
		e:SetCostCheck(false)
		return (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) and bit.band(flag,e:GetLabel())==0
	end
	e:GetHandler():SetFlagEffectLabel(m,flag|e:GetLabel())
	if ftg then
		e:SetCostCheck(false)
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.spellop(e,tp,eg,ep,ev,re,r,rp)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
