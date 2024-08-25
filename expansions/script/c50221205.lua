--数码兽大冒险
function c50221205.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50221205+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c50221205.target)
	e1:SetOperation(c50221205.activate)
	c:RegisterEffect(e1)
end
function c50221205.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb1)
end
function c50221205.spfilter1(c,e,tp)
	return c:IsSetCard(0xcb1) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
end
function c50221205.spfilter2(c,e,tp)
	return c:IsSetCard(0xcb1) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
end
function c50221205.spfilter3(c,e,tp)
	return c:IsSetCard(0xcb1) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetMZoneCount(tp)>0
end
function c50221205.spfilter4(c,e,tp)
	return c:IsSetCard(0xcb1) and c:IsLevelBelow(10) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetMZoneCount(tp)>0
end
function c50221205.spfilter5(c,e,tp)
	return c:IsSetCard(0xcb1) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c50221205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(c50221205.filter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetAttribute)
	if chk==0 then return 
		   (ct==1 and Duel.IsExistingMatchingCard(c50221205.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp))
		or (ct==2 and Duel.IsExistingMatchingCard(c50221205.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp))
		or (ct==3 and Duel.IsExistingMatchingCard(c50221205.spfilter3,tp,LOCATION_DECK,0,1,nil,e,tp))
		or (ct==4 and Duel.IsExistingMatchingCard(c50221205.spfilter4,tp,LOCATION_DECK,0,1,nil,e,tp))
		or (ct==5 and Duel.IsExistingMatchingCard(c50221205.spfilter5,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp))
		or (ct==6 and Duel.IsPlayerCanDraw(tp,3))
	end
	if ct==1 or ct==2 or ct==3 or ct==4 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif ct==5 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	elseif ct==6 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(3)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	end
end
function c50221205.splimit(e,c)
	return not c:IsSetCard(0xcb1)
end
function c50221205.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c50221205.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	local ct=Duel.GetMatchingGroup(c50221205.filter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetAttribute)
	local g1=Duel.GetMatchingGroup(c50221205.spfilter1,tp,LOCATION_DECK,0,nil,e,tp)
	if ct==1 and g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	end
	local g2=Duel.GetMatchingGroup(c50221205.spfilter2,tp,LOCATION_DECK,0,nil,e,tp)
	if ct==2 and g2:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
	end
	local g3=Duel.GetMatchingGroup(c50221205.spfilter3,tp,LOCATION_DECK,0,nil,e,tp)
	if ct==3 and g3:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg3=g3:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg3,0,tp,tp,true,false,POS_FACEUP)
	end
	local g4=Duel.GetMatchingGroup(c50221205.spfilter4,tp,LOCATION_DECK,0,nil,e,tp)
	if ct==4 and g4:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg4=g4:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg4,0,tp,tp,true,false,POS_FACEUP)
	end
	local g5=Duel.GetMatchingGroup(c50221205.spfilter5,tp,LOCATION_EXTRA,0,nil,e,tp)
	if ct==5 and g5:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg5=g5:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg5,0,tp,tp,true,false,POS_FACEUP)
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if ct==6 then
		Duel.BreakEffect()
		Duel.Draw(p,d,REASON_EFFECT)
	end
end