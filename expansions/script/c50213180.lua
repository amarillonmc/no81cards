--Kamipro 爱迪生
function c50213180.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c50213180.xcheck,6,2,c50213180.ovfilter,aux.Stringid(50213180,0),2,c50213180.xyzop)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_ALL-ATTRIBUTE_DIVINE-ATTRIBUTE_LIGHT)
	e1:SetCondition(c50213180.attcon)
	c:RegisterEffect(e1)
	--battle indes
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e11:SetCondition(c50213180.attcon)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCode(EVENT_CHAIN_SOLVED)
	e22:SetCondition(c50213180.atkcon)
	e22:SetOperation(c50213180.atkop)
	c:RegisterEffect(e22)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,50213180)
	e3:SetCost(c50213180.thcost)
	e3:SetTarget(c50213180.thtg)
	e3:SetOperation(c50213180.thop)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c50213180.ctcon)
	e4:SetTarget(c50213180.cttg)
	e4:SetOperation(c50213180.ctop)
	c:RegisterEffect(e4)
end
function c50213180.xcheck(c)
	return c:IsSetCard(0xcbf)
end
function c50213180.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf) and c:IsRank(4)
end
function c50213180.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,50213180)==0 end
	Duel.RegisterFlagEffect(tp,50213180,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c50213180.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()>0
end
function c50213180.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
function c50213180.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf)
end
function c50213180.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rp==tp and c:GetFlagEffect(1)>0 then
		local g=Duel.GetMatchingGroup(c50213180.cfilter,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
			tc=g:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(200)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)
				tc=g:GetNext()
			end
		end
	end
end
function c50213180.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50213180.thfilter(c)
	return c:IsSetCard(0xcbf) and c:IsAbleToHand()
end
function c50213180.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50213180.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50213180.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50213180.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c50213180.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c50213180.afilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0xcbf,3)
end
function c50213180.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50213180.afilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c50213180.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c50213180.afilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0xcbf,3)
		tc=g:GetNext()
	end
end