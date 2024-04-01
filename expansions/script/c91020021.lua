--真神使者 灵光麒麟l
local m=91020021
local cm=c91020021
function c91020021.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEDOWN_DEFENSE,0)   
	e1:SetCountLimit(1,m*3)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(cm.tg2)
	e2:SetCountLimit(1,m)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,m*2)
	e5:SetCost(aux.bfgcost)
	e5:SetCondition(cm.condition)
	e5:SetTarget(cm.tag5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5) 
	Duel.AddCustomActivityCounter(91020021,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return c:IsSetCard(0x9d0) or c:IsSetCard(0x9d1) or  c:IsRace(RACE_DIVINE) 
end
--e1
function cm.tag(e,c)
return not (c:IsSetCard(0x9d0) or c:IsSetCard(0x9d1) or  c:IsRace(RACE_DIVINE))
end
function cm.con1(e,c)
if c==nil then return true end  
return  Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetCustomActivityCount(91020021,tp,ACTIVITY_SPSUMMON)==0 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return true end
 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.tag)
	Duel.RegisterEffect(e1,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	Duel.ConfirmCards(1-tp,c)
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
end
--e5
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
 return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,nil,RACE_DIVINE)
end
function cm.filter(c)
	return c:IsAbleToDeck()
end
function cm.tag5(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end
function cm.fit2(c,e)
return  c:IsAbleToHand()
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
local g1=g:Select(tp,3,3,nil)
	if g:IsExists(cm.fit2,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	local g2=g1:FilterSelect(tp,cm.fit2,1,1,nil)
	Duel.SendtoHand(g2,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g2)
	g1:Sub(g2)
	end
	Duel.SendtoDeck(g1,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

