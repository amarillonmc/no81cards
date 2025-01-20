--机壳守护神 进程灵
function c49811339.initial_effect(c)
	c:SetSPSummonOnce(49811339)
	--link summon
	aux.AddLinkProcedure(c,c49811339.matfilter,1,1)
	c:EnableReviveLimit()
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(49811339,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c49811339.sprcon)
	e0:SetTarget(c49811339.sprtg)
	e0:SetOperation(c49811339.sprop)
	c:RegisterEffect(e0)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,49811339)
	e1:SetCost(c49811339.spcost)
	e1:SetTarget(c49811339.sptg)
	e1:SetOperation(c49811339.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c49811339.reptg)
	e2:SetValue(c49811339.repval)
	e2:SetOperation(c49811339.repop)
	c:RegisterEffect(e2)
end
function c49811339.matfilter(c)
	return c:IsLinkSetCard(0xaa) and c:IsDefense(1000)
end
function c49811339.rlfilter(c)
	return c:IsSetCard(0xaa) and c:IsReleasable(REASON_SPSUMMON)
end
function c49811339.sprcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c49811339.rlfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil)
end
function c49811339.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c49811339.rlfilter,tp,LOCATION_PZONE,0,1,1,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c49811339.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	Duel.Release(mg,REASON_COST)
	mg:DeleteGroup()
end
function c49811339.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c49811339.rmfilter(c)
	return c:IsSetCard(0xaa) and c:IsAbleToRemoveAsCost()
end
function c49811339.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c49811339.rmfilter,tp,0x10,0,1,nil) and Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,49811340,0xaa,TYPES_TOKEN_MONSTER,1800,1000,4,RACE_MACHINE,ATTRIBUTE_EARTH) end
	e:SetLabel(0)
	local ft=Duel.GetMZoneCount(tp)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c49811339.rmfilter,tp,LOCATION_GRAVE,0,1,math.min(ft,2),nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(#g)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#g,0,0)
end
function c49811339.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,49811340,0xaa,TYPES_TOKEN_MONSTER,1800,1000,4,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	local ct=e:GetLabel()
	if ct==2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,49811340)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c49811339.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xaa) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c49811339.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c49811339.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c49811339.repval(e,c)
	return c49811339.repfilter(c,e:GetHandlerPlayer())
end
function c49811339.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,49811339)
end
