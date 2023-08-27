--御器屋
local m=49811166
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.drcost)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.chtg1)
	e4:SetOperation(cm.chop1)
	c:RegisterEffect(e4)
	
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(cm.cost)
	e5:SetTarget(cm.chtg2)
	e5:SetOperation(cm.chop2)
	c:RegisterEffect(e5)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return tp~=Duel.GetTurnPlayer() and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end

function cm.backgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and c:IsAbleToGrave()
end

function cm.chtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.backgfilter,tp,LOCATION_REMOVED,0,1,nil) end
end

function cm.chop1(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(cm.backgfilter,tp,LOCATION_REMOVED,0,nil)
	if bc>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:Select(tp,1,bc,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
	end
end

function cm.backhfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and c:IsAbleToHand()
end

function cm.chtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.backhfilter,tp,LOCATION_REMOVED,0,1,nil) end
end
function cm.chop2(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(cm.backhfilter,tp,LOCATION_REMOVED,0,nil)
	if bc>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=g:Select(tp,1,bc,nil)
		Duel.SendtoHand(tg,REASON_EFFECT)
	end
end

function cm.chainfilter(re,tp,cid)
	local c=re:GetHandler()
	return not (c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_EARTH) and re:IsActiveType(TYPE_MONSTER))
end

function cm.handcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return (Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)~=0)
end

function cm.drfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.drfilter2,tp,LOCATION_DECK,0,1,nil,c)
end

function cm.drfilter2(c,tc)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_EARTH) and c:GetCode()~=tc:GetCode() and c:IsLevelBelow(tc:GetLevel()) and c:IsAbleToHand()
end

function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.drfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabelObject(tc)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc==nil then return end
	local g=Duel.GetMatchingGroup(cm.drfilter2,tp,LOCATION_DECK,0,nil,tc)
	if g and g:GetCount()>0 then
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(sc,tp,REASON_EFFECT)
	end
end