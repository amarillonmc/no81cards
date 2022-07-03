--永夏的反魂
function c9910975.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910975.flag)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910975.target)
	e1:SetOperation(c9910975.activate)
	c:RegisterEffect(e1)
end
function c9910975.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910975.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5 end
end
function c9910975.setfilter(c)
	return c:IsFacedown() and c:IsSetCard(0x5954) and c:IsReason(REASON_EFFECT)
		and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c9910975.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<5 then return end
	Duel.ConfirmDecktop(1-tp,5)
	local g=Duel.GetDecktopGroup(1-tp,5)
	if #g==0 then return end
	local lv=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	local res=g:IsExists(Card.IsType,1,nil,TYPE_TRAP)
	if lv>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910975,0x5954,0x11,0,0,lv,RACE_ZOMBIE,ATTRIBUTE_LIGHT)
		and Duel.SelectYesNo(tp,aux.Stringid(9910975,0)) then
		c:AddMonsterAttribute(TYPE_NORMAL,nil,nil,lv,nil,nil)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
	local tg=g:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(9910975,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=tg:Select(tp,1,3,nil)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
	local g1=Duel.GetMatchingGroup(c9910975.setfilter,tp,LOCATION_REMOVED,0,nil)
	if res and #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(9910975,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g2=g1:Select(tp,1,1,nil)
		Duel.SSet(tp,g2)
	end
	Duel.ShuffleDeck(1-tp)
end
