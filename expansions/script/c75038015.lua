--腕装合体 修罗霍普雷
function c75038015.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,3,c75038015.ovfilter,aux.Stringid(75038015,1))   
	--attackall
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCost(c75038015.sthcost)
	e1:SetTarget(c75038015.sthtg)
	e1:SetOperation(c75038015.sthop)
	c:RegisterEffect(e1)
end 
function c75038015.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f) and c:IsRank(4) 
end
function c75038015.sthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 
function c75038015.thfilter(c)
	return c:IsSetCard(0x107e) and c:IsAbleToHand()
end
function c75038015.spfil(c,e,tp)
	return c:IsSetCard(0x107e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75038015.sthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(c75038015.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c75038015.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	if chk==0 then return b1 or b2 end 
end
function c75038015.sthop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c75038015.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c75038015.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	if b1 or b2 then 
	local op=aux.SelectFromOptions(tp,{b1,1190},{b2,1152})
		if op==1 then
			local sg=Duel.SelectMatchingCard(tp,c75038015.thfilter,tp,LOCATION_DECK,0,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end
		if op==2 then
			local sg=Duel.SelectMatchingCard(tp,c75038015.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end 
	end
end




