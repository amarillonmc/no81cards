--方舟骑士-刻俄柏
function c29032490.initial_effect(c)
	aux.AddCodeList(c,29065532)
   c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29032490,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29032490)
	e1:SetCost(c29032490.tkco)
	e1:SetTarget(c29032490.tktg)
	e1:SetOperation(c29032490.tkop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29032490,2))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,29032491)
	e2:SetTarget(c29032490.target)
	e2:SetOperation(c29032490.operation)
	c:RegisterEffect(e2)
end
c29032490.kinkuaoi_Akscsst=true
function c29032490.rfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function c29032490.nbfilter(c)
	return c:IsFaceup() and aux.NegateAnyFilter(c)
end
function c29032490.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c29032490.nbfilter,tp,0,LOCATION_ONFIELD,1,c) and Duel.IsExistingMatchingCard(c29032490.refilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(c29032490.nbfilter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c29032490.refilter(c,tp)
	return c:IsType(TYPE_TOKEN) and c:IsReleasableByEffect()
end
function c29032490.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.SelectMatchingCard(tp,c29032490.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.Release(rg,REASON_EFFECT)>0 then
		if Duel.IsExistingMatchingCard(c29032490.nbfilter,tp,0,LOCATION_ONFIELD,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local g=Duel.SelectMatchingCard(tp,c29032490.nbfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c29032490.tkco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c29032490.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29032491,0,TYPES_TOKEN_MONSTER,1000,1000,3,RACE_WARRIOR,ATTRIBUTE_EARTH) end   if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c29032490.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,29032491,0,TYPES_TOKEN_MONSTER,1000,1000,3,RACE_WARRIOR,ATTRIBUTE_EARTH) then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	for i=1,3 do
		local token=Duel.CreateToken(tp,29032490+i)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			token:RegisterEffect(e3,true)
		end
end