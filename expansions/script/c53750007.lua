local m=53750007
local cm=_G["c"..m]
cm.name="吟乐之森的谈士"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCondition(cm.negcon)
	e2:SetCost(cm.negcost)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ((ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)) or (ep==tp and re:GetHandler():IsSetCard(0x9532) and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function cm.tgfilter(c)
	return c:IsSetCard(0x9532) and c:GetType()==TYPE_SPELL and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:GetActivateEffect() and c:IsLocation(LOCATION_MZONE) then
		c:RegisterFlagEffect(m+33,RESET_CHAIN,0,1)
		c:RegisterFlagEffect(m+66,RESET_CHAIN,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,3))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.accon1)
		e1:SetTarget(cm.actg1)
		e1:SetOperation(cm.acop)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_DELAY)
		e2:SetCondition(cm.accon2)
		e2:SetTarget(cm.actg2)
		c:RegisterEffect(e2,true)
	end
end
function cm.accon1(e,tp,eg,ep,ev,re,r,rp)
	local check=false
	if e:GetHandler():GetFlagEffect(m+33)>0 then
		e:GetHandler():ResetFlagEffect(m+33)
		check=true
	end
	return check
end
function cm.accon2(e,tp,eg,ep,ev,re,r,rp)
	local check=false
	if e:GetHandler():GetFlagEffect(m+66)>0 then
		e:GetHandler():ResetFlagEffect(m+66)
		check=true
	end
	return check
end
function cm.actg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local le={e:GetLabelObject():GetActivateEffect()}
	local check=false
	if chk==0 then
		e:SetCostCheck(false)
		for _,te in pairs(le) do
			local ftg=te:GetTarget()
			if (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) then check=true end
		end
		return check
	end
	local off=1
	local ops={}
	local opval={}
	for i,te in pairs(le) do
		local tg=te:GetTarget()
		e:SetCostCheck(false)
		if (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
			local des=te:GetDescription()
			if des then ops[off]=des else ops[off]=aux.Stringid(m,2) end
			opval[off-1]=i
			off=off+1
		end
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local s=opval[op]
	e:SetLabel(s)
	local ae=le[s]
	local cat=ae:GetCategory()
	if cat then e:SetCategory(cat) else e:SetCategory(0) end
	local pro,pro2=ae:GetProperty()
	pro=pro|EFFECT_FLAG_DELAY
	e:SetProperty(pro,pro2)
	local etg=ae:GetTarget()
	if etg then
		e:SetCostCheck(false)
		etg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.actg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local le={e:GetLabelObject():GetActivateEffect()}
	local check=false
	if chk==0 then
		e:SetCostCheck(false)
		for _,te in pairs(le) do
			local ftg=te:GetTarget()
			if (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) then check=true end
		end
		return check and tp~=e:GetHandler():GetControler()
	end
	local off=1
	local ops={}
	local opval={}
	for i,te in pairs(le) do
		local tg=te:GetTarget()
		e:SetCostCheck(false)
		if (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
			local des=te:GetDescription()
			if des then ops[off]=des else ops[off]=aux.Stringid(m,2) end
			opval[off-1]=i
			off=off+1
		end
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local s=opval[op]
	e:SetLabel(s)
	local ae=le[s]
	local cat=ae:GetCategory()
	if cat then e:SetCategory(cat) else e:SetCategory(0) end
	local pro,pro2=ae:GetProperty()
	pro=pro|EFFECT_FLAG_BOTH_SIDE
	pro=pro|EFFECT_FLAG_DELAY
	e:SetProperty(pro,pro2)
	local etg=ae:GetTarget()
	if etg then
		e:SetCostCheck(false)
		etg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local le={e:GetLabelObject():GetActivateEffect()}
	local ae=le[e:GetLabel()]
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ((ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)) or (ep==tp and re:GetHandler():IsSetCard(0x9532) and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE))) and Duel.IsChainNegatable(ev)
end
function cm.costfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:GetType()==TYPE_SPELL and c:IsAbleToGraveAsCost()
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c):GetFirst()
	Duel.SendtoGrave(Group.FromCards(c,tc),REASON_COST)
	if c:IsType(TYPE_EFFECT) and c:IsLocation(LOCATION_GRAVE) and tc:IsLocation(LOCATION_GRAVE) and tc:GetActivateEffect() then
		if c:GetFlagEffect(m)==0 then c:RegisterFlagEffect(m,RESET_CHAIN,0,1) end
		local le={tc:GetActivateEffect()}
		local ct=#le
		local ch=Duel.GetCurrentChain()
		for i,te in pairs(le) do
			local e1=Effect.CreateEffect(c)
			if ct==1 then e1:SetDescription(aux.Stringid(m,2)) else e1:SetDescription(te:GetDescription()) end
			e1:SetCategory(te:GetCategory())
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetProperty(te:GetProperty())
			e1:SetLabel(ch)
			e1:SetLabelObject(tc)
			e1:SetValue(i)
			e1:SetTarget(cm.spelltg)
			e1:SetOperation(cm.spellop)
			e1:SetReset(RESET_CHAIN)
			c:RegisterEffect(e1)
		end
	end
end
function cm.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local ftg=ae:GetTarget()
	local flag=e:GetHandler():GetFlagEffectLabel(m)
	local cf=1<<e:GetLabel()
	if chk==0 then
		e:SetCostCheck(false)
		return (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) and bit.band(flag,cf)==0
	end
	e:GetHandler():SetFlagEffectLabel(m,flag|cf)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetLabel(e:GetLabel())
	e1:SetOperation(cm.negop2)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	if ftg then
		e:SetCostCheck(false)
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.negop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==e:GetLabel() then Duel.NegateEffect(e:GetLabel()) end
end
function cm.spellop(e,tp,eg,ep,ev,re,r,rp)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
