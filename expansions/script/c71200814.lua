--深渊的呼唤VIII 第36赛季·精华2
local cm, m = GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71200800)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.tg2)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.con4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
--e1
function cm.e1f1(c)
	return not c:IsType(TYPE_FIELD) and c:IsSetCard(0x899) and c:IsAbleToHand()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(cm.e1f1,tp,LOCATION_DECK,0,nil)
	if not (g:GetCount()>0 and Duel.SelectYesNo(tp,1190)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g = g:Select(tp,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
--e2
function cm.tg2(e,c)
	return c:IsFaceup() and c:IsCode(71200800)
end
--e4
function cm.e4f1(c,eg)
	return cm.tg2(nil,c) and not eg:IsContains(c)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.e4f1,tp,LOCATION_MZONE,0,1,nil,eg)
		and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if chk==0 then return #g > 2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,3,1-tp,LOCATION_GRAVE)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g = Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,3,3,nil)
	if #g~=3 then return end
	Duel.HintSelection(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end