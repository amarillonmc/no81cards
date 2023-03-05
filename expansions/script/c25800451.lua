--武装舰-主炮切换
local m=25800451
local cm=_G["c"..m]

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	  local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(2,m)
	e2:SetTarget(cm.destg2)
	e2:SetOperation(cm.desop2)
	c:RegisterEffect(e2)

end
---2
function cm.filter2(c)
	return  (c:IsSetCard(0x3212) or c:IsCode(25800150)) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_PZONE,0,1,nil) and 
	 Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
	local c=e:GetHandler()
	local fc=g:GetFirst()
	if fc and Duel.MoveToField(fc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) and c:IsFaceup() and c:IsRelateToEffect(e) then
	end
	end
end



