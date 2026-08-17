--方舟骑士-刻俄柏
local s,id,o=GetID()
s.kinkuaoi_Akscsst=true
function s.initial_effect(c)
	aux.AddCodeList(c,29065532,29032491)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--damege
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	--des
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+1)
	e3:SetCost(s.negcost)
	e3:SetTarget(s.negtg)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29032491,0,TYPES_TOKEN_MONSTER,0,0,5,RACE_WARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),3)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,29032491,0,TYPES_TOKEN_MONSTER,0,0,5,RACE_WARRIOR,ATTRIBUTE_EARTH) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local num={}
	for i=1,ft do
		num[i]=i
	end
	local count=1
	if ft>1 then
		count=Duel.AnnounceNumber(tp,table.unpack(num))
	end
	for i=1,count do
		local token=Duel.CreateToken(tp,id+1)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			token:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e3,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:IsType(TYPE_MONSTER) then
		local def=bc:GetDefense()
		if def then
			if def<0 then def=0 end
			Duel.Damage(1-tp,def,REASON_EFFECT)
		end
	end
end
function s.excostfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(29088383,tp)
end
function s.costfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_MZONE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(s.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	if #g2>0 then g:AddCard(g2) end
	if chk==0 then return #g>0 end
	local tc
	if #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29088383,0))
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	local te=tc:IsHasEffect(29088383,tp)
	if te then
		Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_REPLACE)
	else
		Duel.Release(tc,REASON_COST)
	end
end
function s.nbfilter(c)
	return c:IsFaceup() and aux.NegateAnyFilter(c)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.nbfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,s.nbfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.HintSelection(g)
		if tc:IsCanBeDisabledByEffect(e) then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
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