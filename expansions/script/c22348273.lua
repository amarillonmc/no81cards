--嫉 妒 「 看 不 见 的 绿 眼 怪 兽 」
local m=22348273
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_ATTACK)
	e1:SetCountLimit(1,22348273+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22348273.target)
	e1:SetOperation(c22348273.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22348273.actcon)
	c:RegisterEffect(e2)
end
function c22348273.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x612)
end
function c22348273.actcon(e)
	return Duel.IsExistingMatchingCard(c22348273.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c22348273.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22348274,0,TYPES_TOKEN_MONSTER,2500,0,8,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22348273.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22348274,0,TYPES_TOKEN_MONSTER,2500,0,8,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then return end
	local token=Duel.CreateToken(tp,22348274)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		 --   cannot be target
		local e2=Effect.CreateEffect(token)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(aux.imval1)
		token:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetValue(aux.tgoval)
		token:RegisterEffect(e3)

end
