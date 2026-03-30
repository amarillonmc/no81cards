--魔术悠悠
local m=79630030
local set=0x183
local YUU=27288416
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL),1,2,nil,nil,99)
	c:EnableReviveLimit()
	--code
	aux.EnableChangeCode(c,YUU,LOCATION_ONFIELD+LOCATION_GRAVE)
	--code G
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.codecon)
	e1:SetTarget(cm.codetg)
	e1:SetOperation(cm.codeop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.negcon)
	e2:SetCost(cm.negcost)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
	--遗言
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,4))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.leavecon)
	e5:SetTarget(cm.leavetg)
	e5:SetOperation(cm.leaveop)
	c:RegisterEffect(e5)
end
--code G
function cm.ovfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_NORMAL)
end
function cm.codecon(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	return og and og:IsExists(cm.ovfilter,1,nil)
end
function cm.codefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsCode(YUU)
end
function cm.codetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.codefilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
end
function cm.codeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.codefilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(YUU)
		tc:RegisterEffect(e1)
	end
end
--negate
function cm.xyzfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_NORMAL)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(cm.xyzfilter,1,nil)
		and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP))
		and Duel.IsChainNegatable(ev)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToChangeControler() and re:GetHandler():IsCanTurnSet() then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) then
		if tc:IsRelateToEffect(re) and tc:IsAbleToChangeControler() and (tc:IsLocation(LOCATION_REMOVED) or tc:IsLocation(LOCATION_GRAVE) or tc:IsLocation(LOCATION_ONFIELD)) then
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN)
			if Duel.SSet(tp,tc)~=0 then
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
--遗言
function cm.ovfilter2(c)
	return c:IsType(TYPE_NORMAL)
end
function cm.leavecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_MZONE) then return false end
	local byopp=false
	if (r&REASON_EFFECT)~=0 and re and re:GetHandler():IsControler(1-tp) then
		byopp=true
	end
	if (r&REASON_BATTLE)~=0 and c:GetReasonPlayer()==1-tp then
		byopp=true
	end
	if not byopp then return false end
	local og=c:GetOverlayGroup()
	return og and og:IsExists(cm.ovfilter2,1,nil)
end
function cm.deckfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER)
	and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.leavetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.deckfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.leaveop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.deckfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end