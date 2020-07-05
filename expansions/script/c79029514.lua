--渊眼混沌龙·极
function c79029514.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DRAGON),4,99)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029514,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029514)
	e1:SetCondition(c79029514.damcon)
	e1:SetTarget(c79029514.damtg)
	e1:SetOperation(c79029514.damop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c79029514.regcon)
	e2:SetOperation(c79029514.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c79029514.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c79029514.tgcon)
	e4:SetOperation(c79029514.atkop)
	c:RegisterEffect(e4)
	--actlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(1)
	e5:SetCondition(c79029514.actcon)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,79029514)
	e6:SetCondition(c79029514.hspcon)
	e6:SetOperation(c79029514.hspop)
	c:RegisterEffect(e6)
end
function c79029514.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SPSUMMON)
end
function c79029514.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_DRAGON) end
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_DRAGON)
	local dam=g:GetClassCount(Card.GetCode)*1000
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c79029514.damop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_DRAGON)
		local dam=g:GetClassCount(Card.GetCode)*1000
		Duel.Damage(1-tp,dam,REASON_EFFECT)
end
function c79029514.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c79029514.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(79029514,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029514,4))
end
function c79029514.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xdd)
	and g:IsExists(Card.IsType,1,nil,TYPE_FUSION)  then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c79029514.tgcon(e,tp,eg,ep,ev,re,r,rp)
	 return  e:GetHandler():GetMaterial():IsExists(Card.IsSetCard,1,nil,0xdd) and e:GetHandler():GetMaterial():IsExists(Card.IsType,1,nil,TYPE_FUSION)
end
function c79029514.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c:GetMaterialCount()-1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c79029514.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph>PHASE_MAIN1 and ph<PHASE_MAIN2)
end
function c79029514.rfilter(c)
	return c:IsSetCard(0xdd) and c:IsType(TYPE_RITUAL) and c:IsReleasable()
end
function c79029514.hspcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local m=0
	if ft>0 then m=LOCATION_MZONE end
	return ft>-1 and Duel.IsExistingMatchingCard(c79029514.rfilter,tp,LOCATION_MZONE,m,1,nil)
end
function c79029514.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local m=0
	if ft>0 then m=LOCATION_MZONE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c79029514.rfilter,tp,LOCATION_MZONE,m,1,1,nil)
	Duel.Release(g,REASON_COST)
end