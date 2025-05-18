--千夜的娱乐屋
function c60150608.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c60150608.condition1)
	e1:SetCost(c60150608.cost1)
	e1:SetTarget(c60150608.target1)
	e1:SetOperation(c60150608.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--remain field
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e9)
	--act in hand
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e8:SetCondition(c60150608.handcon)
	c:RegisterEffect(e8)
end
function c60150608.handconf(c)
	return c:IsFaceup() and ((c:IsSetCard(0x3b21) and c:IsType(TYPE_FUSION)) or (c:IsSetCard(0x9b21) and c:IsType(TYPE_FUSION)))
end
function c60150608.handcon(e)
	return Duel.IsExistingMatchingCard(c60150608.handconf,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c60150608.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b21) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150608.gfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c60150608.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150608.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c60150608.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler())
	if g:GetCount()>0 then
		local g2=g:Filter(c60150608.gfilter,nil)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150608,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150608,1))
			local sg=g2:Select(tp,1,1,nil)
			local tc2=sg:GetFirst()
			while tc2 do
				if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
				tc2=sg:GetNext()
			end
			Duel.SendtoExtraP(sg,nil,REASON_COST)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150608,2))
			local sg=g:Select(tp,1,1,nil)
			local tc2=sg:GetFirst()
			while tc2 do
				if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
				tc2=sg:GetNext()
			end
			Duel.SendtoDeck(sg,nil,2,REASON_COST)
		end
	end
end
function c60150608.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c60150608.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c60150608.activate1f(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and (c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_EXTRA))
end
function c60150608.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	if Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	local g=Duel.GetOperatedGroup()
	local g2=g:Filter(c60150608.activate1f,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=g2:GetCount() and Duel.SelectYesNo(tp,aux.Stringid(60150608,3)) then 
		Duel.SpecialSummon(g2,0,tp,tp,true,true,POS_FACEUP)
	end
end