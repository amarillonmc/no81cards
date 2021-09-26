--幻影旅团·7 富兰克林
local m=45746007
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,45746031)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsDiscardable() end
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local tg=Duel.GetFirstMatchingCard(cm.filter,tp,LOCATION_DECK,0,nil)
		if tg then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():IsFaceup()
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local tg=Duel.GetFirstMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,nil)
		if tg then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetOriginalRace()==RACE_PSYCHO
	end)
	c:RegisterEffect(e4)
end
function cm.filter(c)
	return c:IsCode(45746031) and c:IsAbleToHand()
end