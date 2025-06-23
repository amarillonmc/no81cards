--王道踏破·剑
function c22023670.initial_effect(c)
	aux.AddCodeList(c,22023340)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,22023340+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22023670.target)
	e1:SetOperation(c22023670.activate)
	c:RegisterEffect(e1)
	--dr
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023670,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22023340)
	e2:SetCondition(c22023670.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22023670.drtg)
	e2:SetOperation(c22023670.drop)
	c:RegisterEffect(e2)
end
function c22023670.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	if Duel.GetFlagEffect(tp,22023340)<7 then
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
	if Duel.GetFlagEffect(tp,22023340)>6 then
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0) end
end
function c22023670.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if Duel.GetFlagEffect(tp,22023340)>6 then
	Duel.Destroy(sg,REASON_EFFECT)
	end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if Duel.GetFlagEffect(tp,22023340)<7 and #g>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c22023670.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023340)>2
end
function c22023670.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22023670.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
