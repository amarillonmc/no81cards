--星天霖
function c72100052.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72100052+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c72100052.cost)
	e1:SetTarget(c72100052.target)
	e1:SetOperation(c72100052.activate)
	c:RegisterEffect(e1)
end
function c72100052.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c72100052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		for i,p in ipairs({tp,1-tp}) do
			local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
			for i,type in ipairs({TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK}) do
				local rg=g:Filter(Card.IsType,nil,type)
				local rc=rg:GetCount()
				if rc>1 then
					return true
				end
			end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c72100052.activate(e,tp,eg,ep,ev,re,r,rp)
	tp=Duel.GetTurnPlayer()
	local res={}
	for i,p in ipairs({tp,1-tp}) do
		local sg=Group.CreateGroup()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		for i,type in ipairs({TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK}) do
			local rg=g:Filter(Card.IsType,nil,type)
			local rc=rg:GetCount()
			if rc>1 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
				local dg=rg:Select(p,rc-1,rc-1,nil)
				sg:Merge(dg)
			end
		end
		if sg:GetCount()>0 then
			res[p]=true
			Duel.SendtoGrave(sg,REASON_RULE)
		end
	end
	if res[0] or res[1] then
		Duel.BreakEffect()
	end
	for i,p in ipairs({tp,1-tp}) do
		if res[p] then
			local ct=0
			local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
			for i,type in ipairs({TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK}) do
				if g:IsExists(Card.IsType,1,nil,type) then ct=ct+1 end
			end
			Duel.Draw(p,ct,REASON_EFFECT)
		end
	end
end