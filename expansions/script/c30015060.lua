--终墟覆始
local m=30015060
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--act in set turn
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_SINGLE)
	--e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	--e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	--e3:SetCondition(cm.actcon)
	--c:RegisterEffect(e3)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.acttg)
	e1:SetOperation(cm.actop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=ors.redraw(c)
	--all
	local ge1=ors.allop2(c)
end
c30015060.isoveruins=true
--act in set turn
function cm.ff(c) 
	return ors.stf(c) and c:IsFaceup()
end 
function cm.actcon(e)
	local g=Duel.GetMatchingGroup(cm.ff,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_SYNCHRO)
	return #g>0
end
--Effect 1
function cm.f(c) 
	return c:IsFacedown() and ors.stf(c) and c:IsAbleToHand()
end   
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>0 end
	local rg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local ct=1
	if #rg>=5 then ct=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_REMOVED)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_REMOVED,0,nil)
	if #g==0 then return end
	local rg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local ct=1
	if #rg>=5 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tag=g:Select(tp,ct,ct,nil)
	if #tag==0 then return false end
	Duel.SendtoHand(tag,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tag)
	Duel.BreakEffect()
	local res=1
	ors.exrmop(e,tp,res)
end
--Effect 2
--Effect 3 
--Effect 4 
--Effect 5  