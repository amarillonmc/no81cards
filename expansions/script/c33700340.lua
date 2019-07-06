--阻抗之嘴 ~人祸~
function c33700340.initial_effect(c)
	c:SetUniqueOnField(1,1,33700340)   
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700340,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x1e0)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c33700340.thcon)
	e3:SetTarget(c33700340.thtg)
	e3:SetOperation(c33700340.thop)
	c:RegisterEffect(e3)   
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700340,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33700340.sptg)
	e2:SetOperation(c33700340.spop)
	c:RegisterEffect(e2)
end
function c33700340.filter(c,e,tp)
	return c:IsSetCard(0x5449) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700340.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33700340.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33700340.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700340.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local rg=Duel.GetMatchingGroup(c33700340.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e,tp)
	if rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33700340,2)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local rc=rg:Select(tp,1,1,nil):GetFirst()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local sg=Duel.SelectMatchingCard(tp,c33700340.rfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,rc,e,tp)
	   sg:AddCard(rc)
	   if Duel.Release(sg,REASON_EFFECT)~=0 and Duel.GetLocationCountFromEx(tp)>0 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local esg=Duel.SelectMatchingCard(tp,c33700340.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		  local stp=0
		  if c:IsType(TYPE_FUSION) then
			 stp=SUMMON_TYPE_FUSION
		  elseif c:IsType(TYPE_LINK) then
			 stp=SUMMON_TYPE_LINK 
		  end
		  Duel.SpecialSummon(esg,stp,tp,tp,false,false,POS_FACEUP)
		  esg:GetFirst():CompleteProcedure()
	   end
	end
end
function c33700340.rfilter0(c)
	return c:IsSetCard(0x5449) and c:IsType(TYPE_MONSTER) 
end
function c33700340.rfilter(c,e,tp)
	return c33700340.rfilter0(c) and Duel.IsExistingMatchingCard(c33700340.rfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,e,tp) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c33700340.rfilter2(c,e,tp)
	return c33700340.rfilter0(c) and Duel.IsExistingMatchingCard(c33700340.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c33700340.spfilter(c,e,tp)
	local stp=0
	if c:IsType(TYPE_FUSION) then
	   stp=SUMMON_TYPE_FUSION
	elseif c:IsType(TYPE_LINK) then
	   stp=SUMMON_TYPE_LINK 
	else
	   return false 
	end
	return c:IsSetCard(0x5449) and c:IsCanBeSpecialSummoned(e,stp,tp,false,false)
end
function c33700340.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_SZONE)
end
function c33700340.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c33700340.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp
end