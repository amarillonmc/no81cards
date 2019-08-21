--死境勇士·哈拉尔德
local m=14000109
local cm=_G["c"..m]
cm.named_with_brave=1
function cm.initial_effect(c)
	--can not changepos
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_CHANGE_POS_E)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(cm.poscon)
	c:RegisterEffect(e0)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(function(e,rc) return rc~=e:GetHandler() and rc:IsFacedown() end)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)
	--can not changepos
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.poscon)
	c:RegisterEffect(e2)
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(function(e,c) return c==e:GetHandler() end)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	--summon with 3 tribute
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e4:SetCondition(cm.ttcon)
	e4:SetOperation(cm.ttop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	--pos change
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
	--set
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(cm.setcon)
	e6:SetTarget(cm.settg)
	e6:SetOperation(cm.setop)
	c:RegisterEffect(e6)
end
function cm.poscon(e)
	return e:GetHandler():IsAttackPos()
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.filter(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter,1,nil,tp) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,LOCATION_ONFIELD)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and not c:IsType(TYPE_TOKEN) end,tp,0,LOCATION_ONFIELD,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and not c:IsType(TYPE_TOKEN) end,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsCanTurnSet() and not tc:IsType(TYPE_PENDULUM) then
		tc:CancelToGrave()
		if tc:IsType(TYPE_MONSTER) then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		else
			Duel.ChangePosition(tc,POS_FACEDOWN)
		end
	elseif tc:IsType(TYPE_TOKEN) then
		return
	elseif tc:IsType(TYPE_PENDULUM) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_RULE)
	elseif tc:IsFaceup() or not tc:IsLocation(LOCATION_REMOVED) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_RULE)
	else
		return
	end
end
function cm.setfilter(c,e,tp)
	return c:IsFaceup() and c:GetSequence()<5
end
function cm.setcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.thfilter(c,e,tp)
	return c:IsCode(14000110) and (c:IsAbleToHand() or c:IsSSetable())
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,nil)
	local tc=tg
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsSSetable()
		if b1 and (not b2 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end