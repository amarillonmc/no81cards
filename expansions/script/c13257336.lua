--超时空世界 幻想乡
local m=13257336
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_FZONE)
	e0:SetOperation(cm.im)
	c:RegisterEffect(e0)
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_QUICK_O)
	--e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e2:SetCode(EVENT_CHAINING)
	--e2:SetCountLimit(1)
	--e2:SetRange(LOCATION_FZONE)
	--e2:SetCondition(cm.bmcon)
	--e2:SetTarget(cm.bmtg)
	--e2:SetOperation(cm.bmop)
	--c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.ctcon)
	e3:SetOperation(cm.ctop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
end
function cm.im(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc then return end
	local BMe=tama.tamas_getTargetTable(rc,"bomb")
	if BMe and re==BMe then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		rc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(cm.efilter)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		e:GetHandler():RegisterEffect(e2)
		if rc:GetEquipTarget() then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetValue(cm.efilter)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			rc:GetEquipTarget():RegisterEffect(e3)
		end
	end
end
function cm.canActivate(c,PCe,eg,ep,ev,re,r,rp)
	local tep=c:GetControler()
	local cost=PCe:GetCost()
	local target=PCe:GetTarget()
	return (not cost or cost(PCe,tep,eg,ep,ev,re,r,rp,0))
		and (not target or target(PCe,tep,eg,ep,ev,re,r,rp,0))
end
function cm.filter(c,eg,ep,ev,re,r,rp)
	local PCe=tama.tamas_getTargetTable(c,"bomb")
	return c:IsFaceup() and PCe and cm.canActivate(c,PCe,eg,ep,ev,re,r,rp)
end
function cm.bmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.bmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.filter(chkc,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,eg,ep,ev,re,r,rp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.efilter)
	e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	e:GetHandler():RegisterEffect(e4)
end
function cm.efilter(e,te)
	return e:GetHandler()~=te:GetHandler()
end
function cm.bmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local tep=tc:GetControler()
		local PCe=tama.tamas_getTargetTable(tc,"bomb")
		if PCe and cm.canActivate(tc,PCe,eg,ep,ev,re,r,rp) then
			local cost=PCe:GetCost()
			local target=PCe:GetTarget()
			local operation=PCe:GetOperation()
			Duel.ClearTargetCard()
			e:SetProperty(PCe:GetProperty())
			tc:CreateEffectRelation(PCe)
			if cost then cost(PCe,tep,eg,ep,ev,re,r,rp,1) end
			if target then target(PCe,tep,eg,ep,ev,re,r,rp,1) end
			if operation then operation(PCe,tep,eg,ep,ev,re,r,rp) end
			tc:ReleaseEffectRelation(PCe)
		end
	end
end
function cm.ctfilter(c,tp)
	return c:IsFaceup() and c:IsCanAddCounter(0x351,1) and c:IsControler(tp)
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter,1,nil,tp)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x351,1)
		tc=g:GetNext()
	end
end
