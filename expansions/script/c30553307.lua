--辉刻调停者 满刻
local m=30553307
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,12,3,cm.ovfilter,aux.Stringid(m,0))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cos1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
end
--xyz
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x308) and  (c:IsLevelAbove(12) or (c:GetType()&TYPE_XYZ==TYPE_XYZ and c:IsRankAbove(12)))
end
--e1
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetRank()>4 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRankAbove(4) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_RANK)
	e1:SetValue(-4)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(cm.op1val)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e2:SetOwnerPlayer(tp)
	c:RegisterEffect(e2)
end
function cm.op1val(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
--e2
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetRank()>1 and re:GetHandler():GetControler()~=tp then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_RANK)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
end
--e3
function cm.val3(e,re,tp)
	local st=e:GetHandler():GetRank()
	local rc=re:GetHandler()
	local b1=rc:IsType(TYPE_XYZ) and rc:IsRankAbove(st)
	local b2=rc:IsType(TYPE_LINK) and rc:IsLinkAbove(st)
	local b3=not rc:IsType(TYPE_XYZ+TYPE_LINK) and rc:IsLevelAbove(st)
	return re:IsActiveType(TYPE_MONSTER) and (b1 or b1 or b3)
end