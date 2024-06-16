--雪狱之罪哀 永不止息
function c9911391.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911391)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(c9911391.condition)
	e1:SetCost(c9911391.cost)
	e1:SetTarget(c9911391.target)
	e1:SetOperation(c9911391.activate)
	c:RegisterEffect(e1)
	--detach
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911392)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911391.dtcon)
	e2:SetCost(c9911391.dtcost)
	e2:SetTarget(c9911391.dttg)
	e2:SetOperation(c9911391.dtop)
	c:RegisterEffect(e2)
end
function c9911391.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9911391.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c9911391.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsPlayerCanDraw(tp,1) and #g>=3
	end
	local op=0
	if Duel.IsPlayerCanDraw(tp,2) and #g>=6 then
		op=Duel.SelectOption(tp,aux.Stringid(9911391,0),aux.Stringid(9911391,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911391,0))
	end
	Duel.DisableShuffleCheck()
	local rg=Duel.GetDecktopGroup(tp,4+op*4)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	e:SetLabel(op+1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,op+1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9911391.activate(e,tp,eg,ep,ev,re,r,rp)
	
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,9911392,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911391.dtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911392)==0
end
function c9911391.dtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9911391.dtfilter(c)
	return c:IsPublic() and c:IsDiscardable(REASON_EFFECT)
end
function c9911391.dttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
end
function c9911391.dtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,1,1,nil,tp,1,REASON_EFFECT)
	if #sg>0 then
		Duel.HintSelection(sg)
		sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(8)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e1,tp)
end
