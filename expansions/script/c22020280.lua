--人理之基 库丘林·德鲁伊
function c22020280.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(22020280,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22020280)
	e1:SetTarget(c22020280.thtg)
	e1:SetOperation(c22020280.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--material
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(22020280,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,12020281)
	e2:SetCost(c22020280.matcost)
	e2:SetTarget(c22020280.mattg)
	e2:SetOperation(c22020280.matop)
	c:RegisterEffect(e2)
end
function c22020280.thfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22020280.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020280.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22020280.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22020280.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22020280.matcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReleasable() end 
	Duel.Release(e:GetHandler(),REASON_COST)
end 
function c22020280.matfilter2(c)
	return c:IsCanOverlay() and c:IsSetCard(0xff1)
end
function c22020280.matfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6ff1) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c22020280.matfilter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
end
function c22020280.mattg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c22020280.matfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22020280.matfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c22020280.matop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22020280.matfilter2),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,2,nil,tc)
		if #g>0 then
			Duel.Overlay(tc,g)
		end
	end
end



