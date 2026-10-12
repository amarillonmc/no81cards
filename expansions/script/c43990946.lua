--象征世界的仲裁者
function c43990946.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c43990946.mfilter,c43990946.xyzcheck,2,283)
	--aux.AddXyzProcedure(c,nil,4,4,nil,nil,283)
	c:EnableReviveLimit()
	--[[--
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_SINGLE)
	ge0:SetCode(EFFECT_DOUBLE_XMATERIAL)
	ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge0:SetRange(LOCATION_MZONE)
	ge0:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,43990946))
	ge0:SetValue(1)
	--effect grant
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSummonLocation,LOCATION_GRAVE))
	e0:SetLabelObject(ge0)
	c:RegisterEffect(e0)]]
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c43990946.discon)
	e1:SetOperation(c43990946.disop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c43990946.regcon)
	e2:SetOperation(c43990946.regop)
	c:RegisterEffect(e2)
end
function c43990946.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4)
end
function c43990946.xyzcheck(g)
	return g:FilterCount(Card.IsSummonLocation,nil,LOCATION_GRAVE)+#g>=4
end
function c43990946.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and (loc&(LOCATION_HAND+LOCATION_ONFIELD))~=0 and not re:GetHandler():IsRelateToEffect(re)
end
function c43990946.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c43990946.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c43990946.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c43990946.spcon)
	e1:SetOperation(c43990946.spop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function c43990946.spfilter(c,e,tp)
	return c:IsCode(43990946) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.NecroValleyFilter()(c) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and (c:IsFaceupEx() or c:IsLocation(LOCATION_EXTRA))
end
function c43990946.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c43990946.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,43990946)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43990946.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
