--H.P.T.-005
local m=12899009
local cm=_G["c"..m]
function cm.initial_effect(c)
	  --act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.rmcon)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
 --to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m+10000)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return ((not c:IsSetCard(0x5a71)) and c:IsFaceup())
end
function cm.filter2(c)
	return ((c:IsSetCard(0x5a71)) and c:IsFaceup())
end
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0 or  (not Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)  and Duel.IsExistingMatchingCard(cm.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil))
end

function cm.filter0(c)
	return c:IsSetCard(0x5a71) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0 then
	 e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter0,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 and  Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then 
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,nil)>0 and  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		  Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end

function cm.filter(c)
	return ((not c:IsSetCard(0x5a71)) and c:IsFaceup())
end
function cm.filter2(c)
	return ((c:IsSetCard(0x5a71)) and c:IsFaceup())
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and re:GetHandler():IsSetCard(0x5a71,0x6a71) and c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_HAND) and (not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil))
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanRemove(tp) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.ckfilter(c)
	return c:IsSetCard(0x5a71,0x6a71)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-p,g)
	if not g:IsExists(cm.ckfilter,1,nil) then
	local rg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_RULE)
	end
	Duel.ShuffleHand(p)  
   local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x5a71)
end

function cm.thfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end