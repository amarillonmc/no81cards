--动感战车 小壶号
function c9320002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c9320002.imcon)
	e1:SetValue(c9320002.efilter)
	c:RegisterEffect(e1)
	--Attach
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c9320002.xyzcon)
	e2:SetTarget(c9320002.xyztg)
	e2:SetOperation(c9320002.xyzop)
	c:RegisterEffect(e2)
	--3
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c9320002.cost)
	e3:SetTarget(c9320002.target)
	e3:SetOperation(c9320002.operation)
	c:RegisterEffect(e3)
end
function c9320002.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c9320002.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner() 
		   and te:GetHandler():IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_FIRE)
end
function c9320002.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() then return false end
	e:SetLabelObject(tc)
	return tc and tc:IsType(TYPE_MONSTER) and tc:GetPreviousAttributeOnField()&ATTRIBUTE_WATER~=0
			and tc:IsReason(REASON_BATTLE) and tc:IsCanOverlay()
end
function c9320002.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c9320002.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,tc)
	end
end
function c9320002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9320002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,c)
end
function c9320002.cfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c9320002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9320002.cfilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		if tc:IsAttribute(ATTRIBUTE_EARTH) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_PLANT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if tc:IsAttribute(ATTRIBUTE_FIRE) then
		   Duel.Destroy(tc,REASON_EFFECT)
		end
		if tc:IsAttribute(ATTRIBUTE_WATER) and not tc:IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,Group.FromCards(tc))
		end
		tc=g:GetNext()
	end
end