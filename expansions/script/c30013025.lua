--深土之下
local m=30013025
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FLIP))
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(cm.rmlimit)
	c:RegisterEffect(e4)  
	--Effect 2
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_CHAINING)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCountLimit(1,m)
	e12:SetCondition(cm.discon)
	e12:SetCost(cm.discost)
	e12:SetTarget(cm.distg)
	e12:SetOperation(cm.disop)
	c:RegisterEffect(e12)
end
--Effect 1
function cm.ft(c)
	return c:IsType(TYPE_FLIP) 
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.val(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(cm.ft,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetCode)*300
end
function cm.rmlimit(e,c) 
	local ec=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local b1=c:IsLocation(LOCATION_ONFIELD) and (c:IsFacedown() or (c:IsSetCard(0x92c) or c:IsType(TYPE_FLIP)))
	local b2=c:GetLocation()~=LOCATION_ONFIELD and (c:IsSetCard(0x92c) or c:IsType(TYPE_FLIP))
	return c:IsControler(tp) and (c==ec or (b1 or b2))
end
--Effect 2
--Effect 3
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or ev<2 then return false end
	local re2,rp2=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return rp~=tp and ev>=2 and rp2==tp and (re2:GetHandler():IsSetCard(0x92c) or re2:IsActiveType(TYPE_FLIP)) and Duel.IsChainDisablable(ev)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) 
		and Duel.IsExistingMatchingCard(cm.chan,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,cm.chan,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			local pos1=0
			if tc:IsCanTurnSet() then pos1=pos1+POS_FACEDOWN_DEFENSE end
			if not tc:IsPosition(POS_FACEUP_DEFENSE) then pos1=pos1+POS_FACEUP_DEFENSE end
			local pos2=Duel.SelectPosition(tp,tc,pos1)
			Duel.ChangePosition(tc,pos2)
		end
	end
end
function cm.chan(c)
	return  c:IsCanTurnSet() or c:IsCanChangePosition()
end
