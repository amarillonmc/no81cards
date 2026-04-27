--阔帕大日
--大日立方体
local m=98920870
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,2,nil,nil,99)
	c:EnableReviveLimit()
	
	--Effect 1: Equip from deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.eqcon)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)

	--Effect 2: Negate and Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DISABLE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.negcon)
	e2:SetCost(cm.negcost)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end

--Effect 1 Functions
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.eqfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct>ft then ct=ft end
	if ct<=0 or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_DECK,0,1,ct,nil)
	if g:GetCount()>0 then
		for tc in aux.Next(g) do
			if Duel.Equip(tp,tc,c,true,true) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.eqlimit)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetValue(500)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e3)
			end
		end
		Duel.EquipComplete()
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end

--Effect 2 Functions
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsLocation(LOCATION_MZONE) then
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		if Duel.NegateEffect(ev) then
			local rc=re:GetHandler()
			--If the negated monster is on the field, equip it
			if rc:IsRelateToEffect(re) and rc:IsLocation(LOCATION_MZONE) and not rc:IsImmuneToEffect(e) then
				if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
					Duel.BreakEffect()
					if Duel.Equip(tp,rc,c,true) then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_EQUIP_LIMIT)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						e1:SetValue(cm.eqlimit)
						rc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_EQUIP)
						e2:SetCode(EFFECT_UPDATE_ATTACK)
						e2:SetValue(1000)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						rc:RegisterEffect(e2)
						local e3=e2:Clone()
						e3:SetCode(EFFECT_UPDATE_DEFENSE)
						rc:RegisterEffect(e3)
					end
				end
			end
		end
	end
end