--超银河眼残光龙
local m=22348407
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetValue(c22348407.raval)
	c:RegisterEffect(e1)
	--spsmatkdown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348407,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22348407.sacost)
	e2:SetTarget(c22348407.satg)
	e2:SetOperation(c22348407.saop)
	c:RegisterEffect(e2)
	
end
function c22348407.raval(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	return g:FilterCount(Card.IsSetCard,nil,0x55,0x7b)
end
function c22348407.sacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348407.spfilter(c,e,tp,atk,def)
	return c:IsSetCard(0x48) and ((atk~=0 and c:GetBaseAttack()~=0) or (def~=0 and c:GetBaseDefense()~=0)) and (c:GetBaseAttack()~=0 or c:GetBaseDefense()~=0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22348407.spfilter2(c,e,tp,atk,def)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22348407.satg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if c==at then at=a end
	if chk==0 then return at and Duel.IsExistingMatchingCard(c22348407.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,at:GetAttack(),at:GetDefense()) end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22348407.saop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	g=Duel.SelectMatchingCard(tp,c22348407.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetAttack(),tc:GetDefense())
	else g=Duel.SelectMatchingCard(tp,c22348407.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp) end
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		local sc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-sc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-sc:GetBaseDefense())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		end
	end
end
