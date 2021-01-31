--方舟骑士·梓兰
function c29065578.initial_effect(c)
	c:EnableCounterPermit(0x87ae)
	--to deck to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065578,2)) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19065578)
	e2:SetTarget(c29065578.tttg)
	e2:SetOperation(c29065578.ttop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065578.summon_effect=e2
	--tohand	
	local e4=Effect.CreateEffect(c)   
	e4:SetDescription(aux.Stringid(9065578,3))  
	e4:SetCategory(CATEGORY_COUNTER)	
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)	
	e4:SetProperty(EFFECT_FLAG_DELAY)   
	e4:SetCode(EVENT_TO_GRAVE)  
	e4:SetCountLimit(1,09065578) 
	e4:SetCondition(c29065578.thcon)	
	e4:SetTarget(c29065578.thtg)	
	e4:SetOperation(c29065578.thop)  
	c:RegisterEffect(e4)	
	local e5=e4:Clone()  
	e5:SetCode(EVENT_TO_HAND)   
	c:RegisterEffect(e5)	
end
function c29065578.tdfil(c)
	return c:IsSetCard(0x87af) and c:IsAbleToDeck()
end
function c29065578.thfil(c)
	return c:IsSetCard(0x87af) and c:IsAbleToHand()
end
function c29065578.tttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065578.tdfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c29065578.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end
function c29065578.ttop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c29065578.tdfil,tp,LOCATION_GRAVE,0,1,99,nil)
	if g:GetCount()>0 then
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	local hg=Duel.GetMatchingGroup(c29065578.thfil,tp,LOCATION_DECK,0,nil)
	if hg:GetCount()>0 then
	tc=hg:RandomSelect(tp,1):GetFirst()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	end
end
function c29065578.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c29065578.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsCanAddCounter(0x87ae,1)
end 
function c29065578.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(c29065578.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end 
end
function c29065578.thop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) 
	local tc=Duel.SelectMatchingCard(tp,c29065578.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()	
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x87ae,n)
end





















