--智天兵龙 乌利提斯
function c40008651.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c40008651.matfilter,1,1) 
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c40008651.regcon)
	e1:SetOperation(c40008651.regop)
	c:RegisterEffect(e1)   
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008651,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c40008651.spcon)
	e2:SetTarget(c40008651.sptg)
	e2:SetOperation(c40008651.spop)
	c:RegisterEffect(e2)
	--indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(c40008651.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
end
function c40008651.lkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf11)
end
function c40008651.indcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c40008651.lkfilter,1,nil)
end
function c40008651.matfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkSetCard(0xf11)
end
function c40008651.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c40008651.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c40008651.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c40008651.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(40008651) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c40008651.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40008651.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,40008652,0xf11,0x4011,1700,0,2,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c40008651.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,40008652,0xf11,0x4011,1700,0,2,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,40008652)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP,zone)
end

