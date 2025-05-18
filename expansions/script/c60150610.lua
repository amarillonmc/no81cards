--千夜 灵火
function c60150610.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60150610.ffilter,aux.FilterBoolFunction(c60150610.ffilter2),false)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c60150610.splimit)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c60150610.sprcon)
	e3:SetOperation(c60150610.sprop)
	c:RegisterEffect(e3)
	--atk up
	--local e5=Effect.CreateEffect(c)
	--e5:SetType(EFFECT_TYPE_SINGLE)
	--e5:SetCode(EFFECT_UPDATE_ATTACK)
	--e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e5:SetRange(LOCATION_MZONE)
	--e5:SetValue(c60150610.atkval)
	--c:RegisterEffect(e5)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(60150610,7))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCost(c60150610.cost)
	--e9:SetCondition(c60150610.decon)
	e9:SetTarget(c60150610.detg)
	e9:SetOperation(c60150610.deop)
	c:RegisterEffect(e9)
end
function c60150610.ffilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER)
end
function c60150610.ffilter2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) or c:IsHasEffect(60150618)
end
function c60150610.cfilter(c)
	return c:IsSetCard(0x3b21) and c:IsFaceup() and c:IsAbleToDeckOrExtraAsCost()
end
function c60150610.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150610.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c60150610.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local g2=g:Filter(c60150610.gfilter,nil)
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
function c60150610.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x3b21)
end
function c60150610.atkval(e,c)
	return Duel.GetMatchingGroupCount(c60150610.cfilter2,c:GetControler(),LOCATION_EXTRA,0,nil)*200
end
function c60150610.decon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c60150610.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c60150610.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150610.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c60150610.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150610.deop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c60150610.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local atk=g:GetFirst():GetBaseAttack()
		local atk2=g:GetFirst():GetAttack()*2
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		else
			Duel.Damage(1-tp,atk2,REASON_EFFECT)
		end
	end
end
function c60150610.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150610.spfilter1(c,tp,fc)
	return c:IsSetCard(0x3b21) and c:IsCanBeFusionMaterial(fc,true) and c:IsFaceup()  and c:IsAbleToDeckOrExtraAsCost() 
		and Duel.IsExistingMatchingCard(c60150610.spfilter2,tp,LOCATION_MZONE,0,1,c,fc) 
end
function c60150610.spfilter2(c,fc)
	return (c:IsAttribute(ATTRIBUTE_FIRE) or c:IsHasEffect(60150618)) and c:IsCanBeFusionMaterial(fc)
		and c:IsAbleToDeckOrExtraAsCost()
end
function c60150610.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b21)
end
function c60150610.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60150610.filter,tp,LOCATION_PZONE,0,nil)
	if g:GetCount()>0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c60150610.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
			and Duel.IsExistingMatchingCard(c60150610.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	end
end
function c60150610.gfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c60150610.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c60150610.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c60150610.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	c:SetMaterial(g1)
	local g=g1:Filter(c60150610.gfilter,nil)
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