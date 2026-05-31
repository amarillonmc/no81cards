--方舟骑士团-斯卡蒂
function c29011741.initial_effect(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29011741,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,29011741)
	e1:SetCondition(c29011741.thcon)
	e1:SetTarget(c29011741.thtg)
	e1:SetOperation(c29011741.thop)
	c:RegisterEffect(e1)
	--SpecialSummon/Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29011741,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,29011742)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c29011741.spcon)
	e2:SetTarget(c29011741.sptg)
	e2:SetOperation(c29011741.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
--SpecialSummon/Destroy
function c29011741.vfilter(c,tp)
	return (c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsControler(tp)) or (c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsControler(1-tp))
end
function c29011741.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29011741.vfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c29011741.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return (c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (c:IsLocation(LOCATION_MZONE) and g:GetCount()>0) end
	 Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29011741.spop(e,tp,eg,ep,ev,re,r,rp,op)
	local c=e:GetHandler()
	if op==nil then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local chk=c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local chk2=g:GetCount()>0
		op=aux.SelectFromOptions(tp,
			{chk,aux.Stringid(29011741,2)},
			{chk2,aux.Stringid(29011741,3)},
			{chk,aux.Stringid(29011741,4)})
	end
	if op&1>0 then
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
		if op==3 then Duel.BreakEffect() end
	end
	if op&2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			Duel.Destroy(g1,REASON_EFFECT)
		end
	end
end
--SearchCard
function c29011741.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c29011741.thfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsRace(RACE_AQUA+RACE_FISH+RACE_SEASERPENT) and c:IsAbleToHand() and not c:IsCode(29011741)
end
function c29011741.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29011741.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29011741.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29011741.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end