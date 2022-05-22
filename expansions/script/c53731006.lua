local m=53731006
local cm=_G["c"..m]
cm.name="狂喑深星 哈斯忒"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.thcost)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return r&REASON_EFFECT~=0 end)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
end
function cm.costfilter(c)
	return c:IsSetCard(0x9533) and c:IsLevelAbove(3) and not c:IsPublic()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	g:GetFirst():CreateEffectRelation(e)
	e:SetLabelObject(g:GetFirst())
end
function cm.thfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(3) and c:IsAbleToHand()
end
function cm.lvplus(c)
	if c:IsType(TYPE_NORMAL) then return c:GetLevel()-3 else return c:GetLevel() end
end
function cm.fselect(g,lv,tp)
	return g:GetSum(Card.GetLevel)<=lv and aux.dncheck(g)
end
function cm.hspcheck(g,lv,tp)
	Duel.SetSelectedCard(g)
	return g:CheckSubGroup(cm.fselect,1,#g,lv,tp)
end
function cm.hspgcheck(g,c,mg,f,min,max,ext_params)
	local lv,tp=table.unpack(ext_params)
	if g:GetSum(cm.lvplus)<=lv then return true end
	Duel.SetSelectedCard(g)
	return g:CheckSubGroup(cm.fselect,1,#g,lv,tp)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local op,ct,tc=0,0,e:GetLabelObject()
	local res=false
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,0,nil)
	if tc:IsRelateToEffect(e) then
		aux.GCheckAdditional=cm.hspgcheck
		local hastur=g:CheckSubGroup(cm.hspcheck,1,3,cm.lvplus(tc),tp)
		aux.GCheckAdditional=nil
		if hastur then res=true end
	end
	if res then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) else op=Duel.SelectOption(tp,aux.Stringid(m,1)) end
	if op==0 then ct=3 else ct=-3 end
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(function(c)return c:IsLevelAbove(1) and c:IsType(TYPE_NORMAL)end,tp,LOCATION_HAND,0,nil)
	cm.lvop(hg,c,ct)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) cm.lvop(eg:Filter(function(c)return c:IsLevelAbove(1) and c:IsType(TYPE_NORMAL)end,nil),c,ct) end)
	Duel.RegisterEffect(e2,tp)
	if op==0 then return end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	aux.GCheckAdditional=cm.hspgcheck
	local sg=g:SelectSubGroup(tp,cm.hspcheck,false,1,3,tc:GetLevel(),tp)
	aux.GCheckAdditional=nil
	if #sg>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function cm.lvop(g,c,ct)
	for lvc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		lvc:RegisterEffect(e1)
	end
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
