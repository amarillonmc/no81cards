--虚拟YouTuber 野良猫 II
local m=33700359
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,m)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.hdcon)
	e3:SetCost(cm.hdcost)
	e3:SetTarget(cm.hdtg)
	e3:SetOperation(cm.hdop)
	c:RegisterEffect(e3)
	--asd
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.hdcon2)
	e4:SetTarget(cm.hdtg2)
	e4:SetOperation(cm.hdop2)
	c:RegisterEffect(e4)
end
function cm.hdcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return #eg==1 and rp==tp and tc:IsControler(tp) and tc:IsPreviousLocation(LOCATION_DECK)
end
function cm.hdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	Duel.SetTargetCard(eg)
end
function cm.hdop2(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if not tc:IsRelateToEffect(e) then return end   
	if not c:IsRelateToEffect(e) then return end
	if not c:IsType(TYPE_XYZ) then return end
	Duel.Overlay(c,Group.FromCards(tc))
end
function cm.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,re) and #eg==1
end
function cm.cfilter(c,re)
	if c:IsReason(REASON_DRAW) then return false end
	if re and re:GetHandler():IsCode(m) then return false end
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsAbleToDeck()
end
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)<=0 then return end
	Duel.BreakEffect()
	local p=tc:GetOwner()
	local ctype=TYPE_SPELL 
	if tc:IsType(TYPE_MONSTER) then ctype=TYPE_MONSTER end
	if tc:IsType(TYPE_TRAP) then ctype=TYPE_TRAP end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(p,cm.thfilter,p,LOCATION_DECK,0,1,1,nil,ctype)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,g)
	end
end
function cm.thfilter(c,ctype)
	return c:IsType(ctype) and c:IsAbleToHand()
end

