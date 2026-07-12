--水晶替身
function c75038006.initial_effect(c)
	aux.AddCodeList(c,89631139,21082832) 
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,75038006)
	e1:SetCondition(c75038006.spscon1)
	e1:SetTarget(c75038006.spstg)
	e1:SetOperation(c75038006.spsop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75038006)
	e1:SetCondition(c75038006.spscon2)
	e1:SetTarget(c75038006.spstg)
	e1:SetOperation(c75038006.spsop)
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e2:SetCountLimit(1,75038007)
	e2:SetCondition(c75038006.spcon)
	e2:SetTarget(c75038006.sptg)
	e2:SetOperation(c75038006.spop)
	c:RegisterEffect(e2)
end
function c75038006.spscon1(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(1-tp) 
end 
function c75038006.spscon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsCode(89631139) and c:IsFaceup() end,tp,LOCATION_MZONE,0,1,nil) 
end
function c75038006.thfil1(c) 
	return c:IsAbleToHand() and c:IsCode(21082832)  
end 
function c75038006.thfil2(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_DRAGON) and c:IsSetCard(0xcf)
end 
function c75038006.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c75038006.thfil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c75038006.thfil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end 
function c75038006.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c75038006.thfil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c75038006.thfil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.BreakEffect()
		local sg1=Duel.SelectMatchingCard(tp,c75038006.thfil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local sg2=Duel.SelectMatchingCard(tp,c75038006.thfil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
		sg1:Merge(sg2) 
		Duel.SendtoHand(sg1,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg1) 
	end
end
function c75038006.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) 
end 
function c75038006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)  
end 
function c75038006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)~=0 then 
		local at=Duel.GetAttacker()
		if at and at:IsAttackable() and at:IsFaceup() and not at:IsImmuneToEffect(e) and not at:IsStatus(STATUS_ATTACK_CANCELED) then
			Duel.BreakEffect()
			Duel.ChangeAttackTarget(c)
		end
	end 
end 

