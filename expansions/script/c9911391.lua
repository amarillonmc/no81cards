--雪狱之罪哀 永不止息
function c9911391.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911391)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(c9911391.condition)
	e1:SetCost(c9911391.cost)
	e1:SetTarget(c9911391.target)
	e1:SetOperation(c9911391.activate)
	c:RegisterEffect(e1)
	--detach
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911392)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911391.dtcon)
	e2:SetCost(c9911391.dtcost)
	e2:SetTarget(c9911391.dttg)
	e2:SetOperation(c9911391.dtop)
	c:RegisterEffect(e2)
end
function c9911391.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9911391.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c9911391.spfilter(c,e,tp)
	return c:IsSetCard(0xc956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911391.sgselect(g,tp)
	local mg=Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,tp,LOCATION_MZONE,0,nil,nil)
	mg:Merge(g)
	return Duel.IsExistingMatchingCard(c9911391.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c9911391.xyzfilter(c,mg)
	return c:IsSetCard(0xc956) and c:IsXyzSummonable(mg)
end
function c9911391.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911391.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local ct=0
	if Duel.GetDecktopGroup(tp,4):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==4
		and Duel.GetMZoneCount(tp)>=1 then ct=1 end
	if Duel.GetDecktopGroup(tp,8):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==8
		and Duel.GetMZoneCount(tp)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=2 end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return ct>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2) and g:CheckSubGroup(c9911391.sgselect,1,ct,tp)
	end
	local op=0
	if ct==1 or #g==1 then
		op=Duel.SelectOption(tp,aux.Stringid(9911391,0))
	elseif g:CheckSubGroup(c9911391.sgselect,1,1,tp) then
		op=Duel.SelectOption(tp,aux.Stringid(9911391,0),aux.Stringid(9911391,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911391,1))+1
	end
	Duel.DisableShuffleCheck()
	local rg=Duel.GetDecktopGroup(tp,4+op*4)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	Duel.SetTargetParam(op+1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,op+1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9911391.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,9911392,RESET_PHASE+PHASE_END,0,1)
	end
	local g=Duel.GetMatchingGroup(c9911391.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if #g<ct or Duel.GetMZoneCount(tp)<ct then return end
	if ct==2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c9911391.sgselect,false,1,ct,tp)
	if not sg or #sg==0 or Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.AdjustAll()
	local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if xyzg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,nil)
	end
end
function c9911391.dtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911392)==0
end
function c9911391.dtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9911391.dttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
end
function c9911391.dtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,1,1,nil,tp,1,REASON_EFFECT)
	if #sg>0 then
		Duel.HintSelection(sg)
		sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(8)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e1,tp)
end
