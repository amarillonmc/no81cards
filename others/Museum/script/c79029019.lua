--罗德岛·近卫干员-夜刀
function c79029019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(c79029019.sptg)
	e1:SetOperation(c79029019.spop)
	c:RegisterEffect(e1)
end
function c79029019.spfilter(c,e,tp,tid)
	if c:IsType(TYPE_PENDULUM) then
	return c:GetTurnID()==tid and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsReason(REASON_BATTLE) and c:GetReasonPlayer()==1-tp) and Duel.GetLocationCountFromEx(tp)>0
	else
	return c:GetTurnID()==tid and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsReason(REASON_BATTLE) and c:GetReasonPlayer()==1-tp)
end
end
function c79029019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029019.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,Duel.GetTurnCount()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c79029019.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c79029019.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp,Duel.GetTurnCount())
	if ft<1 or #tg<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,79029019,0xf02,0x11,1300,800,2,RACE_CYBERSE,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	Debug.Message("只要我们将博士的战术坚持到底，就绝不会发生任何问题。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029019,0))
end
end