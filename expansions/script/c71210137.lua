--闇邪咏奏-终焉魂歌
local s,id,o=GetID()
function s.initial_effect(c)
	s.imm(c)
	s.sp2(c)
end

function s.imm(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1125)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+1)
	e1:SetCost(s.immcost)
	e1:SetTarget(s.immtg)
	e1:SetOperation(s.immop)
	c:RegisterEffect(e1)
end
function s.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_SZONE,0,1,nil) end
end
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,nil)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESET_CHAIN)
		e1:SetValue(s.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and te:IsActivated()
end

function s.sp2(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71210128,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x897)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ct>0 and ct==Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,0,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end