--优雅修炼·露
local m=11561066
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	aux.AddXyzProcedureLevelFree(c,c11561066.mfilter,c11561066.xyzcheck,2,99)
	c:EnableReviveLimit()
	--cou
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11561066)
	e1:SetCondition(c11561066.cdtcon)
	e1:SetTarget(c11561066.cdttg)
	e1:SetOperation(c11561066.cdtop)
	c:RegisterEffect(e1) 
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c11561066.atkval)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11560066)
	e3:SetTarget(c11561066.zmtg)
	e3:SetOperation(c11561066.zmop)
	c:RegisterEffect(e3)
end
function c11561066.atkval(e,c)
	return Duel.GetCounter(c:GetControler(),1,1,0x1)*500
end
function c11561066.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
end
function c11561066.sfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c11561066.zmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561066.mfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) or Duel.IsExistingMatchingCard(c11561066.sfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
end
function c11561066.zmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c11561066.mfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c11561066.sfilter),tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(tc)
	e1:SetCondition(c11561066.condition)
	e1:SetOperation(c11561066.operation)
	Duel.RegisterEffect(e1,tp)
end
function c11561066.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsRelateToEffect(e)
end
function c11561066.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c11561066.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c11561066.discon)
		e2:SetOperation(c11561066.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE) 
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		e1:SetOperation(function(e) 
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c11561066.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c11561066.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c11561066.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

function c11561066.mfilter(c)
	return c:IsLevel(1)
end
function c11561066.xyzcheck(g)
	return g:GetClassCount(Card.GetLinkCode)==1
end
function c11561066.cdtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c11561066.cdttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return c:GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,ct*2)
end
function c11561066.cdtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local og=c:GetOverlayGroup()
		if og:GetCount()==0 then return end
		local ct=Duel.SendtoGrave(og,REASON_EFFECT) 
		if ct>0 then
		c:AddCounter(0x1,ct)
		Duel.DiscardDeck(tp,ct*2,REASON_EFFECT)
		Duel.DiscardDeck(1-tp,ct*2,REASON_EFFECT)
		end
	end
end


