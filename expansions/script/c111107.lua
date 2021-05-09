--アクセスコード・トーカー 
function c111107.initial_effect(c)
	--link summon  
c:EnableReviveLimit() 		
--link summon
aux.AddLinkProcedure(c,nil,2,2,c111107.lcheck)
--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111107,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
 e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCountLimit(1,011107) 	
	e1:SetCondition(c111107.thcon)
	e1:SetTarget(c111107.thtg)
	e1:SetOperation(c111107.thop)
	c:RegisterEffect(e1)
	--to hand 	
local e4=Effect.CreateEffect(c) 
e4:SetDescription(aux.Stringid(111107,0)) 
e4:SetCategory(CATEGORY_TOGRAVE) 	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 	e4:SetCode(EVENT_SPSUMMON_SUCCESS) 	
e4:SetProperty(EFFECT_FLAG_DELAY) 	
e4:SetCountLimit(1,011107) 	
e4:SetRange(LOCATION_MZONE) 	
e4:SetCondition(c111107.tgcon) 		
e4:SetTarget(c111107.tgtg) 	
e4:SetOperation(c111107.tgop) 	
c:RegisterEffect(e4)
end
function c111107.lcheck(g)
	return g:IsExists(Card.IsRace,1,nil,RACE_PSYCHO)
end
function c111107.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c111107.thfilter(c)
	return c:IsSetCard(0xf36) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c111107.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111107.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111107.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c111107.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:Select(1-tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c111107.thcfilter(c,ec) 
	if c:IsLocation(LOCATION_MZONE) then 		
return ec:GetLinkedGroup():IsContains(c) and c:IsRace(RACE_PSYCHO)
else 		
return bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0 and c:IsRace(RACE_PSYCHO)
end 
end 
function c111107.tgcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 	
return not eg:IsContains(c) and eg:IsExists(c111107.thcfilter,1,nil,c) 
end 
function c111107.tgfilter(c) 	
return c:IsRace(RACE_PSYCHO) and  c:IsAbleToGrave() 
end 
function c111107.tgtg(e,tp,eg,ep,ev,re,r,rp,chk) 	
if chk==0 then return Duel.IsExistingMatchingCard(c111107.tgfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end 	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED) 
end 
function c111107.tgop(e,tp,eg,ep,ev,re,r,rp) 	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) 
	local g=Duel.SelectMatchingCard(tp,c111107.tgfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil) 	
if g:GetCount()>0 then 		
Duel.SendtoGrave(g,REASON_EFFECT) 		
 	end 
end