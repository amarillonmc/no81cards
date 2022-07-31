local m=31400090
local cm=_G["c"..m]
cm.name="闪珖魔法使 星尘"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa3),aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.seqfilter(c,seq)
	local cseq=c:GetSequence()
	local d=math.abs(4-seq-cseq)
	return (d==0) or (d==1 and c:IsType(TYPE_MONSTER)) or (cseq==5 and math.abs(seq-3)<=1) or (cseq==6 and math.abs(seq-1)<=1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local seq=e:GetHandler():GetSequence()
	if seq==5 then seq=1 end
	if seq==6 then seq=3 end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(cm.seqfilter,nil,seq)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local seq=c:GetSequence()
	if seq==5 then seq=1 end
	if seq==6 then seq=3 end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(cm.seqfilter,nil,seq)
	if #g==0 then return end
	Duel.SendtoGrave(g,REASON_RULE)
	Duel.BreakEffect()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
	if fc then Duel.Destroy(fc,REASON_RULE) end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,1<<seq) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsType(TYPE_SPELL) and e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function cm.thfilter(c)
	return c:IsSetCard(0xa3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end