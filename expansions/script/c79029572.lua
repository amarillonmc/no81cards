--至星壳·魔王
function c79029572.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029572,0))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c79029572.efilter)
	e4:SetCondition(c79029572.imcon)
	c:RegisterEffect(e4)	  
	--SpecialSummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(79029572,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,79029572)
	e6:SetCost(c79029572.cost)
	e6:SetTarget(c79029572.sptg)
	e6:SetOperation(c79029572.spop)
	c:RegisterEffect(e6)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c79029572.desop)
	e2:SetLabelObject(e6)
	c:RegisterEffect(e2)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c79029572.actlimit)
	c:RegisterEffect(e1)
	--SpecialSummon limit
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(79029572,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,09029572)
	e6:SetCost(c79029572.cost1)
	e6:SetOperation(c79029572.spop1)
	c:RegisterEffect(e6)
end
function c79029572.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029572.fil(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x106)
end
function c79029572.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetMaterial():IsExists(c79029572.fil,1,nil)
end
function c79029572.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c79029572.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false,POS_FACEUP,tp,zone) and c:IsType(TYPE_RITUAL) and (c:IsRace(RACE_CYBERSE) or c:IsRace(RACE_ZOMBIE))
end
function c79029572.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c79029572.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.IsExistingMatchingCard(c79029572.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029572.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c79029572.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP,zone)~=0 then
		c:SetCardTarget(tc)
		e:SetLabelObject(tc)
	tc:RegisterFlagEffect(79029572,RESET_EVENT+RESETS_STANDARD,0,0)
	c:RegisterFlagEffect(79029572,RESET_EVENT+0x1020000,0,0)
	end
end 
function c79029572.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	if tc and tc:GetFlagEffect(79029572)~=0 and e:GetHandler():GetFlagEffect(79029572)~=0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c79029572.actlimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_GRAVE) or re:GetHandler():IsLocation(LOCATION_REMOVED)
end
function c79029572.cosfil(c,e,tp)
	return c:IsReleasable() and c:GetSummonLocation()==LOCATION_EXTRA and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c79029572.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029572.cosfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c79029572.cosfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	local tc=g:GetFirst()
	local flag=0
	if tc:IsType(TYPE_FUSION) then flag=bit.bor(flag,TYPE_FUSION) end
	if tc:IsType(TYPE_SYNCHRO) then flag=bit.bor(flag,TYPE_SYNCHRO) end
	if tc:IsType(TYPE_XYZ) then flag=bit.bor(flag,TYPE_XYZ) end
	if tc:IsType(TYPE_LINK) then flag=bit.bor(flag,TYPE_LINK) end
	e:SetLabel(flag)
end
function c79029572.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTarget(c79029572.splimit2)
	e1:SetLabel(flag)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,tp)
end
function c79029572.splimit2(e,c,tp,sumtp,sumpos)
	return not c:IsType(e:GetLabel())
end  
