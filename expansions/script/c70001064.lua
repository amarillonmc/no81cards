--终结者
local m=70001064
local cm=_G["c"..m]
function cm.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.dcon)
	e1:SetOperation(cm.dop)
	c:RegisterEffect(e1)
	--reborn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
	function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0
end
	function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
	function cm.damval(e,re,val,r,rp,rc)
	return math.floor(val*0.03)
end
	function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp))
		and c:IsPreviousPosition(POS_FACEUP)
end
	function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	Duel.SetLP(tp,9000)
	end
end
	function cm.filter(c)
	return c:IsFaceup() and c:IsCode(70001066)
end
	function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),LOCATION_MZONE,0,1,nil) then
	local tc=Duel.CreateToken(tp,m)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
	local tc2=Duel.CreateToken(tp,70001065)
	Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end