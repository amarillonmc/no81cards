--始祖岭岩龙皇
function c9910643.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910643)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c9910643.rmcost)
	e1:SetTarget(c9910643.rmtg)
	e1:SetOperation(c9910643.rmop)
	c:RegisterEffect(e1)
end
function c9910643.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910643.rafilter(c,res)
	return c:GetRace()~=0 and (res or c:IsLocation(LOCATION_REMOVED))
end
function c9910643.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9910643.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	local dg=Duel.GetMatchingGroup(c9910643.disfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>=4 and g:IsExists(c9910643.rafilter,1,nil,true) and #dg>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,4,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,1,0,0)
end
function c9910643.fselect(g)
	return g:IsExists(c9910643.rafilter,1,nil,true)
end
function c9910643.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if #g>=4 and g:IsExists(c9910643.rafilter,1,nil,true) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:SelectSubGroup(tp,c9910643.fselect,false,4,4)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup():Filter(c9910643.rafilter,nil,false)
		local ct=og:GetClassCount(Card.GetRace)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local dg=Duel.SelectMatchingCard(tp,c9910643.disfilter,tp,0,LOCATION_MZONE,1,ct,nil)
		Duel.HintSelection(dg)
		local tc=dg:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-600)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetValue(RESET_TURN_SET)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
			tc=dg:GetNext()
		end
	end
	c:RegisterFlagEffect(9910643,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetLabelObject(c)
	e5:SetCondition(c9910643.spcon)
	e5:SetOperation(c9910643.spop)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function c9910643.spfilter(c,e,tp)
	return c:IsRank(12) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910643.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910643.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c9910643.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910643.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
		and c:GetFlagEffect(9910643)~=0 and c:IsCanOverlay() and not tc:IsImmuneToEffect(e) then
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
