--「苍炎」纹章士-“苍炎勇者”
function c75000053 .initial_effect(c)
	aux.AddCodeList(c,75000001)
	--link summon
	aux.AddLinkProcedure(c,nil,2,nil,c75000053.lcheck)
	c:EnableReviveLimit()
	--todeck
	--Pos Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_ATTACK+NO_FLIP_EFFECT)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e2)
----
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(c75000053.atklimit)
	c:RegisterEffect(e3)
-----
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(75000053,0))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(c75000053.damcon)
	e5:SetTarget(c75000053.damtg)
	e5:SetOperation(c75000053.damop)
	c:RegisterEffect(e5)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000053,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,75000053)
	e3:SetTarget(c75000053.sptg)
	e3:SetOperation(c75000053.spop)
	c:RegisterEffect(e3)
end


function c75000053.atklimit(e,c)
	return c==e:GetHandler()
end
function c75000053.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c75000053.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,bc:GetAttack())
end
function c75000053.damop(e,tp,eg,ep,ev,re,r,rp)
local bc=e:GetHandler():GetBattleTarget()
	local dam=bc:GetAttack()
	local rec=bc:GetAttack()
	if dam<0 then dam=0 end
	if rec<0 then rec=0 end
	Duel.Damage(1-tp,dam,REASON_EFFECT,true)
	Duel.Recover(tp,rec,REASON_EFFECT,true)
	Duel.RDComplete()
end
----2

function c75000053.spfilter2(c,e,tp)
	return (c:IsSetCard(0x5751) or c:IsCode(75000001)) and not c:IsCode(75000053) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c75000053.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000053.spfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c75000053.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75000053.spfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
----3