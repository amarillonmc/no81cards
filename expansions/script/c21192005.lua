--幻想时间 踏青童谣
local m=21192005
local cm=_G["c"..m]
local setcard=0x3917
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)	
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.con2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m+2)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.q(c)
	return c:IsSetCard(setcard) and c:IsAbleToRemoveAsCost() and not c:IsCode(m) and c:IsType(1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
	local b2=Duel.IsExistingMatchingCard(cm.q,tp,1,0,1,nil) and Duel.GetFieldGroupCount(tp,0,4)>0
	if chk==0 then return Duel.GetFlagEffect(tp,m-5)<=2 and (b1 or b2) end
	Duel.RegisterFlagEffect(tp,m-5,RESET_PHASE+PHASE_END,0,1)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0),0},{b2,aux.Stringid(m,1),1})
	if op==0 then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
	elseif op==1 then
		Duel.Hint(3,tp,HINTMSG_REMOVE)
		local g=Duel.GetMatchingGroup(cm.q,tp,1,0,nil):Select(tp,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end		
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.w(c,e,tp)
	return c:IsSetCard(setcard) and c:GetOriginalType()&TYPE_MONSTER>0 and c:GetType()&TYPE_CONTINUOUS+TYPE_TRAP==TYPE_CONTINUOUS+TYPE_TRAP and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and Duel.IsExistingTarget(cm.w,tp,8,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,cm.w,tp,8,0,1,1,nil,e,tp)	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.e(c)
	return c:IsSetCard(setcard) and c:IsFaceup()
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(cm.e,tp,4,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_FACEUP)	
	Duel.SelectTarget(tp,cm.e,tp,4,0,1,1,nil)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
	end
end