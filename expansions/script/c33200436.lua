--魔力联合 毒漆藤
function c33200436.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200436+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200436.spcon)
	e1:SetOperation(c33200436.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200436,0))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33200437)
	e2:SetTarget(c33200436.atktg)
	e2:SetOperation(c33200436.atkop)
	c:RegisterEffect(e2)
	--immune spell
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c33200436.efilter)
	c:RegisterEffect(e3)  

end

--e1
function c33200436.spfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c33200436.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
		and Duel.IsExistingMatchingCard(c33200436.spfilter,tp,0,LOCATION_GRAVE,2,nil)
end
function c33200436.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33200436.spfilter,tp,0,LOCATION_GRAVE,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--e2
function c33200436.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end

--e3
function c33200436.atkfilter(c)
	return c:IsFaceup() and not c:IsAttack(0)
end
function c33200436.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil,TYPE_SPELL)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200436.atkfilter,tp,0,LOCATION_MZONE,1,nil)
		and g:GetCount()>0 end
end
function c33200436.atkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c33200436.atkfilter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil,TYPE_SPELL)
	if g:GetCount()==0 or sg:GetCount()==0 then return end
	local atkval=g:GetCount()*-500
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(atkval)
		tc:RegisterEffect(e1)
		if tc:IsAttack(0) then Duel.Destroy(tc,REASON_EFFECT) end
	end
end


