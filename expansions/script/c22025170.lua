--人理之诗 日轮啊，顺从死亡
function c22025170.initial_effect(c)
	aux.AddCodeList(c,22022780)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c22025170.cost)
	e1:SetTarget(c22025170.target)
	e1:SetOperation(c22025170.activate)
	c:RegisterEffect(e1)
end
function c22025170.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp-2500,true) end
	e:SetLabel(lp-2500)
	Duel.PayLPCost(tp,lp-2500,true)
end
function c22025170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,sg,sg:GetCount(),0,0)
	Duel.SelectOption(tp,aux.Stringid(22025170,1))
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
		Duel.SelectOption(tp,aux.Stringid(22025170,2))
	end
end
function c22025170.cfilter(c)
	return c:IsFaceup() and c:IsCode(22022780)
end
function c22025170.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 and Duel.SelectOption(tp,aux.Stringid(22025170,3)) and Duel.Release(sg,REASON_EFFECT)~=0 then
		if not Duel.IsExistingMatchingCard(c22025170.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			Duel.BreakEffect()
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.Hint(HINT_CARD,0,22022780)
			Duel.SelectOption(tp,aux.Stringid(22025170,4))
		end
	end
end
