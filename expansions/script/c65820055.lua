--源于黑影 涅槃
local s,id,o=GetID()
function s.initial_effect(c)
	if not RZFZ_REMOVE0_CHECK then
		RZFZ_REMOVE0_CHECK=true
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_CUSTOM+65820000)
		ge6:SetCondition(s.spcon)
		ge6:SetOperation(s.checkop6)
		Duel.RegisterEffect(ge6,0)
	end

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+65820000)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.maintgcon)
	e2:SetTarget(s.maintg)
	e2:SetOperation(s.mainop)
	c:RegisterEffect(e2)
end

s.effect_lixiaoguo=true

function s.consume_use_counter(e,tp)
	for i=0,10 do
		Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
	end
	local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
	Duel.ResetFlagEffect(tp,65820099)
	for i=1,count do
		Duel.RegisterFlagEffect(tp,65820099,0,0,1)
	end
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,tp)
end

function s.cfilter1(c)
	return c:IsSetCard(0x3a32)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3a32) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.scfilter(c)
	return c:IsSpecialSummonable()
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil)
end

function s.checkop6(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,65820055,0,0,1)
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=Duel.GetFlagEffect(tp,65820055)
	if count<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,count,c)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function s.maintgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil,tp) and ep==tp
end

function s.maintg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local has_use=Duel.GetFlagEffect(tp,65820099)>0
	local is_flipped=c:GetFlagEffect(65820010)>0

	if (has_use and not is_flipped) or (not has_use and is_flipped) then
		if chk==0 then
			return Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_EXTRA,0,1,nil)
		end
		if has_use then s.consume_use_counter(e,tp) end
		e:SetLabel(1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		if chk==0 then
			return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		end
		if has_use then s.consume_use_counter(e,tp) end
		e:SetLabel(2)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetCost(s.rmcost)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end

function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end

function s.mainop(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	if label==1 then
		local g=Duel.GetMatchingGroup(s.scfilter,tp,LOCATION_EXTRA,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummonRule(tp,sc)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end