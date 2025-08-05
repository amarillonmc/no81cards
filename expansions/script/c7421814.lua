--白骨霸王
local s,id,o=GetID()
function s.initial_effect(c)
	--change code
	aux.EnableChangeCode(c,32274490,LOCATION_GRAVE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--summon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetCost(s.costchk)
	e3:SetOperation(s.costop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
end
function s.costchk(e,te_or_c,tp)
	return true
end
function s.tgfilter(c)
	return aux.IsCodeListed(c,32274490) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local tg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,c)
	if #g>0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local sg=tg:Select(tp,1,#g,nil)
		Duel.SendtoGrave(sg,REASON_COST)
		--Duel.Release(sg,REASON_COST)
		local tc=sg:GetFirst()
		while tc do
			e:GetHandler():CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc=sg:GetNext()
		end
	end
end
function s.spcfilter(c)
	return c:IsCode(32274490) and c:IsLocation(LOCATION_GRAVE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.iumfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsLevel(1)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then 
		local g1=Duel.GetMatchingGroup(s.iumfilter,tp,LOCATION_MZONE,0,nil)
		if g1:GetCount()>0 then
			Duel.BreakEffect()
			local nc=g1:GetFirst()
			while nc do
				local e3=Effect.CreateEffect(c)
				e3:SetDescription(aux.Stringid(id,3))
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e3:SetRange(LOCATION_MZONE)
				e3:SetCode(EFFECT_IMMUNE_EFFECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e3:SetValue(s.efilter)
				e3:SetOwnerPlayer(tp)
				nc:RegisterEffect(e3)
				nc=g1:GetNext()
			end
		end
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
