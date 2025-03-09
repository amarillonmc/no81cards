--教团最强的使徒 ？？？
function c75000917.initial_effect(c)
	aux.AddCodeList(c,75000901)
	--Set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1) 
	--base attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c75000917.atkval)
	c:RegisterEffect(e2)   
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000917,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,75000917)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c75000917.stcon)
	e3:SetTarget(c75000917.sttg)
	e3:SetOperation(c75000917.stop)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c75000917.spcon)
	e4:SetTarget(c75000917.sptg)
	e4:SetOperation(c75000917.spop)
	c:RegisterEffect(e4)	
end
function c75000917.atkval(e,c)
	return Duel.GetMatchingGroupCount(c75000917.tgfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end
function c75000917.tgfilter(c)
	return aux.IsCodeListed(c,75000901)
end
--
function c75000917.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c75000917.filter(c)
	return (c:IsCode(75000901) or aux.IsCodeListed(c,75000901)) and c:IsAbleToHand()
end
function c75000917.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75000917.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) then
		local ct=Duel.SSet(tp,c)
		if ct~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,c75000917.filter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
	end
end
--
function c75000917.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c75000917.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75000917.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end


