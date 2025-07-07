function c10111206.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,10111206+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10111206.cost)
	e1:SetTarget(c10111206.target)
	e1:SetOperation(c10111206.activate)
	c:RegisterEffect(e1)
	--Synchro Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10111206.syntg)
	e2:SetOperation(c10111206.synop)
	c:RegisterEffect(e2)
end
function c10111206.cfilter(c)
	return c:IsSetCard(0x16c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c10111206.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111206.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c10111206.cfilter,1,1,REASON_COST,nil)
end
function c10111206.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

-- 修改后的部分
function c10111206.spfilter(c,e,tp)
	return c:IsSetCard(0x16c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10111206.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local dr=Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10111206.spfilter),p,LOCATION_GRAVE,0,nil,e,tp)
	if dr~=0 and g:GetCount()>0 and Duel.SelectYesNo(p,aux.Stringid(10111206,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local sg=g:Select(p,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,p,false,false,POS_FACEUP)
		end
	end
end
function c10111206.mfilter(c)
	return c:IsSetCard(0x16c) and c:IsType(TYPE_TUNER)
end
function c10111206.syncheck(g,tp,syncard)
	return g:IsExists(c10111206.mfilter,1,nil) and syncard:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,syncard)
end
function c10111206.spfilter1(c,tp,mg)
	return c:IsAttribute(ATTRIBUTE_WATER) and mg:CheckSubGroup(c10111206.syncheck,2,#mg,tp,c)
end
function c10111206.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetSynchroMaterial(tp)
		if mg:IsExists(Card.GetHandSynchro,1,nil) then
			local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
			if mg2:GetCount()>0 then mg:Merge(mg2) end
		end
		return Duel.IsExistingMatchingCard(c10111206.spfilter1,tp,LOCATION_EXTRA,0,1,nil,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10111206.synop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local g=Duel.GetMatchingGroup(c10111206.spfilter1,tp,LOCATION_EXTRA,0,nil,tp,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:SelectSubGroup(tp,c10111206.syncheck,false,2,#mg,tp,sc)
		Duel.SynchroSummon(tp,sc,nil,tg,#tg-1,#tg-1)
	end
end