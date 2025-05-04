--继承龙血的少女 传承莉莉安
function c75000825.initial_effect(c)
	aux.AddCodeList(c,75000812) 
	--special summon other monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000825,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75000825)
	e2:SetCondition(c75000825.spcon)
	e2:SetCost(c75000825.spcost)
	e2:SetTarget(c75000825.sptg)
	e2:SetOperation(c75000825.spop)
	c:RegisterEffect(e2)
	--grave to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000825,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,75000826)
	e3:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e3:SetCondition(c75000825.thcon)
	e3:SetTarget(c75000825.thtg)
	e3:SetOperation(c75000825.thop)
	c:RegisterEffect(e3)
	if not c75000825.global_check then
		c75000825.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c75000825.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c75000825.sspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)
end
function c75000825.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c75000825.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c75000825.spfilter(c,e,tp)
	return c:IsSetCard(0xa751) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75000825.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c75000825.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75000825.thfilter(c)
	return c:IsCode(75000821) and c:IsAbleToHand()
end
function c75000825.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75000825.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		if g:GetFirst():IsCode(75000812) and Duel.IsExistingMatchingCard(c75000825.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75000825,2)) then
			local tg=Duel.GetFirstMatchingCard(c75000825.thfilter,tp,LOCATION_DECK,0,nil)
			if tg then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end   
		end
	end
end
function c75000825.checkfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsControler(tp)
end
function c75000825.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c75000825.checkfilter,1,nil,0) then Duel.RegisterFlagEffect(0,75000825,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(c75000825.checkfilter,1,nil,1) then Duel.RegisterFlagEffect(1,75000825,RESET_PHASE+PHASE_END,0,1) end
end
function c75000825.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75000825)~=0  
end
function c75000825.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75000825.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

