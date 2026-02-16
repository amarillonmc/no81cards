local m=15006202
local cm=_G["c"..m]
cm.name="遥远星河之歌"
function cm.initial_effect(c)
	aux.AddCodeList(c,15006200,15006202)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e0:SetOperation(cm.activate)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.atkval)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.descon)
	e5:SetCost(cm.descost)
	e5:SetTarget(cm.destg)
	e5:SetOperation(cm.desop)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(cm.eftg)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	--change type
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_ADD_TYPE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(cm.eftg)
	e7:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_REMOVE_TYPE)
	e8:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e8)
end
function cm.thfilter(c)
	return c:IsCode(15006200) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.eftg(e,c)
	return c:IsSetCard(0x9f44) and c:IsType(TYPE_MONSTER)
end
function cm.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD)*100
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.costfilter(c,tp)
	return c:IsFaceup() and c:IsCode(15006202) and c:IsAbleToHandAsCost()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
end