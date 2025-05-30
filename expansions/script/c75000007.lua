--连结的绊炎 传承琉迩
function c75000007.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,75000001,c75000007.mfilter,1,63,true,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--gain effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c75000007.regcon)
	e1:SetOperation(c75000007.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c75000007.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--spsummon-self
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000007,5))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,75000007+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c75000007.spscon)
	e3:SetTarget(c75000007.spstg)
	e3:SetOperation(c75000007.spsop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
function c75000007.mfilter(c)
	return aux.IsCodeListed(c,75000001)
end
function c75000007.valcheck(e,c)
	local val=c:GetMaterialCount()
	e:GetLabelObject():SetLabel(val)
end
function c75000007.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()~=0
end
function c75000007.regop(e,tp,eg,ep,ev,re,r,rp)
	local vt=e:GetLabel()
	local c=e:GetHandler()
	if vt>=2 then
		--spsummon
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(75000007,4))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(c75000007.spcon)
		e1:SetTarget(c75000007.sptg)
		e1:SetOperation(c75000007.spop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75000007,0))
	end
	if vt>=3 then
		--cannot be target
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c75000007.indtg)
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75000007,1))
	end
	if vt>=4 then
		--disable
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(75000007,3))
		e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_CHAINING)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetCondition(c75000007.discon)
		e3:SetTarget(c75000007.distg)
		e3:SetOperation(c75000007.disop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75000007,2))
	end
end
function c75000007.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c75000007.spfilter(c,e,tp)
	return aux.IsCodeListed(c,75000001) and not c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c75000007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000007.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
end
function c75000007.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75000007.spfilter),tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c75000007.indtg(e,c)
	local seq=c:GetSequence()
	return seq<5 and math.abs(e:GetHandler():GetSequence()-seq)<=1
end
function c75000007.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and Duel.IsChainDisablable(ev)
end
function c75000007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c75000007.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c75000007.spscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c75000007.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75000007.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,SUMMON_TYPE_FUSION,tp,tp,false,true,POS_FACEUP) then
		e:GetLabelObject():SetLabel(4)
		local val=math.floor(Duel.GetLP(tp)/2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
