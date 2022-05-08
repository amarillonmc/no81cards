--铁战灵兽 M冰鬼护
function c33200914.initial_effect(c)
	aux.AddCodeList(c,33200913) 
	--spesm
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x332a),6,99,c33200914.xyzovfilter,aux.Stringid(33200914,1),99,c33200914.xyzop)
	c:EnableReviveLimit()
	--stg
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c33200914.tgcon)
	e1:SetTarget(c33200914.tgtg)
	e1:SetOperation(c33200914.tgop)
	c:RegisterEffect(e1) 
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200914,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33200914.condition)
	e2:SetCost(c33200914.cost)
	e2:SetTarget(c33200914.target)
	e2:SetOperation(c33200914.operation)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33200914.atkcon)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33200914.atkcon)
	e4:SetValue(500)
	c:RegisterEffect(e4)
end

--xyz
function c33200914.xyzovfilter(c)
	return c:IsFaceup() and c:IsCode(33200913)
end
function c33200914.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x323)
end
function c33200914.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33200052)==0 
	and Duel.IsExistingMatchingCard(c33200914.xyzfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.RegisterFlagEffect(tp,33200052,nil,EFFECT_FLAG_OATH,1)
end

--e1
function c33200914.ovfilter(c)
	return c:GetCounter(0x132a)>0 and c:IsCanOverlay()
end
function c33200914.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33200914.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200914.ovfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c33200914.ovfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c33200914.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c33200914.ovfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(e:GetHandler(),Group.FromCards(tc))
	end
end

--e2
function c33200914.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler():IsSetCard(0x332a)
end
function c33200914.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x132a,3)
end
function c33200914.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33200914.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200914.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x132a)
end
function c33200914.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectMatchingCard(tp,c33200914.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		tc:AddCounter(0x132a,3)
	end
end

--e34
function c33200914.atkcon(e)
	return Duel.GetFlagEffect(tp,33200900)>0
end