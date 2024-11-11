--龙爆发急调
function c49811416.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,49811416)
	e1:SetTarget(c49811416.target)
	e1:SetOperation(c49811416.activate)
	c:RegisterEffect(e1)
	--grave effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811417)
	e2:SetCondition(c49811416.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c49811416.sptg)
	e2:SetOperation(c49811416.spop)
	c:RegisterEffect(e2)
end
function c49811416.sumfilter(c)
	return ((c:IsRace(RACE_DRAGON) and c:IsLevelAbove(5)) or c:IsRace(RACE_SPELLCASTER))
		and c:IsSummonable(true,nil)
end
function c49811416.thfilter(c,e,tp,check)
	local minc,maxc=c:GetTributeRequirement()
	return c:IsRace(RACE_DRAGON) and c:IsLevelAbove(5) and c:IsAbleToHand() and 
		(check or (c:IsSummonable(true,nil) and c:IsSummonableCard() and c49811416.sunthfilter(c,e,tp,minc,maxc) and Duel.IsPlayerCanSummon(tp,SUMMON_TYPE_ADVANCE,c)))
end
function c49811416.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.IsExistingMatchingCard(c49811416.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811416.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
--summon check
function c49811416.sunthfilter(c,e,tp,minc,maxc)
	local e1=nil
	--55521751
	if c49811416.ottg(e,c) and Duel.IsExistingMatchingCard(c49811416.cfilter,tp,LOCATION_SZONE,0,1,nil) then
		e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetCondition(c49811416.otcon)
		e1:SetValue(SUMMON_TYPE_ADVANCE)
		c:RegisterEffect(e1,true)
	end
	if c:IsHasEffect(EFFECT_TRIBUTE_LIMIT,c:GetControler()) then
		local te=c:IsHasEffect(EFFECT_TRIBUTE_LIMIT,tp)
		local ev=te:GetValue()
		if not Duel.IsExistingMatchingCard(c49811416.sunthfilter2,tp,LOCATION_MZONE,0,1,nil,e,ev) then
			return false
		end
	end
	if c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC,c:GetControler()) then
		local tte=c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC,c:GetControler())
		local ec=tte:GetCondition()
		if not ec(e,c,0) then return false end
	end
	if c:IsHasEffect(EFFECT_SUMMON_PROC,c:GetControler()) then
		local tte=c:IsHasEffect(EFFECT_SUMMON_PROC,c:GetControler())
		local ec=tte:GetCondition()
		if ec(e,c,0) then
			return true
		end
	else
		if not Duel.CheckTribute(c,minc,maxc) then return false end
	end
	if c:IsHasEffect(EFFECT_CANNOT_SUMMON,c:GetControler()) then
		return false
	end
	if e1 then e1:Reset() end
	return true
end
--55521751↓
function c49811416.cfilter(c)
	return c:IsCode(55521751) and not c:IsDisabled()
end
function c49811416.otfilter(c,e,tp)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and Duel.GetMZoneCount(tp,c)>0
end
function c49811416.otfilter2(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c49811416.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=2
		and Duel.IsExistingMatchingCard(c49811416.otfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c49811416.otfilter2,tp,0,LOCATION_ONFIELD,1,nil,e)
end
function c49811416.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi<=2 and ma>=2
end
--55521751↑
function c49811416.sunthfilter2(c,e,ev)
	return ev(e,c)
end
--operation
function c49811416.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(c49811416.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c49811416.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
	if #tg>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tg)
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c49811416.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local sg=g:Select(tp,1,1,nil)
		Duel.Summon(tp,sg:GetFirst(),true,nil)
	end
end
function c49811416.confilter(c,tp)
	return (c:GetPreviousRaceOnField()&RACE_DRAGON)>0 and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_RULE)
end
function c49811416.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811416.confilter,1,nil,tp)
end
function c49811416.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsDefense(1100) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811416.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c49811416.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c49811416.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c49811416.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
