--AKF-圣护的夜莺-囚鸟
function c82568202.initial_effect(c)
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82568202,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c82568202.atcon)
	e2:SetTarget(c82568202.attg)
	e2:SetOperation(c82568202.atop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c82568202.sptg)
	e3:SetOperation(c82568202.spop)
	c:RegisterEffect(e3)
end
function c82568202.spfilter(c,e,tp,mc)
	if c:IsLocation(LOCATION_EXTRA) 
		then return  
		Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and (c:IsCode(82567786) or c:IsCode(82567787) or c:IsCode(82568086) or c:IsCode(82568087))
		 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
	else return 
		(c:IsCode(82567786) or c:IsCode(82567787) or c:IsCode(82568086) or c:IsCode(82568087)) and 
			 c:IsCanBeSpecialSummoned(e,0,tp,true,true) 
	end
end
function c82568202.costfilter(c)
	return c:IsDiscardable()
end
function c82568202.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568202.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c82568202.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c82568202.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and
			  Duel.IsExistingMatchingCard(c82568202.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c82568202.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end 
	  Duel.Release(c,REASON_EFFECT) 
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	  local g=Duel.SelectMatchingCard(tp,c82568202.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	  local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,mc,tc)<=0 then return end
		  if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP) ~=0  then
		tc:CompleteProcedure()
		if tc:IsType(TYPE_XYZ) then
		   Duel.Overlay(tc,Group.FromCards(c))
		   end
	 end
end
function c82568202.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) 
end
function c82568202.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
end
function c82568202.atop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c82568202.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
end
function c82568202.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER) 
end