--逆元构造 瑰丽
function c79029817.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029817.spcon)
	c:RegisterEffect(e1)
	--t g
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,79029817)
	e2:SetCondition(c79029817.tgcon)
	e2:SetTarget(c79029817.dstg)
	e2:SetOperation(c79029817.dsop)
	c:RegisterEffect(e2) 
	--xyz effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029817,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,09029817)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c79029817.xyztg)
	e3:SetOperation(c79029817.xyzop)
	c:RegisterEffect(e3)
end
function c79029817.xxfilter(c)
	return not c:IsLevel(3) and not c:IsRank(3) and not c:IsLink(3)
end
function c79029817.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
	  not  Duel.IsExistingMatchingCard(c79029817.xxfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(Card.IsFacedown,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
end
function c79029817.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029817.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,LOCATION_ONFIELD)
end
function c79029817.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local sg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	if sg:GetCount()>0 then
	local tc=sg:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end
function c79029817.xyzfilter(c,g)
	return c:IsRace(RACE_MACHINE) and c:IsXyzSummonable(g)
end
function c79029817.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xa991)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029817.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029817.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local xg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xa991)
	local g=Duel.GetMatchingGroup(c79029817.xyzfilter,tp,LOCATION_EXTRA,0,nil,xg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),xg)
	end
end

