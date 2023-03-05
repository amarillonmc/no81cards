--于贝尔 究极幻魔
function c98950002.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c98950002.spcon)
	e1:SetOperation(c98950002.spop)
	c:RegisterEffect(e1)
--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
--reflect battle dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98950002,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c98950002.destg)
	e3:SetOperation(c98950002.desop)
	c:RegisterEffect(e3)
end
function c98950002.cfilter(c,tp)
	return c:IsLevel(12) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsCode(98950002)
		and Duel.GetMZoneCount(tp,c)>0
end
function c98950002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c98950002.cfilter,1,nil,tp)
end
function c98950002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c98950002.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c98950002.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.IsPlayerCanSpecialSummonMonster(tp,98951000,0,TYPES_TOKEN_MONSTER,0,0,12,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp,0) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c98950002.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local atk=g:GetFirst():GetTextAttack()
		if atk<0 then atk=0 end
		Duel.HintSelection(g)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			if Duel.IsPlayerCanSpecialSummonMonster(tp,98951000,0,TYPES_TOKEN_MONSTER,0,0,12,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp,0) then
				 local token=Duel.CreateToken(tp,98951000)
				 Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
				 local e1=Effect.CreateEffect(e:GetHandler())
				 e1:SetType(EFFECT_TYPE_SINGLE)
				 e1:SetCode(EFFECT_SET_ATTACK)
				 e1:SetValue(atk)
				 e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				 token:RegisterEffect(e1)
			end
		end
	end
end