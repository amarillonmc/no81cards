--最佳搭配Build 天才娘
function c72100031.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),4)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c72100031.inmcon)
	e2:SetTarget(c72100031.inmtg)
	e2:SetValue(c72100031.efilter2)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c72100031.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c72100031.tgtg)
	c:RegisterEffect(e3)
	------
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e5:SetTargetRange(0,0xff)
	e5:SetValue(LOCATION_REMOVED)
	e5:SetTarget(c72100031.rmtg)
	c:RegisterEffect(e5)
	----
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(72100031,2))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_DESTROYED)
	e9:SetCondition(c72100031.damcon)
	e9:SetTarget(c72100031.damtg2)
	e9:SetOperation(c72100031.damop2)
	c:RegisterEffect(e9)
end
function c72100031.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c72100031.tgtg(e,c)
	return c~=e:GetHandler()
end
function c72100031.inmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c72100031.inmtg(e,c)
	local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c72100031.efilter2(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
------
function c72100031.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c72100031.damfilter(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsLinkBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72100031.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c72100031.damfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	local d=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)*0
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d)
end
function c72100031.damop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72100031.damfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local d=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)*0
		Duel.Damage(1-tp,d,REASON_EFFECT)
	end
end