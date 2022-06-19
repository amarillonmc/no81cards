local m=31400101
local cm=_G["c"..m]
cm.name="与凭依的接触"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetCondition(cm.actcon)
	e1:SetOperation(cm.actop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(aux.dscon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.tg1)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetTarget(cm.tg2)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetCondition(cm.con2)
	e7:SetValue(aux.tgoval)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(cm.con1)
	e8:SetValue(aux.indoval)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetRange(LOCATION_SZONE)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCountLimit(1)
	e9:SetTarget(cm.cttg)
	e9:SetOperation(cm.ctop)
	c:RegisterEffect(e9)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 and not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()==0 and cm.actcost(tp,0)
end
function cm.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbf)
end
function cm.cfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function cm.actcost(tp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil):Filter(Card.IsFaceup,nil)
	if chk==0 then return g:FilterCount(cm.cfilter1,nil)>0 and g:FilterCount(cm.cfilter2,nil)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=g:Filter(cm.cfilter1,nil):Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	cg:Merge(g:Filter(cm.cfilter2,nil):Select(tp,1,1,nil))
	Duel.SendtoGrave(cg,REASON_COST)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	cm.actcost(tp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.tg1(e,c)
	return (c:IsSetCard(0xc0) or c:IsCode(52860176)) and c:IsFaceup()
end
function cm.tg2(e,c)
	return c:IsSetCard(0xbf) and c:IsFaceup()
end
function cm.con1(e)
	return Duel.GetMatchingGroupCount(cm.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>0
end
function cm.con2(e)
	return Duel.GetMatchingGroupCount(cm.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>0
end
function cm.cttgfilter(c)
	return c:IsSetCard(0x10c0,0xbf) and c:IsFaceup() and Duel.GetMatchingGroupCount(cm.ctopfilter,c:GetOwner(),0,LOCATION_MZONE,nil,c)>0
end
function cm.ctopfilter(c,tc)
	return bit.band(c:GetAttribute(),tc:GetAttribute())~=0 and c:IsFaceup()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.cttgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cttgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.cttgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local ctc=Duel.SelectMatchingCard(tp,cm.ctopfilter,tp,0,LOCATION_MZONE,1,1,nil,tc):GetFirst()
	if not ctc or ctc:IsImmuneToEffect(e) then return end
	tc:SetCardTarget(ctc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_CONTROL)
	e1:SetValue(tp)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCondition(cm.ctcon)
	e1:SetLabelObject(tc)
	ctc:RegisterEffect(e1)
end
function cm.ctcon(e)
	local c=e:GetLabelObject()
	local h=e:GetHandler()
	return c:IsHasCardTarget(h)
end