--方舟骑士-澄闪
c29033779.named_with_Arknight=1
function c29033779.initial_effect(c)
	aux.AddCodeList(c,29033779,29065532)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29033779,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29033779)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c29033779.tktg)
	e1:SetOperation(c29033779.tkop)
	c:RegisterEffect(e1)
	--Remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(c29033779.recon)
	e4:SetOperation(c29033779.reop)
	c:RegisterEffect(e4)
	--atk limilt
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c29033779.con)
	e2:SetValue(c29033779.atlimit)
	c:RegisterEffect(e2)
	--can not directatk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c29033779.con)
	c:RegisterEffect(e3)
end
c29033779.kinkuaoi_Akscsst=true
function c29033779.recon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d or a:GetControler()==d:GetControler() then return false end
	return (a:IsType(TYPE_TOKEN) and a:IsControler(tp)) or (d:IsType(TYPE_TOKEN) and d:IsControler(tp)) and (a:IsAbleToRemove() and d:IsAbleToRemove())
end
function c29033779.reop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	if g:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(29033779,2)) then
		Duel.Hint(HINT_CARD,0,29033779)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c29033779.cfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c29033779.con(e)
	return Duel.IsExistingMatchingCard(c29033779.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c29033779.atlimit(e,c)
	return c:IsFacedown() or not c:IsType(TYPE_TOKEN)
end
function c29033779.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29033780,0,TYPES_TOKEN_MONSTER,2000,2000,2,RACE_MACHINE,ATTRIBUTE_LIGHT) end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c29033779.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,29033780,0,TYPES_TOKEN_MONSTER,2000,2000,2,RACE_MACHINE,ATTRIBUTE_LIGHT) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local token=Duel.CreateToken(tp,29033780)
	local token1=Duel.CreateToken(tp,29033780)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(token1,0,tp,tp,false,false,POS_FACEUP)
end