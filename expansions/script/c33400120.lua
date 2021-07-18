--刻刻帝 暗影之壁
local m=33400120
local cm=_G["c"..m]
function cm.initial_effect(c)
 c:EnableCounterPermit(0x34f)
	 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
 --immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3340))
	e2:SetCondition(cm.scon)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
--Add counter2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_LEAVE_FIELD_P)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(cm.addop2)
	c:RegisterEffect(e6)
--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.desreptg)
	e1:SetValue(cm.desrepval)
	e1:SetOperation(cm.desrepop)
	c:RegisterEffect(e1)
end
function cm.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3341) 
end
function cm.scon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() 
end

function cm.addop2(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	local c=eg:GetFirst()
	while c~=nil do
		if c~=e:GetHandler() and c:IsLocation(LOCATION_ONFIELD)  then
			count=count+c:GetCounter(0x34f)
		end
		c=eg:GetNext()
	end
	if count>0 then
		e:GetHandler():AddCounter(0x34f,count)
	end
end

function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x3341) and c:IsType(TYPE_MONSTER)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0)) then
		return true
	end
	return false
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST)
end