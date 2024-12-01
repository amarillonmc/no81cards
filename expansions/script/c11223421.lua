local m=11223421
local cm=_G["c"..m]
cm.name="青莲苏生"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.necon)
	e2:SetTarget(cm.netg)
	e2:SetOperation(cm.neop)
	c:RegisterEffect(e2)
end
--Activate
function cm.filter(c,e,tp)
	return c:GetAttack()==500 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
		and c:IsRelateToEffect(e) and tc:IsType(TYPE_XYZ) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
--Negate
function cm.nefilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
		and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
end
function cm.necon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return aux.exccon(e) and g and g:IsExists(cm.nefilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function cm.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.neop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.NegateActivation(ev)
	end
end