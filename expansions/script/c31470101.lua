local m=31470101
local cm=_G["c"..m]
cm.name="特洛伊群的隐喻林"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(cm.lvlcost)
	e2:SetTarget(cm.lvltg)
	e2:SetOperation(cm.lvlop)
	c:RegisterEffect(e2)
end
function cm.actfilter(c,e)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x3312) and c:IsSummonable(true,e)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.GetMatchingGroup(cm.actfilter,tp,LOCATION_HAND,0,nil,e)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(31470101,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Summon(tp,sg:GetFirst(),true,e)
	end
end
function cm.lvlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function cm.lvlfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x3312) and c:IsFaceup()
end
function cm.lvltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.lvlfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.lvlfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.lvlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end