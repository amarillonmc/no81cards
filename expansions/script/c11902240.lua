--不绝的龙吼
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.spopAc)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
    --Atk/Def Up
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetRange(LOCATION_SZONE) 
	e3:SetTargetRange(0x04,0) 
	e3:SetTarget(function(e,c) 
	    return c:IsLevelAbove(8) end) 
	e3:SetValue(500)
	c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e4)
    --
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetCondition(s.con)
	e5:SetValue(1)
	c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetValue(aux.tgoval)
    c:RegisterEffect(e6)
end
function s.fi8ter(c)
    return c:IsLevelAbove(8) and c:IsFaceup()
end
function s.con(e)
    return Duel.IsExistingMatchingCard(s.fi8ter,e:GetHandler():GetControler(),0x04,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,11902241,0,TYPES_TOKEN_MONSTER,2500,2500,8,RACE_DRAGON,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)>0
    and Duel.IsPlayerCanSpecialSummonMonster(tp,11902241,0,TYPES_TOKEN_MONSTER,2500,2500,8,RACE_DRAGON,ATTRIBUTE_WIND)
    then
		local token=Duel.CreateToken(tp,11902241)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.spopAc(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)>0
    and Duel.IsPlayerCanSpecialSummonMonster(tp,11902241,0,TYPES_TOKEN_MONSTER,2500,2500,8,RACE_DRAGON,ATTRIBUTE_WIND)
    and Duel.SelectYesNo(tp,aux.Stringid(id,1))
    then
		local token=Duel.CreateToken(tp,11902241)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end