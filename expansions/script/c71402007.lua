--重音俄罗斯方块
if not c71403001 then dofile("expansions/script/c71403001.lua") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--set from GY
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.filter1(c,tp)
	return c:GetSequence()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() or tc:GetSequence()<5 or tc:IsImmuneToEffect(e) or not tc:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then
		yume.RegPPTCostLimit(e,tp)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=tc:GetSequence()
	Duel.MoveSequence(tc,seq)
	yume.RegPPTCostLimit(e,tp)
	yume.OptionalPendulum(e,e:GetHandler(),tp)
end
function s.filter2(c)
	return c:GetSequence()>=5 and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.filter2toex(c)
	return c:IsType(TYPE_PENDULUM)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_PENDULUM)
	if chk==0 then return e:GetHandler():IsSSetable() and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,tp,LOCATION_HAND)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SSet(tp,c)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_PENDULUM)
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end