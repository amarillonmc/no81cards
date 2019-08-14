--托付给久远的梦 魅魔
function c1000400.initial_effect(c)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,1000400)
	e1:SetCondition(c1000400.condition1)
	--e1:SetTarget(c1000400.target1)
	e1:SetOperation(c1000400.operation1)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c1000400.indval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c1000400.indval)
	c:RegisterEffect(e3)
	--cannot direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e4)
end
function c1000400.indval(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c1000400.condition1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
		and re:GetHandler():IsSetCard(0xa201)
end
function c1000400.filter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xa201) and not c:IsCode(1000400)
end
function c1000400.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1000400,1))
	local sg=Duel.GetMatchingGroup(c1000400.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	 if sg:GetCount()>0 then
	 Duel.BreakEffect()
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	 local tg=sg:Select(tp,1,1,nil)
	 Duel.HintSelection(tg)
	 Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	end
end