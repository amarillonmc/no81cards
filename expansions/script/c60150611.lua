--千夜 苦水咒
function c60150611.initial_effect(c)
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
	e9:SetDescription(aux.Stringid(60150610,5))
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
	return c:IsSetCard(0x3b21) and c:IsFaceup() and c:IsAbleToDeckOrExtraAsCost()
end
function c60150611.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150611.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c60150611.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
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
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c60150611.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150611.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c60150611.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150611.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c60150611.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
		local sg2=Duel.GetOperatedGroup()
		if sg2:GetCount()==0 then return end
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		local tc=sg2:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e1:SetTarget(c60150611.distg1)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(c60150611.discon)
			e2:SetOperation(c60150611.disop)
			e2:SetLabelObject(tc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(c60150611.distg2)
			e3:SetLabelObject(tc)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			tc=sg2:GetNext()
		end
	end
end
function c60150611.distg1(e,c)
	local tc=e:GetLabelObject()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
	else
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function c60150611.distg2(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c60150611.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c60150611.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
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
	return c:IsFaceup() and c:IsSetCard(0x3b21)
end
function c60150611.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60150611.filter,tp,LOCATION_PZONE,0,nil)
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
	local g2=Duel.SelectMatchingCard(tp,c60150611.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
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