--极简抗压
function c65850085.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c65850085.excondition)
	e0:SetDescription(aux.Stringid(65850085,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65850085+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65850085.sptg)
	e1:SetOperation(c65850085.spop)
	c:RegisterEffect(e1)
end

function c65850085.cfilter(c)
	return c:IsSetCard(0xa35) and c:IsFaceup()
end
function c65850085.excondition(e)
	local ct=Duel.GetCurrentChain()
	if not (ct and ct>0) then return end
	local rp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER)
	local tp=e:GetHandlerPlayer()
	return rp~=tp and (Duel.IsExistingMatchingCard(c65850085.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
end

function c65850085.filter1(c)
	return c:IsSetCard(0xa35) and c:IsAbleToRemove() and aux.NecroValleyFilter()
end
function c65850085.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c65850085.filter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c65850085.spop(e,tp,eg,ep,ev,re,r,rp)
	--limit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65850085.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c65850085.filter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local cg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if cg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=cg:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
				if g:GetFirst():IsType(TYPE_LINK) then
		local tc=sg:GetFirst()
		if not tc then return end
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
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
		end
		Duel.Destroy(sg,REASON_EFFECT)
		local g1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		local g2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		if g1<=g2 and Duel.SelectYesNo(tp,aux.Stringid(65850085,1)) then
			Duel.BreakEffect()
			local g3=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			Duel.Destroy(g3:RandomSelect(tp,1),REASON_EFFECT)
		end
				end
			end
		end
	end
end
function c65850085.splimit(e,c)
	return not c:IsSetCard(0xa35)
end