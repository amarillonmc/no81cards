--超龙帝 尼克·overlord
function c16120001.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,aux.FilterBoolFunction(Card.IsRankAbove,8),nil,2,99)
	c:EnableReviveLimit()
	--direct attack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DIRECT_ATTACK)
	e0:SetCondition(c16120001.dacon)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16120001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c16120001.negop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16120001,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c16120001.atkcost)
	e2:SetTarget(c16120001.atktg)
	e2:SetOperation(c16120001.atkop)
	c:RegisterEffect(e2)
end
function c16120001.dacon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c16120001.negfilter(c)
	return c:IsCanOverlay()
end
function c16120001.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16120001.negfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,aux.ExceptThisCard(e))
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16120001.negfilter),tp,0,LOCATION_MZONE+LOCATION_GRAVE,aux.ExceptThisCard(e))
	local sg=Group.CreateGroup()
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc1=g:Select(tp,1,1,nil):GetFirst()
		if tc1 and not tc1:IsImmuneToEffect(e) then
			sg:AddCard(tc1)
		end
	end
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
		local tc2=g1:Select(1-tp,1,1,nil):GetFirst()
		if tc2 and not tc2:IsImmuneToEffect(e) then
			sg:AddCard(tc2)
		end
	end
	Duel.Overlay(c,sg)
end
function c16120001.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c16120001.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16120001.atkup,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
end
function c16120001.atkup(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAttackAbove(1)
end
function c16120001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c16120001.atkup,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_MZONE+LOCATION_GRAVE,nil)
		local atk=g:GetSum(Card.GetAttack)
		if atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end