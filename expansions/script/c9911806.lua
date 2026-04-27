--若渴烬灵
function c9911806.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911806)
	e1:SetCondition(c9911806.spcon)
	e1:SetTarget(c9911806.sptg)
	e1:SetOperation(c9911806.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9911806.reptg)
	e2:SetOperation(c9911806.repop)
	c:RegisterEffect(e2)
	--destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c9911806.dedcon)
	e3:SetTarget(c9911806.dedtg)
	e3:SetOperation(c9911806.dedop)
	c:RegisterEffect(e3)
end
function c9911806.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c9911806.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911806.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9911806,0xa957,TYPE_MONSTER+TYPE_EFFECT,1600,200,3,RACE_PYRO,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(c9911806.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_SZONE)
end
function c9911806.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911806.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911806.desfilter(c,e)
	return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c9911806.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetFlagEffect(tp,9911806)==0 and Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.GetFlagEffect(tp,9911807)==0 and Duel.IsExistingMatchingCard(c9911806.desfilter,tp,0,LOCATION_MZONE,1,nil,e)
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and (b1 or b2) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_CARD,0,9911806)
		local op=0
		op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911806,0),1},{b2,aux.Stringid(9911806,1),2})
		e:SetLabel(op)
		if op==1 then
			Duel.RegisterFlagEffect(tp,9911806,RESET_PHASE+PHASE_END,0,1)
			if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
				Duel.ShuffleHand(tp)
				Duel.Destroy(sg,REASON_EFFECT+REASON_REPLACE)
			end
		elseif op==2 then
			Duel.RegisterFlagEffect(tp,9911807,RESET_PHASE+PHASE_END,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local g=Duel.SelectMatchingCard(tp,c9911806.desfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
			e:SetLabelObject(g:GetFirst())
			g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		end
		return true
	else return false end
end
function c9911806.repop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=2 then return end
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c9911806.dedcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c9911806.dedtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,9911806)==0 and Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.GetFlagEffect(tp,9911807)==0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911806,0),1},{b2,aux.Stringid(9911806,1),2})
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.RegisterFlagEffect(tp,9911806,RESET_PHASE+PHASE_END,0,1)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(0)
		Duel.RegisterFlagEffect(tp,9911807,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c9911806.dedop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Draw(p,d,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(p,nil,p,LOCATION_HAND,0,1,1,nil)
			Duel.ShuffleHand(p)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
