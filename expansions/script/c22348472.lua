--银河二重灵魂
function c22348472.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c22348472.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348472,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,22348472)
	e2:SetCost(c22348472.spcost)
	e2:SetTarget(c22348472.sptg)
	e2:SetOperation(c22348472.spop)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348472,1))
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22349472)
	e3:SetCondition(c22348472.yscon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c22348472.ystg)
	e3:SetOperation(c22348472.ysop)
	c:RegisterEffect(e3)
end
function c22348472.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c22348472.costfilter(c)
	return c:IsSetCard(0x55,0xe5) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c22348472.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348472.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348472.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22348472.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348472.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348472.yscfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107b) and c:IsType(TYPE_XYZ)
end
function c22348472.yscon(e,tp,eg,ep,ev,re,r,rp)
	return ((Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)) and Duel.IsExistingMatchingCard(c22348472.yscfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22348472.fselect(g,tp)
	return Duel.GetMZoneCount(1-tp,g)>=g:GetCount() and Duel.CheckReleaseGroup(1-tp,aux.IsInGroup,#g,nil,g)
end
function c22348472.ystg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,0,LOCATION_MZONE,nil)
	local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or 2
	local maxc=math.min(ft,rg:GetCount(),(Duel.GetMZoneCount(1-tp,rg)))
	if chk==0 then return maxc>0 and rg:CheckSubGroup(c22348472.fselect,1,maxc,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,22348473,0x7b,TYPES_TOKEN_MONSTER,0,0,8,RACE_DRAGON,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,0,0,0)
end
function c22348472.ysop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,0,LOCATION_MZONE,nil)
	local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or 2
	local maxc=math.min(ft,rg:GetCount(),(Duel.GetMZoneCount(1-tp,rg)))
	local ph=Duel.GetCurrentPhase()
	if maxc<1 then return false end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,c22348472.fselect,false,1,maxc,tp)
	if #g>0 then
		local rc=Duel.Release(g,REASON_EFFECT)
		if  Duel.IsPlayerCanSpecialSummonMonster(tp,22348473,0x7b,TYPES_TOKEN_MONSTER,0,0,8,RACE_DRAGON,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) then
		local at=0
		for i=1,rc do
			local token=Duel.CreateToken(tp,22348473)
			if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)~=0 then
			at=at+1
			end
		end
		Duel.SpecialSummonComplete()
			if at>0 and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) then
				Duel.BreakEffect()
				Duel.SkipPhase(Duel.GetTurnPlayer(),ph,RESET_PHASE+ph,1)
			end
		end
	end
end
