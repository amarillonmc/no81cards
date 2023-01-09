--方舟骑士-陈
c29065508.named_with_Arknight=1
function c29065508.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x87af),6,2,c29065508.ovfilter,aux.Stringid(29065508,0),2,c29065508.xyzop)
	c:EnableReviveLimit()
	--Double attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065508,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(
		function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
			e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
		end
	)
	e3:SetTarget(c29065508.destg)
	e3:SetOperation(c29065508.desop)
	c:RegisterEffect(e3)
end
function c29065508.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065508.xyzop(e,tp,chk)
	if chk==0 then return (Duel.IsCanRemoveCounter(tp,1,0,0x10ae,2,REASON_COST) or (Duel.GetFlagEffect(tp,29096814)==1 and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,1,REASON_COST))) and Duel.GetFlagEffect(tp,29065508)==0 end
	if Duel.GetFlagEffect(tp,29096814)==1 then
	Duel.ResetFlagEffect(tp,29096814)
	Duel.RemoveCounter(tp,1,0,0x10ae,1,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065508,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	else
	Duel.RemoveCounter(tp,1,0,0x10ae,2,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065508,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
end
function c29065508.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c29065508.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)==0 then return end
		local ct=Duel.GetCurrentChain()
		if ct<2 then return end
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tep==1-tp and Duel.SelectYesNo(tp,aux.Stringid(29065508,3)) then
			Duel.BreakEffect()
			Duel.NegateActivation(ct-1)
		end
	end
end