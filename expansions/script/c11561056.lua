--枪鸣★交响 美空
local m=11561056
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11561056.mfilter,c11561056.xyzcheck,2,99)
	--cou
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11561056)
	e1:SetCondition(c11561056.cdtcon)
	e1:SetTarget(c11561056.cdttg)
	e1:SetOperation(c11561056.cdtop)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11561056.descon)
	e2:SetCost(c11561056.wxcost)
	e2:SetTarget(c11561056.destg)
	e2:SetOperation(c11561056.desop)
	c:RegisterEffect(e2)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11561056.remcon)
	e3:SetCost(c11561056.wxcost)
	e3:SetTarget(c11561056.remtg)
	e3:SetOperation(c11561056.remop)
	c:RegisterEffect(e3)
	--sida
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c11561056.discon)
	e4:SetCost(c11561056.wxcost)
	e4:SetTarget(c11561056.distg)
	e4:SetOperation(c11561056.disop)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c11561056.wxcost)
	e5:SetOperation(c11561056.wxop)
	--c:RegisterEffect(e5)
	--move
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CUSTOM+11561056)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c11561056.movcon)
	e6:SetOperation(c11561056.movop)
	--c:RegisterEffect(e6)
	
end
function c11561056.movcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(11591056)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c11561056.movop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(11561056,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq) end
end


function c11561056.wxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1,1,REASON_COST)
end
function c11561056.wxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--disable 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c11561056.distg2)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1) 
	c:RegisterFlagEffect(11591056,RESET_PHASE+PHASE_END,0,2)
end
function c11561056.distg2(e,c)
	return (c:IsType(TYPE_MONSTER+TYPE_EFFECT) or c:IsType(TYPE_TRAP+TYPE_SPELL)) and e:GetHandler():GetColumnGroup():IsContains(c) 
end
function c11561056.discon(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsLocation(0x16) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c11561056.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(11581056)==0 end
	e:GetHandler():RegisterFlagEffect(11581056,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11581056,3))
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	--Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+11561056,e,0,0,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c11561056.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) 
	end
end
function c11561056.remcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsLocation(0x12) and re:IsActiveType(TYPE_MONSTER)
end
function c11561056.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(11571056)==0 and eg:GetFirst():IsAbleToRemove() end
	e:GetHandler():RegisterFlagEffect(11571056,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11581056,1))
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	--Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+11561056,e,0,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
function c11561056.remop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.NegateEffect(ev)
	end
end
function c11561056.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
end
function c11561056.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(11561056)==0 end
	e:GetHandler():RegisterFlagEffect(11561056,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11581056,2))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	--Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+11561056,e,0,0,0,0)
end
function c11561056.desop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c11561056.mfilter(c)
	return c:IsLevel(6)
end
function c11561056.xyzcheck(g)
	return g:GetClassCount(Card.GetRace)==1
end
function c11561056.cdtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c11561056.cdttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return c:GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x1)
end
function c11561056.cdtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	if c:IsRelateToEffect(e) then
		local og=c:GetOverlayGroup()
		if og:GetCount()==0 then return end
		local ct=Duel.SendtoGrave(og,REASON_EFFECT) 
		if ct>0 then
		c:AddCounter(0x1,ct)
		end
	end
end
