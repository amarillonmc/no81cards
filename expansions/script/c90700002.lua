local m=90700002
local cm=_G["c"..m]
cm.name="霜火公爵"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(cm.acttg)
	e1:SetOperation(cm.actop)
	c:RegisterEffect(e1)
	c90700002.act=e1
	local e2=e1:Clone()
	e2:SetCondition(cm.actcon)
	e2:SetRange(LOCATION_DECK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(SUMMON_TYPE_RITUAL)
	e3:SetCondition(cm.spcon)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(cm.sertg)
	e4:SetOperation(cm.serop)
	c:RegisterEffect(e4)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 and not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function cm.actfilter(c)
	return c:IsSetCard(0x5ac0) and c:IsAbleToHand() and not c:IsCode(90700002)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc
	if e:GetLabel()==1 then
		tc=eg:GetFirst()
	else
		tc=e:GetHandler()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	tc:RegisterEffect(e2)
	tc:AddCounter(0x5ac0,4)
	Duel.BreakEffect()
	local ffcount=Duel.GetCounter(tp,LOCATION_SZONE,0,0x5ac0)
	local field=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	if field then
		ffcount=ffcount-field:GetCounter(0x5ac0)
	end
	if ffcount>=7 and Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(90700002,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.RegisterFlagEffect(tp,90700002,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.IsCanRemoveCounter(e:GetHandlerPlayer(),1,0,0x5ac0,9,REASON_COST) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x5ac0,9,REASON_COST)
end
function cm.serfilter(c)
	return c:IsCode(90700009) and c:IsAbleToHand() and (c:IsPosition(POS_FACEUP) or not c:IsLocation(LOCATION_REMOVED))
end
function cm.sertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.serfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,0)
end
function cm.serop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.serfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end