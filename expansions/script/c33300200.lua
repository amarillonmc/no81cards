--魔王城的栖夜姬
local m=33300200
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,1))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e0:SetRange(LOCATION_DECK)
	e0:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	e0:SetCondition(cm.spcon2)
	e0:SetOperation(cm.spop2)
	e0:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e0)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(cm.reptg)
	c:RegisterEffect(e1)
--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	e3:SetOperation(cm.thop1)
	c:RegisterEffect(e3)
end
function cm.spfilter2(c)
	return c:IsSetCard(0x561) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function cm.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function cm.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(cm.fselect,2,2,tp)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local rg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp)
	Duel.SendtoGrave(rg,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1)
	e1:SetLabelObject(e)
	e1:SetCondition(cm.adjustcon)
	e1:SetOperation(cm.adjustop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.adjustcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	Duel.ConfirmCards(1-tp,c)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup() end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
		return true
	else return false end
end
function cm.thfilter(c)
	return c:IsSetCard(0x561) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	if e:GetHandler():IsPreviousPosition(POS_FACEDOWN) then
		e:SetLabel(1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
			if c:IsRelateToEffect(e) and c:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				c:RegisterEffect(e2)
			end
			e:SetLabel(0)
	end
end