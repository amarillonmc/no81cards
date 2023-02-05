--巨石遗物精灵
function c98920185.initial_effect(c)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920185,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98920185)
	e1:SetCondition(c98920185.thcon)
	e1:SetTarget(c98920185.tgtg)
	e1:SetOperation(c98920185.tgop)
	c:RegisterEffect(e1)
--ritual summon
	local e2=aux.AddRitualProcGreater2(c,c98920185.filter1,LOCATION_HAND+LOCATION_DECK,nil,nil,true)
	e2:SetDescription(aux.Stringid(98920185,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,78990928)
	e2:SetCondition(c98920185.rscon)
	c:RegisterEffect(e2)
end
function c98920185.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c98920185.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function c98920185.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920185.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98920185.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920185.filter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c98920185.filter1(c,e,tp,chk)
	return c:IsSetCard(0x138)
end
function c98920185.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end