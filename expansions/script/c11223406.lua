local m=11223406
local cm=_G["c"..m]
cm.name="艾莉儿"
function cm.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
--Equip
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc==at end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and at:IsRelateToBattle()
		and at:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(at)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	elseif Duel.Equip(tp,c,tc,true) then
		Duel.NegateAttack()
		--Add Equip Limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(cm.eqlimit)
		c:RegisterEffect(e1)
		--Atk & Def Up
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		c:RegisterEffect(e2)
		e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)
		--Remove
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetValue(LOCATION_REMOVED)
		e4:SetReset(RESET_EVENT+0x47e0000)
		c:RegisterEffect(e4,true)
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
--Special Summon
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.filter(c,e,tp)
	return not c:IsCode(m) and c:GetAttack()==500 and c:GetDefense()==500 and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end