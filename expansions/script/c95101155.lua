--溟海之神 神之异鱼
function c95101155.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c95101155.mfilter,5,2,nil,nil,99)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95101155,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,95101155)
	e4:SetCondition(c95101155.condition)
	e4:SetCost(c95101155.cost)
	e4:SetTarget(c95101155.thtg)
	e4:SetOperation(c95101155.thop)
	e4:SetLabel(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(95101155,1))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e5:SetCountLimit(1,95101155+1)
	e5:SetLabel(2)
	e5:SetTarget(c95101155.atktg)
	e5:SetOperation(c95101155.atkop)
	c:RegisterEffect(e5)
end
function c95101155.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c95101155.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2--Duel.IsMainPhase()
end
function c95101155.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c95101155.thfilter(c,chk)
	return c:IsSetCard(0xbbf) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c95101155.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101155.thfilter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95101155.ofilter(c,e)
	return c:IsSetCard(0xbbf) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e)) and aux.NecroValleyFilter()(c)
end
function c95101155.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c95101155.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) then return end
		Duel.ConfirmCards(1-tp,tc)
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(c95101155.ofilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e)
		if c:IsType(TYPE_XYZ) and c:IsRelateToEffect(e) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(95101155,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local xc=g:Select(tp,1,1,nil):GetFirst()
			Duel.Overlay(c,xc)
		end
	end
end
function c95101155.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler()):GetSum(Card.GetBaseAttack)>0 end
end
function c95101155.mgfilter(c)
	return c:IsSetCard(0xbbf) and c:IsType(TYPE_MONSTER)
end
function c95101155.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c):GetSum(Card.GetBaseAttack)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
		local mg=c:GetOverlayGroup()
		if mg:IsExists(c95101155.mgfilter,1,nil) then
			local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
			if #g>0 then Duel.BreakEffect() end
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c95101155.ftarget)
	e0:SetLabel(c:GetFieldID())
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function c95101155.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
