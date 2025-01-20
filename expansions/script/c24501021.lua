--神威骑士，超级转变！
function c24501021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,24501021)
	e1:SetCost(c24501021.cost)
	e1:SetTarget(c24501021.target)
	--e1:SetOperation(c24501021.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,24501022)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c24501021.drtg)
	e2:SetOperation(c24501021.drop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(24501021,ACTIVITY_CHAIN,c24501021.counterfilter)
end
function c24501021.counterfilter(re,tp,cid)
	local race=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_RACE)
	return not (re:IsActiveType(TYPE_MONSTER) and race&RACE_MACHINE==0)
end
function c24501021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.GetCustomActivityCount(24501021,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(c24501021.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c24501021.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_MACHINE)
end
function c24501021.costfilter(c,e,tp,g)
	local ft=Duel.GetMZoneCount(tp,c)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	return c:IsSetCard(0x501) and c:IsType(TYPE_SYNCHRO) and c:IsReleasable()
	   and (Duel.IsExistingMatchingCard(c24501021.synfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetLevel()) or g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,ft))
end
function c24501021.synfilter(c,e,tp,tc,lv)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsLevel(lv)
		and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c24501021.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c24501021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c24501021.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c24501021.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=Duel.SelectMatchingCard(tp,c24501021.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,g):GetFirst()
	local lv=tc:GetLevel()
	Duel.Release(tc,REASON_COST)
	Duel.SetTargetParam(lv)
	local ft=Duel.GetMZoneCount(tp)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local b1=Duel.IsExistingMatchingCard(c24501021.synfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil,lv)
	local b2=g:CheckWithSumEqual(Card.GetLevel,lv,1,ft)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(24501021,0)},
		{b2,aux.Stringid(24501021,1)})
	if op==1 then
		e:SetOperation(c24501021.activate1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	elseif op==2 then
		e:SetOperation(c24501021.activate2)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	end
end
function c24501021.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c24501021.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil,lv):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end
function c24501021.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ft=Duel.GetMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c24501021.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,lv,1,ft)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c24501021.tdfilter(c)
	return c:IsSetCard(0x501) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function c24501021.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c24501021.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24501021.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c24501021.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,5,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c24501021.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 or aux.PlaceCardsOnDeckBottom(tp,g)==0 then return end
	if Duel.IsPlayerCanDraw(tp,2) then
		Duel.BreakEffect()
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
