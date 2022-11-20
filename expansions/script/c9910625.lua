--破晓的魔王 艾莉尔
function c9910625.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910625.drtg)
	e1:SetOperation(c9910625.drop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c9910625.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
end
function c9910625.valcheck(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterialCount())
end
function c9910625.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and ct>0 and Duel.IsPlayerCanDraw(tp,ct)
		and (ct>3 or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,4-ct,nil,REASON_EFFECT)) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,4)
end
function c9910625.rafilter(c)
	return c:GetRace()~=0
end
function c9910625.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(tp)
		if Duel.DiscardHand(tp,nil,4,4,REASON_EFFECT+REASON_DISCARD)<4 then return end
		local og=Duel.GetOperatedGroup():Filter(c9910625.rafilter,nil)
		local ct=og:GetClassCount(Card.GetRace)
		local g1=Duel.GetMatchingGroup(c9910625.rafilter,tp,LOCATION_GRAVE,0,nil)
		if ct>=2 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910625,0)) then
			Duel.BreakEffect()
			local wbc=g1:GetFirst()
			local race=0
			while wbc do
				race=race|wbc:GetOriginalRace()
				wbc=g1:GetNext()
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_RACE)
			e1:SetValue(race)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
		if ct>=3 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910625,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g2:Select(tp,1,3,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
		if ct==4 and Duel.GetFlagEffect(tp,9910625)==0 and Duel.SelectYesNo(tp,aux.Stringid(9910625,2)) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetCondition(c9910625.discon)
			e1:SetOperation(c9910625.disop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,9910625,RESET_PHASE+PHASE_END,0,0)
		end
	end
end
function c9910625.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and (loc==LOCATION_HAND or loc==LOCATION_MZONE)
end
function c9910625.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
