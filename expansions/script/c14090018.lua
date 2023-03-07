--天种-湍枝
local m=14090018
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnableDualAttribute(c) 
	--lvchange
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(cm.lvtg)
	e1:SetOperation(cm.lvop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DUAL_STATUS)
	e3:SetCondition(cm.dscon)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(cm.thcost1)
	e4:SetTarget(cm.thtg1)
	e4:SetOperation(cm.thop1)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetCode(EVENT_LEVEL_UP)
		e5:SetLabelObject(c)
		e5:SetOperation(cm.op)
		local e6=Effect.GlobalEffect()
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e6:SetTarget(cm.tg)
		e6:SetLabelObject(e5)
		Duel.RegisterEffect(e6,0)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	Duel.RaiseEvent(c,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.tg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function cm.lvfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:GetLevel()>0
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(cm.lvfilter,tp,LOCATION_MZONE,0,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
function cm.thfilter(c,lv)
	return c:IsLevelBelow(lv-1) and c:IsAbleToGrave() and c:IsRace(RACE_PLANT) and c:IsType(TYPE_DUAL)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lv) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cfilter(c,tp)
	return c:IsRace(RACE_PLANT) and c:IsControler(tp)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and e:GetHandler():IsDualState()
end
function cm.dscon(e)
	return e:GetHandler():IsLevelAbove(4)
end
function cm.bmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c and c:IsPreviousLocation(LOCATION_ONFIELD) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED)) and (r==REASON_FUSION or c:IsReason(REASON_FUSION)) and c:GetPreviousLevelOnField()>=4 and bit.band(TYPE_EFFECT,c:GetPreviousTypeOnField())~=0
end
function cm.bmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.bmop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.thfilter1(c)
	return c:IsCode(14090020) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(cm.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end