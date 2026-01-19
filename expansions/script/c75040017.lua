--器者百式-贯射连矢
function c75040017.initial_effect(c)
	aux.AddCodeList(c,75040001)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75040017,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c75040017.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c75040017.target)
	e1:SetOperation(c75040017.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75040017.thtg)
	e2:SetOperation(c75040017.thop)
	c:RegisterEffect(e2)
end
function c75040017.hcfilter(c)
	return c:IsCode(75040001) and c:IsFaceup()
end
function c75040017.handcon(e)
	return Duel.IsExistingMatchingCard(c75040017.hcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c75040017.tfilter(c,e,tp)
	return (c:IsControler(1-tp) or c:IsRace(RACE_WYRM) and c:IsAbleToRemove()) and c:IsCanBeEffectTarget(e) and c:IsFaceup()
end
function c75040017.gcheck(sg)
	return sg:FilterCount(Card.IsControler,nil,1)==1
end
function c75040017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c75040017.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c75040017.gcheck,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c75040017.gcheck,false,2,2)
	Duel.SetTargetCard(sg)
end
function c75040017.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_M1)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>=PHASE_MAIN1 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c75040013.skipcon)
			e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
	local g=Duel.GetTargetsRelateToChain()
	local rc=g:Filter(Card.IsControler,nil,tp):GetFirst()
	local ac=g:Filter(Card.IsControler,nil,1-tp):GetFirst()
	if rc and Duel.Remove(rc,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetLabelObject(rc)
		e0:SetCountLimit(1)
		e0:SetOperation(c75040017.retop)
		Duel.RegisterEffect(e0,tp)
	end
	if ac and ac:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetValue(ac:GetBaseAttack()*(-1))
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function c75040017.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c75040017.tgfilter(c)
	return aux.IsCodeListed(c,75040001) and c:IsFaceupEx() and c:IsAbleToHand() and c:IsAbleToDeck()
end
function c75040017.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x30) and chkc:IsControler(tp) and c75040017.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75040017.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c75040017.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g-1,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c75040017.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	g:Sub(sg)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
