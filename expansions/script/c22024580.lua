--人理之基 武田晴信
function c22024580.initial_effect(c)
	c:SetSPSummonOnce(22024580)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22024580.spcon)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(22024580,ACTIVITY_CHAIN,c22024580.chainfilter)
	--effect count
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c22024580.scount)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c22024580.econ1)
	e3:SetValue(c22024580.elimit)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22024580,0))
	e4:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c22024580.drcon)
	e4:SetTarget(c22024580.drtg)
	e4:SetOperation(c22024580.drop)
	c:RegisterEffect(e4)
	--draw ere
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22024580,1))
	e5:SetCategory(CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCondition(c22024580.erecon)
	e5:SetCost(c22024580.erecost)
	e5:SetTarget(c22024580.drtg)
	e5:SetOperation(c22024580.drop)
	c:RegisterEffect(e5)
end
function c22024580.chainfilter(re,tp,cid)
	if re:IsActiveType(TYPE_MONSTER) then
		Duel.RegisterFlagEffect(1-tp,22024580,RESET_PHASE+PHASE_END,0,1)
	end
	return not re:IsActiveType(TYPE_MONSTER)
end
function c22024580.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,22024580)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c22024580.scount(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(22024571,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c22024580.econ1(e)
	return e:GetHandler():GetFlagEffect(22024571)~=0
end
function c22024580.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c22024580.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_MONSTER)
end
function c22024580.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
end
function c22024580.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
	local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)
end
function c22024580.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980) and rp==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c22024580.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end