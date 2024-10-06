--冒冒失失的女仆 费利西娅
function c75099007.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75099007,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_MAIN_END)
	e1:SetCountLimit(1,75099007)
	e1:SetCondition(c75099007.ctcon)
	e1:SetCost(c75099007.ctcost)
	e1:SetTarget(c75099007.cttg)
	e1:SetOperation(c75099007.ctop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c75099007.intg)
	e2:SetValue(c75099007.efilter)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75099007,1))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,75099008)
	e3:SetTarget(c75099007.sptg)
	e3:SetOperation(c75099007.spop)
	c:RegisterEffect(e3)
c75099007.toss_coin=true
c75099007.frozen_list=true
end
function c75099007.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c75099007.tgfilter(c)
	return (c:IsSetCard(0x750) or c.frozen_list) and c:IsAbleToGraveAsCost()
end
function c75099007.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c75099007.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75099007.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,c)
	g:AddCard(c)
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetTargetCard(hg)
end
function c75099007.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1750,1) end
	e:SetLabel(0)
end
function c75099007.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1750,1) then return end
	local hg=Group.FromCards(Duel.GetFirstTarget())
	local count=hg:GetCount()
	while count>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local cc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x1750,1):GetFirst()
		if cc and cc:AddCounter(0x1750,1) and cc:GetFlagEffect(75099001)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c75099005.frcon)
			e1:SetValue(cc:GetAttack()*-1/4)
			cc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(cc:GetDefense()*-1/4)
			cc:RegisterEffect(e2)
			cc:RegisterFlagEffect(75099001,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		count=count-1
	end
end
function c75099007.intg(e,c)
	return c:IsControler(e:GetHandler():GetOwner()) and c:IsRace(RACE_DRAGON)
end
function c75099007.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandler():GetOwner()
end
function c75099007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c75099007.spop(e,tp,eg,ep,ev,re,r,rp)
	local res=1-Duel.TossCoin(tp,1)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if res==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	elseif res==1 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end
