--癔动囚徒 茜
function c71280050.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c71280050.mfilter,1,1)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c71280050.regcon)
	e0:SetOperation(c71280050.regop)
	c:RegisterEffect(e0)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71280050,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c71280050.spcon)
	e1:SetTarget(c71280050.sptg)
	e1:SetOperation(c71280050.spop)
	c:RegisterEffect(e1)
	--xyzlv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c71280050.xyzlv)
	c:RegisterEffect(e2)
	--tk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71280050,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c71280050.tkcon)
	e3:SetTarget(c71280050.tktg)
	e3:SetOperation(c71280050.tkop)
	c:RegisterEffect(e3)
end
function c71280050.mfilter(c)
	return c:IsLinkSetCard(0x8911) and not c:IsLinkType(TYPE_LINK)
end
function c71280050.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c71280050.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c71280050.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c71280050.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(71280050) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c71280050.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c71280050.spfilter(c,e,tp)
	return c:IsSetCard(0x8911) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71280050.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71280050.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c71280050.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71280050.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c71280050.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71280050.xyzlv(e,c,rc)
	return 0x80000+e:GetHandler():GetLevel()
end
function c71280050.cfilter(c,tp)
	return c:IsSetCard(0x8911) and c:IsControler(tp) and c:IsPreviousControler(tp)
end
function c71280050.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71280050.cfilter,1,nil,tp)
end
function c71280050.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,71280051,0x8911,TYPES_TOKEN_MONSTER,2000,2000,8,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c71280050.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,71280051,0x8911,TYPES_TOKEN_MONSTER,2000,2000,8,RACE_FAIRY,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,71280051)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end