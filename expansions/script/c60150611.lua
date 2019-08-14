--千夜 苦水咒
function c60150611.initial_effect(c)
	c:SetUniqueOnField(1,0,60150611)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60150611.ffilter,aux.FilterBoolFunction(c60150611.ffilter2),false)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c60150611.splimit)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c60150611.sprcon)
	e3:SetOperation(c60150611.sprop)
	c:RegisterEffect(e3)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCategory(CATEGORY_TODECK)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCost(c60150611.cost)
	e9:SetTarget(c60150611.detg)
	e9:SetOperation(c60150611.deop)
	c:RegisterEffect(e9)
end
function c60150611.ffilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) 
end
function c60150611.ffilter2(c)
	return c:IsAttribute(ATTRIBUTE_WATER) or c:IsHasEffect(60150618)
end
function c60150611.cfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150611.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) 
		and Duel.IsExistingMatchingCard(c60150611.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local g=Duel.GetMatchingGroup(c60150611.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local g2=g:Filter(c60150611.gfilter,nil)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150618,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150618,1))
			local sg=g2:Select(tp,1,1,nil)
			local tc2=sg:GetFirst()
			while tc2 do
				if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
				tc2=sg:GetNext()
			end
			Duel.SendtoExtraP(sg,nil,REASON_COST)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150642,2))
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
function c60150611.tfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c60150611.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150611.tfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c60150611.tfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c60150611.deop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c60150611.tfilter,tp,0,LOCATION_ONFIELD,nil)
	local ct=Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	local c=e:GetHandler()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		e2:SetValue(ct*200)
		c:RegisterEffect(e2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c60150611.imfilter)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c60150611.imfilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c60150611.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150611.spfilter1(c,tp,fc)
	return c:IsSetCard(0x3b21) and c:IsCanBeFusionMaterial(fc,true) and c:IsFaceup() 
		and c:IsAbleToDeckOrExtraAsCost()
		and Duel.IsExistingMatchingCard(c60150611.spfilter2,tp,LOCATION_MZONE,0,1,c,fc) 
end
function c60150611.spfilter2(c,fc)
	return (c:IsAttribute(ATTRIBUTE_WATER) or c:IsHasEffect(60150618)) and c:IsCanBeFusionMaterial(fc)
		and c:IsAbleToDeckOrExtraAsCost() 
end
function c60150611.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x3b21) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c60150611.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c60150611.filter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c60150611.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
			and Duel.IsExistingMatchingCard(c60150611.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	end
end
function c60150611.gfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c60150611.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c60150611.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c60150611.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	c:SetMaterial(g1)
	local g=g1:Filter(c60150611.gfilter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150602,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150602,1))
		local sg=g:Select(tp,1,g:GetCount(),nil)
		local gtc=sg:GetFirst()
		while gtc do
			g1:RemoveCard(gtc)
			gtc=sg:GetNext()
		end
		Duel.SendtoExtraP(sg,nil,REASON_COST+REASON_MATERIAL+REASON_FUSION)
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end