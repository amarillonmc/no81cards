--幻梦迷境 羽菜
function c65010034.initial_effect(c)
	---spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65010034)
	e1:SetCost(c65010034.spscost)
	e1:SetTarget(c65010034.spstg)
	e1:SetOperation(c65010034.spsop)
	c:RegisterEffect(e1)
	--the power
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65010035)
	e2:SetCondition(c65010034.pwcon)
	e2:SetTarget(c65010034.pwtg)
	e2:SetOperation(c65010034.pwop)
	c:RegisterEffect(e2)
end

function c65010034.spscostfil(c)
	return c:IsSetCard(0x6da0) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function c65010034.spscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010034.spscostfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c65010034.spscostfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c65010034.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end

function c65010034.spsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end

function c65010034.pwconfil(c)
	return c:IsSetCard(0x6da0) and c:GetSequence()<5
end

function c65010034.pwcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c65010034.pwconfil,tp,LOCATION_MZONE,0,e:GetHandler())==0 and Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_REMOVED,0,nil,RACE_CYBERSE)>=2  
end

function c65010034.pwfil(c)
	return c:IsSetCard(0x6da0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65010034.pwfil2(c,code)
	return c:IsSetCard(0x6da0) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end

function c65010034.pwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010034.pwfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c65010034.pwop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65010034.pwfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(65010034,0)) then
			local tc=g:GetFirst()
			local code=tc:GetCode()
			local g2=Duel.SelectMatchingCard(tp,c65010034.pwfil2,tp,LOCATION_DECK,0,1,1,nil,code)
			if g2:GetCount()>0 then
				g:Merge(g2)
			end
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end