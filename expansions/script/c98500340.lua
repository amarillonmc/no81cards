--古神之化身
function c98500340.initial_effect(c)
	--Link Summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DIVINE),1,1,nil)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetValue(c98500340.matval)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c98500340.efcon)
	e2:SetOperation(c98500340.efop)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500340,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98500340.sumcon)
	e3:SetCost(c98500340.sumcost)
	e3:SetTarget(c98500340.sumtg)
	e3:SetOperation(c98500340.sumop)
	c:RegisterEffect(e3)
	--activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,98500340)
	e4:SetCondition(c98500340.effcon)
	e4:SetOperation(c98500340.effop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,98500340+1)
	e6:SetCondition(c98500340.spcon)
	e6:SetTarget(c98500340.sptg)
	e6:SetOperation(c98500340.spop)
	c:RegisterEffect(e6)
	--link limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e7:SetTarget(c98500340.lklimit)
	c:RegisterEffect(e7)
end
function c98500340.lklimit(e,c)
	if not c then return false end
	return c:IsRace(RACE_DIVINE) or c:IsAttribute(ATTRIBUTE_DIVINE)
end
function c98500340.matval(e,lc,mg,c,tp)
	return e:GetHandler()==lc,true
end
function c98500340.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function c98500340.efop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98500340.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98500340.splimit(e,c)
	return c:IsCode(98500340) and c:IsLocation(LOCATION_EXTRA)
end
function c98500340.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,98500340)==0
end
function c98500340.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98500340.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
end
function c98500340.sumop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(98500340,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DIVINE+RACE_SPELLCASTER))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,98500340,RESET_PHASE+PHASE_END,0,1)
end
function c98500340.cfilter(c,lg)
	return lg:IsContains(c) and c:IsRace(RACE_DIVINE)
end
function c98500340.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not eg:IsContains(c) and eg:IsExists(c98500340.cfilter,1,nil,c:GetLinkedGroup())
end
function c98500340.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local g=eg:Filter(c98500340.cfilter,nil,c:GetLinkedGroup())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(7373632,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(7373632,0))
			tc=g:GetNext()
		end
	end
end
function c98500340.filter(c)
	return c:IsCode(98500311) and c:IsFaceup()
end
function c98500340.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98500340.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c98500340.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98500340.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
