--真神使者 灵光麒麟l
local m=91020021
local cm=c91020021
function c91020021.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m*3)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_FLIP)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(cm.tg2)
	e2:SetCountLimit(1,m)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FLIP)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.flipop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m*2)
	e5:SetCondition(cm.condition)
	e5:SetTarget(cm.tag5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5) 
	Duel.AddCustomActivityCounter(91020021,ACTIVITY_SPSUMMON,cm.counterfilter)
end
--e1
function cm.counterfilter(c)
	return  c:IsSetCard(0x9d0) or  c:IsSetCard(0x9d1)
end
function cm.tag(e,c)
return not c:IsSetCard(0x9d0) and not c:IsSetCard(0x9d1) 
end
function cm.hspfilter(c,ft,tp)
	return c:IsFacedown() and c:IsDefensePos()  
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return  Duel.GetCurrentChain()<1 and Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 and Duel.CheckReleaseGroup(tp,cm.hspfilter,1,nil,ft,tp) and Duel.GetCustomActivityCount(91020021,tp,ACTIVITY_SPSUMMON)==0  and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
		local g=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,ft,tp)
		Duel.Release(g,REASON_COST)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(function(e,c)
		return c:IsFacedown() and c:IsLocation(LOCATION_MZONE)
		end)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetTarget(cm.tag)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,tp)
end
--e2
function cm.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
--e4
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(91020021,RESET_EVENT+RESETS_STANDARD,0,1)
end
--e5
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
 return c:IsFaceup() and c:GetFlagEffect(91020021)>0 and  not c:IsDisabled()
end
function cm.filter(c)
	return c:IsAbleToDeck()
end
function cm.tag5(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,0)	
end
function cm.fit2(c,e)
return  c:IsAbleToHand()
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
local g1=g:RandomSelect(tp,3)
	if g:IsExists(cm.fit2,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	local g2=g1:FilterSelect(tp,cm.fit2,1,1,nil)
	Duel.SendtoHand(g2,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g2)
	g1:Sub(g2)
	end
	Duel.SendtoDeck(g1,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

