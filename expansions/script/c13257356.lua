--鸟超时空战斗机-国主 雀巳
local m=13257356
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	c:EnableCounterPermit(0x351)
	c:EnableCounterPermit(0x352)
	c:SetCounterLimit(0x352,4)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.accon)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,6))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(cm.bombcost)
	e4:SetOperation(cm.bombop)
	c:RegisterEffect(e4)
	--flash bomb
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,5))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(cm.fbcost)
	e5:SetOperation(cm.fbop)
	c:RegisterEffect(e5)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(cm.bgmop)
	c:RegisterEffect(e11)
	eflist={"power_capsule",e3,"bomb",e4}
	cm[c]=eflist
	
end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(1)>0
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x352,1)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_DISABLE,0,1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_DISABLE)
	e5:SetValue(1000)
	c:RegisterEffect(e5)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_DISABLE)
	e5:SetValue(1000)
	c:RegisterEffect(e5)
end
function cm.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x351,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x351,1,REASON_COST)
end
function cm.rfilter(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove()
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.bombop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_IMMUNE_EFFECT)
		e6:SetValue(cm.efilter)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e6)
	end
end
function cm.fbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x352,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x352,4,REASON_COST)
end
function cm.fbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(cm.efilter1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		c:RegisterEffect(e4)
	end
	if c:GetFlagEffect(m)>0 then
		local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_MZONE,nil,e)
		Duel.Destroy(g,REASON_EFFECT)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
end
function cm.desfilter(c,e)
	return e:GetHandler():GetAttack()>=c:GetAttack() and c:IsFaceup()
end
function cm.efilter1(e,te)
	return te:GetHandler()~=e:GetHandler()
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(m,7))
end
