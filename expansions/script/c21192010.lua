--幻想时间 水叮铃魔女
local m=21192010
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
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.con2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
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
	if chk==0 then return Duel.GetFlagEffect(tp,m-10)<=2 and (b1 or b2) end
	Duel.RegisterFlagEffect(tp,m-10,RESET_PHASE+PHASE_END,0,1)
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
function cm.e(c)
	return c:IsSetCard(setcard) and c:IsAbleToHand() and c:IsType(6)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.r(c,tp)
	return c:IsSetCard(setcard) and c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.r,1,nil,tp)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then 
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end	
	end
end
function cm.t(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(setcard)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsAbleToDeck() and true
	local b2=Duel.IsExistingMatchingCard(cm.t,tp,4,0,1,nil) and c:IsAbleToHand()
	if chk==0 then return b1 or b2 end
	if b2 then
	e:SetCategory(e:GetCategory()+CATEGORY_TOHAND)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	local b1=c:IsAbleToDeck() and true
	local b2=Duel.IsExistingMatchingCard(cm.t,tp,4,0,1,nil) and c:IsAbleToHand()
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,2),0},{b2,aux.Stringid(m,3),1})
		if op==0 then
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		elseif op==1 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end	
	end
end