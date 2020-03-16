--幽鬼舞者 吾妻夜
function c9910255.initial_effect(c)
	c:EnableCounterPermit(0x953)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910255)
	e1:SetCondition(c9910255.spcon)
	e1:SetOperation(c9910255.spop)
	c:RegisterEffect(e1)
	--add counter or set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SSET)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910255.ctcon)
	e2:SetTarget(c9910255.cttg)
	e2:SetOperation(c9910255.ctop)
	c:RegisterEffect(e2)
	--position
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c9910255.setcon)
	e3:SetCost(c9910255.setcost)
	e3:SetTarget(c9910255.settg)
	e3:SetOperation(c9910255.setop)
	c:RegisterEffect(e3)
end
function c9910255.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x953,2,REASON_COST)
end
function c9910255.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x953,2,REASON_COST)
end
function c9910255.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and eg:IsExists(Card.IsControler,1,nil,tp)
end
function c9910255.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x953,2) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x953)
end
function c9910255.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x953,2)
	end
end
function c9910255.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9910255.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x953,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x953,2,REASON_COST)
end
function c9910255.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c9910255.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910255.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910255.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c9910255.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c9910255.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
