local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,53761005)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,id)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,id)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function s.spfilter(c,e,tp)
	return aux.IsCodeListed(c,53761005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	local b2=c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local sel=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)},{b1 and b2,aux.Stringid(id,3)})
	if sel==1 then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_MZONE)
	elseif sel==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	elseif sel==3 then
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
	e:SetLabel(sel)
end
function s.mvfilter(c,tp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	return c:IsControler(1-tp) and (c:GetSequence()<5 or ft>1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local res
	if e:GetLabel()~=2 then
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,2,nil)
		for tc in aux.Next(g) do
			res=true
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
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
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			tc:RegisterEffect(e3)
			Duel.AdjustInstantly(c)
		end
		if res and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			local sg=g:Filter(s.mvfilter,nil,tp)
			local sg1=sg:Clone()
			if #sg>1 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
				sg1=sg:Select(tp,1,1,nil)
			end
			if #sg1>0 then
				Duel.HintSelection(sg1)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
				local s1=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
				local nseq1=math.log(bit.rshift(s1,16),2)
				Duel.MoveSequence(sg1:GetFirst(),nseq1)
				local sg2=Group.__sub(sg,sg1)
				if #sg2>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 then
					Duel.HintSelection(sg2)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
					local s2=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
					local nseq2=math.log(bit.rshift(s2,16),2)
					Duel.MoveSequence(sg2:GetFirst(),nseq2)
				end
			end
		end
	end
	if e:GetLabel()~=1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if res then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end
