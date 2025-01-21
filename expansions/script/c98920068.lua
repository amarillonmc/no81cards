--神星去往的尽头
function c98920068.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(98920068,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE) 
	e1:SetCondition(c98920068.condition) 
	e1:SetTarget(c98920068.target)  
	e1:SetOperation(c98920068.operation)  
	c:RegisterEffect(e1) 
--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920068,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98920068+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c98920068.spcon2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920068.sptg2)
	e2:SetOperation(c98920068.spop2)
	c:RegisterEffect(e2)
end
function c98920068.atkfilter(c)
	return c:IsSetCard(0xc4) and c:IsFaceup()
end
function c98920068.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetMatchingGroupCount(c98920068.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)>Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)  
end	
function c98920068.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end  
function c98920068.operation(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if Duel.SendtoHand(g,nil,REASON_EFFECT) then
	   local og=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,1-tp)
	   local cst=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	   local sg=Duel.GetMatchingGroup(c98920068.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
	   if cst==#og and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98920068,1)) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local kg=sg:Select(tp,1,1,nil)
		  if kg:GetCount()>0 then
			 Duel.SpecialSummon(kg,0,tp,tp,true,true,POS_FACEUP)
		  end
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_FIELD)
		  e1:SetCode(EFFECT_CANNOT_ATTACK)
		  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		  e1:SetTargetRange(LOCATION_MZONE,0)
		  e1:SetTarget(c98920068.atktg)
		  e1:SetReset(RESET_PHASE+PHASE_END)
		  Duel.RegisterEffect(e1,tp)
	   end
	end
end  
function c98920068.spfilter(c,e,tp)
	return c:IsCode(29432356) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c98920068.atktg(e,c)
	return not c:IsCode(29432356)
end
function c98920068.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c98920068.spfilter1(c,e,tp)
	return c:IsCode(85216896) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920068.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920068.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920068.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920068.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
end