--闪击秘书 帕尔菲
local m=40011114
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xf11),1,1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--to field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(cm.tfcon)
	e2:SetTarget(cm.tftg)
	e2:SetOperation(cm.tfop)
	c:RegisterEffect(e2)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.filter(c)
	return c:IsSetCard(0xf11) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsPreviousControler(tp)
end
function cm.tffilter(c,tp)
	return c:IsSetCard(0xf11) and c:GetType()&(TYPE_CONTINUOUS+TYPE_SPELL)==TYPE_CONTINUOUS+TYPE_SPELL and Duel.IsExistingMatchingCard(cm.tfcheck,tp,LOCATION_DECK,0,1,nil,tp,c) 
end
function cm.tfcheck(c,tp,tc)
	return c:IsSetCard(0xf11) and c:GetType()&(TYPE_CONTINUOUS+TYPE_SPELL)==TYPE_CONTINUOUS+TYPE_SPELL and not c:IsCode(tc:GetCode()) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and cm.tffilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tffilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tffilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.tfcheck,tp,LOCATION_DECK,0,1,1,nil,tp,tc)
		if g:GetCount()>0 then
			local gc=g:GetFirst()
			Duel.MoveToField(gc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end