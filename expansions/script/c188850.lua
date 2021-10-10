--怪物·幻翼
function c188850.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c188850.splimit)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188850,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,188850)
	e1:SetCondition(c188850.spcon)
	e1:SetTarget(c188850.sptg)
	e1:SetOperation(c188850.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188850,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,188850+1000)
	e2:SetCondition(c188850.condition)
	e2:SetTarget(c188850.target)
	e2:SetOperation(c188850.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTarget(c188850.target2)
	e3:SetOperation(c188850.operation2)
	c:RegisterEffect(e3)
end
function c188850.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x16)
end
function c188850.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c188850.spfilter(c,e,tp)
	return c:IsSetCard(0x16) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c188850.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c188850.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c188850.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c188850.spfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c188850.filter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand() and not c:IsCode(188850)
end
function c188850.thfilter(c,e,tp,ft)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_MACHINE) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and not c:IsCode(188850)
end
function c188850.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c188850.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.IsExistingMatchingCard(c188850.filter,tp,LOCATION_DECK,0,1,nil) and not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c188850.operation(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c188850.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c188850.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c188850.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ft) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c188850.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c188850.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
		local tc=g:GetFirst()
		if tc then
			if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end

