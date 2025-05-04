--蕾宗忍法·回来吧！我心爱的手
function c22347141.initial_effect(c)
	--①：以自己墓地的至多6张「蕾宗忍法」魔法·陷阱卡为对象才能发动。那些卡回到卡组。那之后，可以让回去的卡每3张最多1张的场上的卡回到手卡。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22347141,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22347141+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22347141.target)
	e1:SetOperation(c22347141.activate)
	c:RegisterEffect(e1)
	--[[
②：这张卡从场上回到手卡的场合，直到回合结束得到以下效果。
●手卡的这张卡持续公开。
●这张卡可以在对方回合从手卡发动。
	]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c22347141.regcon)
	e2:SetOperation(c22347141.regop)
	c:RegisterEffect(e2)
end
function c22347141.tdfilter(c)
	return c:IsSetCard(0x3705) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c22347141.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22347141.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22347141.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c22347141.tdfilter,tp,LOCATION_GRAVE,0,1,6,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c22347141.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetsRelateToChain()
	local res=0
	if #sg==0 then return end
	res=Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=math.floor(og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)/3)
	if ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22347141,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	local c=e:GetHandler()
	local exc=nil
	if c:IsStatus(STATUS_LEAVE_CONFIRMED) then exc=c end
	local te=Duel.IsPlayerAffectedByEffect(tp,22347011)
	if c:IsSetCard(0x3705) and c:GetType(TYPE_SPELL) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and te and Duel.SelectYesNo(tp,Auxiliary.Stringid(22347011,1)) and c:IsRelateToEffect(e) and c:IsCanTurnSet()
	then
		if res>0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=Duel.SelectMatchingCard(tp,c22347141.lllfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,22347011)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function c22347141.lllfilter(c)
	return c:IsCode(22347011) and c:IsAbleToRemoveAsCost()
end

function c22347141.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c22347141.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--公开
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22347141,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	c:RegisterEffect(e1)
	--手发
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	e2:SetDescription(aux.Stringid(22347141,3))
	c:RegisterEffect(e2)
end