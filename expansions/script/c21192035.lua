--幻想时间 猫神的交易
local m=21192035
local cm=_G["c"..m]
local setcard=0x3917
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.q(c)
	return c:IsSetCard(setcard) and c:IsType(1) and c:IsAbleToHand()
end
function cm.w(c)
	return c:IsSetCard(setcard) and c:IsType(1) and c:IsAbleToRemove()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.q,tp,1,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.w,tp,1,0,1,nil)
	if chk==0 then return b1 or b2 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.q,tp,1,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.w,tp,1,0,1,nil)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0),0},{b2,aux.Stringid(m,1),1})
	if op==0 then
		Duel.Hint(3,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.q,tp,1,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif op==1 then
		Duel.Hint(3,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.w,tp,1,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.splimitcon)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.splimitcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)==0
end
function cm.splimit(e,c)
	return c:IsLevelBelow(3) and c:IsSetCard(setcard)
end