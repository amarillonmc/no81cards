--神造遗物解离剂 安布罗西亚
function c72409150.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,72409150+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c72409150.target)
	e1:SetOperation(c72409150.activate)
	c:RegisterEffect(e1)
end

function c72409150.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c72409150.filter(c,tp)
	return c:IsFaceup()  and c:IsSetCard(0xe729) and Card.GetEquipCount(c)~=0
end

function c72409150.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c72409150.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c72409150.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c72409150.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Card.GetEquipGroup(tc)
	if g~=0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then 
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
