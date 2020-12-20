--罗德岛·重装干员-泡泡
function c79029361.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c79029361.mfilter,1,1)
	c:EnableReviveLimit()  
	--addown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ALSO_BATTLE_DAMAGE)
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,79029361)
	e4:SetCondition(c79029361.damcon)
	e4:SetOperation(c79029361.damop)
	c:RegisterEffect(e4) 
end
function c79029361.mfilter(c)
	return c:IsLevelAbove(8) and c:IsSetCard(0xa900)
end
function c79029361.spfil(c,e,tp,ev,zone)
	return c:IsAttackBelow(ev) and c:IsSetCard(0xa900) 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end  
function c79029361.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=e:GetHandler():GetLinkedZone()
	return ep==tp and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and Duel.IsExistingMatchingCard(c79029361.spfil,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp,ev,zone)
end
function c79029361.damop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	Debug.Message("我们数到一就开始跑，好不好？")
	Duel.Hint(HINT_SOUND,tp,aux.Stringid(79029361,0))
	local g=Duel.SelectMatchingCard(tp,c79029361.spfil,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp,ev,zone)   
	if g:GetCount()>0 then 
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end 
end












