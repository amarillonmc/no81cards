--专用虚网线路
local m=33300308
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.spcheck(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.IsPlayerCanSpecialSummonMonster(tp,33300300,0,TYPES_TOKEN_MONSTER,-2,-2,4,RACE_CYBERSE,ATTRIBUTE_LIGHT)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spcheck,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,cm.spcheck,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		local bc=sg:GetFirst()
		Duel.SendtoGrave(bc,REASON_EFFECT)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,33300300,0,TYPES_TOKEN_MONSTER,-2,-2,4,RACE_CYBERSE,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,33300300)
			local atk=bc:GetBaseAttack()
			local def=bc:GetBaseDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(def)
			token:RegisterEffect(e2)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end