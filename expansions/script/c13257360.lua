--超时空战斗机-斑鸠
local m=13257360
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	c:EnableCounterPermit(0x352)
	c:SetCounterLimit(0x352,10)
	c:EnableReviveLimit()
	--cannot special summon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e8)
	--special summon
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_HAND)
	e9:SetCondition(cm.spcon)
	e9:SetOperation(cm.spop)
	c:RegisterEffect(e9)
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
	e1:SetCountLimit(1)
	e1:SetCondition(cm.accon)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetTarget(cm.pctg)
	e3:SetOperation(cm.pcop)
	c:RegisterEffect(e3)
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(cm.bombcost)
	e4:SetTarget(cm.bombtg)
	e4:SetOperation(cm.bombop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetOperation(cm.bgmop)
	c:RegisterEffect(e11)
	
end
function cm.spfilter(c,ft,tp)
	return c:IsSetCard(0x351)
		and c:IsControler(tp) and c:IsAbleToDeckAsCost and (ft>0 or c:GetSequence()<5)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil,ft,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft,tp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.efilter(e,te)
	local c=e:GetHandler()
	return ((c:IsAttribute(ATTRIBUTE_LIGHT) and te:IsActiveType(TYPE_MONSTER)) or (c:IsAttribute(ATTRIBUTE_DARK) and te:IsActiveType(TYPE_SPELL+TYPE_TRAP))) and e:GetHandlerPlayer()~=te:GetOwnerPlayer()
end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(1)>0 and ((c:IsAttribute(ATTRIBUTE_LIGHT) and re:IsActiveType(TYPE_MONSTER)) or (c:IsAttribute(ATTRIBUTE_DARK) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)))
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x352,1)
	end
end
function cm.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==tp end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,0x30)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetValue(att)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e5)
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UPDATE_ATTACK)
		e6:SetValue(-300)
		e6:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e6)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e7)
	end
end
function cm.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x352)>0 end
	local ct=e:GetHandler():GetCounter(0x352)
	e:SetLabel(ct)
	e:GetHandler():RemoveCounter(tp,0x352,ct,REASON_COST)
end
function cm.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.bombop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(m,7))
end
