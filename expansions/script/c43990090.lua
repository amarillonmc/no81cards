--受缚之王
local m=43990090
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsRace,RACE_ILLUSION),13,127,false)
	--e1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990090,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c43990090.e1cost)
	e1:SetTarget(c43990090.e1tg)
	e1:SetOperation(c43990090.e1op)
	c:RegisterEffect(e1)
	--damge
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990090,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,43990090)
	e2:SetCost(c43990090.damcost)
	e2:SetTarget(c43990090.damtg)
	e2:SetOperation(c43990090.damop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c43990090.spcon)
	e3:SetOperation(c43990090.spop)
	c:RegisterEffect(e3)
	

end
function c43990090.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c43990090.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(c43990090.sp2con2)
	e1:SetOperation(c43990090.sp2op2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c43990090.pefilter(c,e,tp)
	return c:IsRace(RACE_ILLUSION) and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43990090.sp2con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43990090.pefilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)
end
function c43990090.sp2op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c43990090.pefilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990090.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c43990090.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c43990090.damcost(e,tp,eg,ep,ev,re,r,rp,0)
			and Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,nil)
	end
	c43990090.damcost(e,tp,eg,ep,ev,re,r,rp,1)
	local rg=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,99,nil)
	local ct=rg:GetCount()
	e:SetValue(ct)
	Duel.Release(rg,REASON_COST)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500*ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500*ct)
end
function c43990090.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c43990090.cosfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function c43990090.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c43990090.cosfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c43990090.cosfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c43990090.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0

end
function c43990090.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990090.spfilter1,tp,0,LOCATION_EXTRA,1,nil,e,tp) or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c43990090.e1op(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c43990090.spfilter1,tp,0,LOCATION_EXTRA,1,nil,e,tp) then
		ops[off]=aux.Stringid(43990090,2)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		ops[off]=aux.Stringid(43990090,3)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(1-tp,table.unpack(ops))
	if opval[op]==1 then
		local sg=Duel.GetMatchingGroup(c43990090.spfilter1,tp,0,LOCATION_EXTRA,nil,e,tp)
		Duel.ShuffleExtra(1-tp)
		local tc=sg:RandomSelect(1-tp,1):GetFirst()
		if not tc then return end
		Duel.SpecialSummon(tc,0,1-tp,tp,true,false,POS_FACEUP)
	elseif opval[op]==2 then
		Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end




