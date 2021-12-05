local m=53711011
local cm=_G["c"..m]
cm.name="魔理沙役 sugar"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(53711009)
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(cm.cost)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function cm.thfilter(c)
	return c:IsSetCard(0x3538) and c:IsType(TYPE_MONSTER)
end
function cm.thfilter2(c)
	return cm.thfilter(c) and c:IsAbleToHand()
end
function cm.bxfilter(c)
	return cm.thfilter(c) and c:IsCanOverlay()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(m)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3538) and c:IsType(TYPE_XYZ)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	tg1=g:Filter(cm.thfilter2,nil)
	tg2=g:Filter(cm.bxfilter,nil)
	local bx=Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_MZONE,0,1,nil) and #tg2>0
	if #tg1>0 and bx then op=Duel.SelectOption(tp,1190,aux.Stringid(m,1))
	elseif #tg1>0 then op=0
	elseif bx then op=1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g1>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=Duel.SelectMatchingCard(tp,cm.bxfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g2>0 then
			local g3=Duel.SelectMatchingCard(tp,cm.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Overlay(g3:GetFirst(),g2)
		end
	end
end
