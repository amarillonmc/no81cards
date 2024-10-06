--芳青之梦 水彩笔
function c21113815.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xc914),1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e0:SetCondition(c21113815.discon)
	c:RegisterEffect(e0)	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,21113815)
	e1:SetCost(c21113815.cost)
	e1:SetTarget(c21113815.tg)
	e1:SetOperation(c21113815.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21113816)
	e2:SetCondition(c21113815.con2)
	e2:SetCost(c21113815.cost2)
	e2:SetTarget(c21113815.tg2)
	e2:SetOperation(c21113815.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHAIN_DISABLED)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCost(c21113815.cost5)
	e5:SetOperation(c21113815.op5)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(21113815,ACTIVITY_SPSUMMON,c21113815.counter)	
end
function c21113815.counter(c)
	return c:IsSetCard(0xc914)
end
function c21113815.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113815.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113815.opq)
	Duel.RegisterEffect(e1,tp)
end
function c21113815.q(c)
	return c:IsAbleToHand() and c:IsType(6) and c:IsSetCard(0xc914)
end
function c21113815.opq(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113815)==0 and Duel.IsExistingMatchingCard(c21113815.q,tp,1,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21113815,0)) then
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21113815.q,tp,1,0,1,1,nil)
		if #g>0 then 
		Duel.SendtoHand(g,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,g)
		end
	end
	Duel.ResetFlagEffect(tp,21113815)
	e:Reset()
end
function c21113815.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,12,12,1,nil) and Duel.GetLocationCount(tp,4)>0 end
	Duel.Hint(3,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,12,12,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c21113815.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113815,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then 
	Duel.Destroy(g,REASON_EFFECT)
	end
end
function c21113815.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp 
end
function c21113815.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113815.opw)
	Duel.RegisterEffect(e1,tp)
end
function c21113815.opw(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113815+1)==0 and Duel.SelectYesNo(tp,aux.Stringid(21113815,1)) then
	Duel.Damage(1-tp,1500,REASON_RULE)
	end
	Duel.ResetFlagEffect(tp,21113815+1)
	e:Reset()
end
function c21113815.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function c21113815.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113815+1,RESET_PHASE+PHASE_END,0,1)
	Duel.Recover(tp,1500,REASON_EFFECT)
end
function c21113815.cost5(e,c,tp)
	return Duel.GetCustomActivityCount(21113815,tp,ACTIVITY_SPSUMMON)==0
end
function c21113815.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113815.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c21113815.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end