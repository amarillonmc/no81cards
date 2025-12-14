--天觉龙 汀恩
local s,id=GetID()
s.named_with_AwakenedDragon=1
function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end
function s.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,s.matfilter,3,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)  
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
end

function s.matfilter(c)
	return s.AwakenedDragon(c)
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.thfilter(c)
	if not (c:IsCode(40020256) or s.AwakenedDragon(c)) then
		return false
	end
	local can_hand  = c:IsAbleToHand()
	local can_extra = c:IsType(TYPE_PENDULUM) 
	return can_hand or can_extra
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.HintSelection(g)
	local can_hand  = tc:IsAbleToHand()
	local can_extra = tc:IsType(TYPE_PENDULUM) and tc:IsAbleToExtra()
	if not (can_hand or can_extra) then
		return
	end
	local op
	if can_hand and can_extra then
		op = Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif can_hand then
		op = 0
	else
		op = 1
	end

	if op==0 then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
	end
end
function s.atkval(e,c)
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_EXTRA,0,nil)
	return ct*300
end
