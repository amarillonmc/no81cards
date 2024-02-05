--恋慕屋敷的琴师
function c9911078.initial_effect(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9911078)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9911078.poscost)
	e1:SetTarget(c9911078.postg)
	e1:SetOperation(c9911078.posop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,9911079)
	e2:SetTarget(c9911078.sptg)
	e2:SetOperation(c9911078.spop)
	c:RegisterEffect(e2)
end
function c9911078.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9911078.costfilter(c,tp,mc)
	if not c:IsAbleToGraveAsCost() then return false end
	local g=Group.FromCards(c,mc)
	if Duel.IsExistingMatchingCard(c9911078.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,g) then return true end
	local ct1=Duel.GetCounter(tp,1,0,0x1954)-c:GetCounter(0x1954)
	local ct2=Duel.GetCounter(tp,0,1,0x1954)
	return (ct1>ct2 and Duel.GetDecktopGroup(tp,ct1-ct2):FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==ct1-ct2)
		or (ct1<ct2 and Duel.GetDecktopGroup(1-tp,ct2-ct1):FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==ct2-ct1)
end
function c9911078.posfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and c:IsCanTurnSet()
end
function c9911078.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct1=Duel.GetCounter(tp,1,0,0x1954)
	local ct2=Duel.GetCounter(tp,0,1,0x1954)
	local res=(ct1>ct2 and Duel.GetDecktopGroup(tp,ct1-ct2):FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==ct1-ct2)
		or (ct1<ct2 and Duel.GetDecktopGroup(1-tp,ct2-ct1):FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==ct2-ct1)
	if chk==0 then
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c9911078.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp,c)
		else
			return res or Duel.IsExistingMatchingCard(c9911078.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9911078.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp,c)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c9911078.posop(e,tp,eg,ep,ev,re,r,rp)
	local chk
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9911078.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
		chk=true
	end
	local ct1=Duel.GetCounter(tp,1,0,0x1954)
	local ct2=Duel.GetCounter(tp,0,1,0x1954)
	if ct1>ct2 then
		local dg1=Duel.GetDecktopGroup(tp,ct1-ct2)
		if #dg1>0 then
			if chk then Duel.BreakEffect() end
			Duel.DisableShuffleCheck()
			Duel.Remove(dg1,POS_FACEDOWN,REASON_EFFECT)
		end
	elseif ct1<ct2 then
		local dg2=Duel.GetDecktopGroup(1-tp,ct2-ct1)
		if #dg2>0 then
			if chk then Duel.BreakEffect() end
			Duel.DisableShuffleCheck()
			Duel.Remove(dg2,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c9911078.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911078.addfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsCanAddCounter(0x1954,2)
end
function c9911078.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		local sg=Group.FromCards(c)
		local g=Duel.GetMatchingGroup(c9911078.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			sg:AddCard(tc)
		end
		if #sg==0 then return end
		Duel.BreakEffect()
		for sc in aux.Next(sg) do
			sc:AddCounter(0x1954,2)
		end
	end
end
