--Fortitudo
function c63790501.initial_effect(c)
	 c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x638),LOCATION_MZONE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,63790501+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c63790501.spcon)
	c:RegisterEffect(e1)
	--Destory
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c63790501.target)
	e2:SetOperation(c63790501.operation)
	c:RegisterEffect(e2)
   --return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(63790501,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c63790501.rettg)
	e3:SetOperation(c63790501.retop)
	c:RegisterEffect(e3)
end
function c63790501.cfilter(c)
	return c:IsSetCard(0x637) and c:IsType(TYPE_MONSTER)
end
function c63790501.spcon(e,c)
if c==nil then return true end
	return Duel.IsExistingMatchingCard(c63790501.cfilter,tp,LOCATION_GRAVE,0,1,nil)
 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c63790501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c63790501.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c63790501.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c63790501.retop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end