--旧世迷庙的化身·羽蛇神 LV9
function c10700615.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700615,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10700615)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10700615.gspcon)
	e1:SetCost(c10700615.gspcost)
	e1:SetTarget(c10700615.gsptg)
	e1:SetOperation(c10700615.gspop)
	c:RegisterEffect(e1)	  
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_RELEASE)
	e2:SetOperation(c10700615.regop)
	c:RegisterEffect(e2)	
	--can not be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetTarget(c10700615.ettg)
	c:RegisterEffect(e3)  
end
c10700615.lvdn={10700610}
function c10700615.gspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10700615.gspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsType,1,nil,TYPE_MONSTER) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
	Duel.Release(g,REASON_COST)
end
function c10700615.gspfilter(c,e,tp)
	return c:IsLevelBelow(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10700615.gsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c10700615.gspfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10700615.gspfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10700615.gspfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10700615.gspop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10700615.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_HAND) then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700615,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,10700616)
	e1:SetTarget(c10700615.sptg)
	e1:SetOperation(c10700615.spop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	end
end
function c10700615.spfilter(c,e,tp)
	return c:IsCode(10700600) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c10700615.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10700615.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c10700615.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10700615.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if tc:IsPreviousLocation(LOCATION_GRAVE) and hg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700615,2)) then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-tp)
	end
end
function c10700615.etfilter(c)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsLocation(LOCATION_MZONE)
end
function c10700615.ettg(e,c)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c10700615.etfilter,1,nil)
end