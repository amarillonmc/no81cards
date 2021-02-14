local m=15000544
local cm=_G["c"..m]
cm.name="青煌城之恶虺"
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_FLIP),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(cm.indcon)
	e1:SetTarget(cm.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.sptg1)
	e3:SetOperation(cm.spop1)
	c:RegisterEffect(e3)
end
function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function cm.indtg(e,c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) or c:IsPosition(POS_FACEUP_DEFENSE)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsAbleToGrave()
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(sc,REASON_EFFECT) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc and tc:IsRelateToEffect(e) and tc:IsFacedown() then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end