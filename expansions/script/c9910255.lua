--幽鬼舞者 吾妻夜
function c9910255.initial_effect(c)
	c:EnableCounterPermit(0x956)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910255+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910255.spcon)
	e1:SetOperation(c9910255.spop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910255,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MSET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c9910255.ctcon1)
	e2:SetTarget(c9910255.cttg)
	e2:SetOperation(c9910255.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCondition(c9910255.ctcon2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c9910255.ctcon2)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_SSET)
	e5:SetCondition(c9910255.ctcon1)
	c:RegisterEffect(e5)
	--position
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9910255,1))
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCost(c9910255.setcost)
	e6:SetTarget(c9910255.settg)
	e6:SetOperation(c9910255.setop)
	c:RegisterEffect(e6)
end
function c9910255.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x956,2,REASON_COST)
end
function c9910255.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x956,2,REASON_COST)
end
function c9910255.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c9910255.cfilter(c,tp)
	return c:IsFacedown() and c:IsControler(tp)
end
function c9910255.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910255.cfilter,1,nil,tp)
end
function c9910255.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x956,2) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x956)
end
function c9910255.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x956,2)
	end
end
function c9910255.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x956,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x956,2,REASON_COST)
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
