--千夜 地狱看守者
function c60150615.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60150615.ffilter,aux.FilterBoolFunction(c60150615.ffilter2),false)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c60150615.splimit)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c60150615.sprcon)
	e3:SetOperation(c60150615.sprop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE,EFFECT_FLAG2_WICKED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c60150615.defval)
	c:RegisterEffect(e4)
	--at limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e6:SetTarget(c60150615.atlimit)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_MUST_ATTACK)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e7)
	--
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_ACTIVATE)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetTargetRange(0,1)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(1)
	e11:SetCondition(c60150615.actcon)
	c:RegisterEffect(e11)
	--indes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e9)
	--destroy2
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(60150615,5))
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetCost(c60150615.cost)
	e10:SetTarget(c60150615.target2)
	e10:SetOperation(c60150615.operation2)
	c:RegisterEffect(e10)
end
function c60150615.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c60150615.defvalf(c)
	return c:IsFaceup()
end
function c60150615.defval(e,c)
	local g=Duel.GetMatchingGroup(c60150615.defvalf,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then
		return e:GetHandler():GetBaseDefense()
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val
	end
end
function c60150615.ffilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) 
end
function c60150615.ffilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK) or c:IsHasEffect(60150618)
end
function c60150615.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150615.spfilter1(c,tp,fc)
	return c:IsSetCard(0x3b21) and c:IsCanBeFusionMaterial(fc,true) and c:IsFaceup() 
		and c:IsAbleToDeckOrExtraAsCost()
		and Duel.IsExistingMatchingCard(c60150615.spfilter2,tp,LOCATION_MZONE,0,1,c,fc) 
end
function c60150615.spfilter2(c,fc)
	return (c:IsAttribute(ATTRIBUTE_DARK) or c:IsHasEffect(60150618)) and c:IsCanBeFusionMaterial(fc)
		and c:IsAbleToDeckOrExtraAsCost() 
end
function c60150615.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b21)
end
function c60150615.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60150615.filter,tp,LOCATION_PZONE,0,nil)
	if g:GetCount()>0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c60150615.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
			and Duel.IsExistingMatchingCard(c60150615.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	end
end
function c60150615.gfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c60150615.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c60150615.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c60150615.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	c:SetMaterial(g1)
	local g=g1:Filter(c60150615.gfilter,nil)
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
function c60150615.efilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) then
			return te:GetOwner()~=e:GetHandler() and te:GetHandler():IsAttribute(ATTRIBUTE_DARK)
	end
	return false
end
function c60150615.atlimit(e,c)
	return c~=e:GetHandler()
end
function c60150615.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(60150615,1)) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_REPLACE+REASON_DISCARD)
		return true
	else return false end
end
function c60150615.filter2(c)
	local ct=c:GetFlagEffectLabel(60150615)
	return c:IsAbleToHand()
end
function c60150615.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c60150615.cfilter(c)
	return c:IsSetCard(0x3b21) and c:IsFaceup() and c:IsAbleToDeckOrExtraAsCost()
end
function c60150615.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150615.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c60150615.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local g2=g:Filter(c60150615.gfilter,nil)
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
function c60150615.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150615.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	--Pos Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_ATTACK)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	Duel.RegisterEffect(e3,tp)
end
function c60150615.check(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(60150615)
	if ct then
		tc:SetFlagEffectLabel(60150615,ct+1)
	else
		tc:RegisterFlagEffect(60150615,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c60150615.check2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(60150615)
	if ct then
		tc:SetFlagEffectLabel(60150615,ct-1)
	end
end