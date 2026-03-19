--被遗忘的研究 夏露贝塔I形解放
function c43480035.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c43480035.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,43480035) 
	e1:SetCost(c43480035.thcost)
	e1:SetTarget(c43480035.thtg)
	e1:SetOperation(c43480035.thop)
	c:RegisterEffect(e1)
	--Special Summon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,43480036)
	e2:SetCondition(c43480035.spcon)
	e2:SetTarget(c43480035.sptg)
	e2:SetOperation(c43480035.spop) 
	c:RegisterEffect(e2)
end
function c43480035.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3f13)
end
function c43480035.pbfil(c) 
	return not c:IsPublic() and c:IsSetCard(0x3f13)  
end 
function c43480035.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.IsPlayerAffectedByEffect(tp,43480080) then 
		return true 
		else return Duel.IsExistingMatchingCard(c43480035.pbfil,tp,LOCATION_HAND,0,1,nil)
		end
	end
	if not Duel.IsPlayerAffectedByEffect(tp,43480080) then
		local pg=Duel.SelectMatchingCard(tp,c43480035.pbfil,tp,LOCATION_HAND,0,1,1,nil) 
		Duel.ConfirmCards(1-tp,pg) 
	end
end
function c43480035.thfilter(c)
	return c:IsCode(43480070) and c:IsAbleToHand()
end
function c43480035.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43480035.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c43480035.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c43480035.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c43480035.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 
end
function c43480035.spfilter(c,e,tp)
	return c:IsCode(4348030) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43480035.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c43480035.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c43480035.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43480035.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end
end





