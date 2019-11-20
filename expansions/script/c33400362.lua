--夜刀神-娇羞美人
function c33400362.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400362+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c33400362.cost)
	e1:SetTarget(c33400362.target)
	e1:SetOperation(c33400362.activate)
	c:RegisterEffect(e1)
   --to hand from Remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCountLimit(1,33400362)
	e2:SetTarget(c33400362.adtg)
	e2:SetOperation(c33400362.adop)
	c:RegisterEffect(e2)
end
function c33400362.filter(c)
	return  c:IsReleasableByEffect()
end
function c33400362.thfilter(c)
	return  c:IsSetCard(0x5341)
end
function c33400362.thfilter2(c)
	return  c:IsSetCard(0x3343) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c33400362.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400362.filter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c33400362.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c33400362.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400362.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33400362.activate(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33400362.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c33400362.thfilter2,tp,LOCATION_DECK,0,1,nil) then 
		   if Duel.SelectYesNo(tp,aux.Stringid(33400362,0)) then 
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			   local tg=Duel.SelectMatchingCard(tp,c33400362.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
			   Duel.SendtoGrave(tg,REASON_EFFECT)
		   end
		end  
	end
end

function c33400362.thfilter3(c)
	return  c:IsAbleToHand() and c:IsSetCard(0x5341) and c:IsType(TYPE_MONSTER)
end
function c33400362.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400362.thfilter3,tp,LOCATION_REMOVED,0,1,nil) 
	 and e:GetHandler():IsAbleToDeck()   end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c33400362.adop(e,tp,eg,ep,ev,re,r,rp)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33400362.thfilter3),tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then   
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end   
end