--寒霜华符 连结星
function c12869025.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(12869025)
	aux.AddLinkProcedure(c,c12869025.matfilter,1,1) 
	--cannot be link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--link as level
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_SINGLE)
	--e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e2:SetCode(EFFECT_ALLOW_SYNCHRO_KOISHI)
	--e2:SetValue(function(e,c)
		--return e:GetHandler():GetLink()
	--end)
	--c:RegisterEffect(e2)
	--add tuner type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TUNER)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(c12869025.con)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12869025,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c12869025.sptg)
	e4:SetOperation(c12869025.spop)
	c:RegisterEffect(e4)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SYNCHRO_LEVEL_EX)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(function(e) return e:GetHandler():GetLink() end)
	c:RegisterEffect(e0)
end
function c12869025.syfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:GetFlagEffect(id)==0
end
function c12869025.syntg(e,c)
	if not c:IsType(TYPE_LINK) then return false end
	for i=12869025,12869040 do
		if c:IsOriginalSetCard(0x6a70) or c:IsHasEffect(i) then
			return true
		else
			return false
		end
	end
end
function c12869025.mfilter(c)
	if not c:IsType(TYPE_LINK) or c:GetFlagEffect(id)>0 then return false end
	for i=12869025,12869040 do
		if c:IsOriginalSetCard(0x6a70) or c:IsHasEffect(i) then
			return true
		else
			return false
		end
	end
end
function c12869025.matfilter(c) 
	return c:IsLinkSetCard(0x6a70) or c:IsCode(12869000)
end
function c12869025.q(c)
	return c:IsFaceup() and c:IsSetCard(0x6a70) and c:IsType(TYPE_MONSTER)
end
function c12869025.con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c12869025.q,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c12869025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12869000,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c12869025.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,12869000,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,12869000)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end