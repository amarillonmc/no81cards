--Lily White ～夏祭～
local CTR_PETAL = 0x234
function c33711113.initial_effect(c)
	c:EnableCounterPermit(CTR_PETAL)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,7,c33711113.ovfilter,aux.Stringid(33711113,0),7)
	c:EnableReviveLimit() 
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33711113,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c33711113.atkcon)
	e1:SetOperation(c33711113.atkop)
	c:RegisterEffect(e1)
	--ADD COUNTER
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33711113,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33711113)
	e2:SetCost(c33711113.bmcost)
	e2:SetTarget(c33711113.bmtg)
	e2:SetOperation(c33711113.bmop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c33711113.desreptg)
	e3:SetValue(c33711113.desrepval)
	e3:SetOperation(c33711113.desrepop)
	c:RegisterEffect(e3)
	--To Pzone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33711113,4))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(c33711113.topcost)
	e4:SetTarget(c33711113.toptarget)
	e4:SetOperation(c33711113.topop)
	c:RegisterEffect(e4)
	--changeDam
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(0)
	c:RegisterEffect(e5) 
	--Effect Draw
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DRAW_COUNT)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<Duel.GetLocationCount(tp,0,LOCATION_ONFIELD)
	end)
	e6:SetTargetRange(1,0)
	e6:SetValue(2)
	c:RegisterEffect(e6)
end
function c33711113.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and (c:IsLevelAbove(10) or (c:IsLevelBelow(4) and Duel.IsExistingMatchingCard(Card.IsType,c:GetControler(),LOCATION_ONFIELD,0,1,nil,TYPE_TOKEN)))
end
function c33711113.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33711113.atkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(CTR_PETAL,2)
	end
end
function c33711113.bmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local sum=e:GetHandler():GetOverlayGroup():GetCount()
	if chk==0 then return e:GetHandler():GetOverlayCount()>0
		and e:GetHandler():CheckRemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),e:GetHandler():GetOverlayCount(),REASON_COST)
	local sum1=e:GetHandler():GetOverlayGroup():GetCount()
	e:SetLabel(sum-sum1)
end
function c33711113.bmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Deul.IsCanAddCounter(tp,CTR_PETAL,1,e:GetHandler()) end
end
function c33711113.bmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsType(TYPE_XYZ) then return end
	e:GetHandler():AddCounter(CTR_PETAL,e:GetLabel())
end
function c33711113.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c33711113.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c33711113.repfilter,1,nil,tp)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,CTR_PETAL,1,REASON_EFFECT+REASON_REPLACE) end
	e:SetLabel(eg:GetCount()) 
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c33711113.desrepval(e,c)
	return c33711113.repfilter(c,e:GetHandlerPlayer())
end
function c33711113.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,CTR_PETAL,1,REASON_EFFECT+REASON_REPLACE)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local sg=g:RandomSelect(tp,e:GetLabel())
	Duel.Destroy(sg,REASON_EFFECT+REASON_REPLACE)
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetLabelObject(sg)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetCurrentPhase())
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c33711113.retcon2)
		e1:SetOperation(c33711113.retop2)
		Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_CARD,0,33711113)
end
function c33711113.retcon2(e,tp)
	return Duel.GetCurrentPhase()~=e:GetLabel()
end
function c33711113.retop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),tp,REASON_EFFECT+REASON_RETURN)
end
function c33711113.topcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,CTR_PETAL,1,REASON_COST)  end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,CTR_PETAL,1,REASON_COST)
end
function c33711113.toptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c33711113.topop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end