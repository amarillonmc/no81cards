--授格构造 戏炎
function c79029815.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c79029815.mfilter1,c79029815.mfilter2,2,2,true)
	--ng
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029815.ngcon)
	e1:SetOperation(c79029815.ngop)
	c:RegisterEffect(e1)
	--tg
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029815.tgcon)
	e2:SetOperation(c79029815.tgop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,19029815)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c79029815.sptg)
	e3:SetOperation(c79029815.spop)
	c:RegisterEffect(e3)
end
function c79029815.mfilter1(c)
	return c:IsOnField()
end
function c79029815.mfilter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsLevelBelow(3)
end
function c79029815.ngcon(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return rp==tp and te:GetHandlerPlayer()==1-tp and eg:GetFirst():IsSetCard(0xa991) and Duel.GetFlagEffect(tp,79029815)==0
end
function c79029815.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(79029815,0)) then 
	Duel.Hint(HINT_CARD,0,79029815)
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	Duel.NegateEffect(ev-1)
	Duel.RegisterFlagEffect(tp,79029815,RESET_PHASE+PHASE_END,0,1)
	end
end
function c79029815.tgfil(c,type)
	return c:IsSetCard(0xa991) and c:IsType(type) and c:IsAbleToGrave()
end
function c79029815.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	local tc=eg:GetFirst()
	local type=tc:GetType()
	return rp==1-tp and te:GetHandlerPlayer()==tp and te:GetHandler():IsSetCard(0xa991) and Duel.GetFlagEffect(tp,09029815)==0
	and Duel.IsExistingMatchingCard(c79029815.tgfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,type)
end
function c79029815.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local type=tc:GetType()
	if Duel.SelectYesNo(tp,aux.Stringid(79029815,1)) then 
	Duel.Hint(HINT_CARD,0,79029815)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029815.tgfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,type)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,09029815,RESET_PHASE+PHASE_END,0,1)
	end
end
function c79029815.spfil(c,e,tp)
	return c:IsSetCard(0xa991) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029815.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029815.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c79029815.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029815.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029815.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029815.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end


