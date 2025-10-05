--·世界的重责·
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337920)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(s.con)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetOperation(s.actop)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(s.con2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e2:SetValue(s.atklimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.con)
	e3:SetTarget(s.cfilter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function s.thfilter(c)
	return (c:IsCode(17337920) or aux.IsCodeListed(c,17337920)) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.reinfilter(c,tp) 
	return c:IsFaceup() and c:IsCode(17337920) and c:IsControler(tp) 
end
function s.con2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0 and Duel.IsExistingMatchingCard(s.reinfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.atklimit(e,c)
	return c:IsFaceup() and c:IsCode(17337920)
end
function s.cfilter(c)
	return c:IsCode(17337920)
end