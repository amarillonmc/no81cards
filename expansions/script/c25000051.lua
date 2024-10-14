--不屈不败
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(aux.tgoval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.spcon)
	e3:SetOperation(s.spop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)	
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and not c:IsReason(REASON_DESTROY) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsLocation(0x30) and not c:IsFacedown()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and eg:IsExists(s.cfilter,1,nil,tp)
end
function s.spfilter(c,e,tp)
	local pos=c:GetPreviousPosition()
	return pos and not c:IsFacedown() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,pos)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(10,0,id)
	local g=eg:Filter(s.cfilter,nil,tp):Filter(aux.NecroValleyFilter(s.spfilter),nil,e,tp)
	if #g<=0 then return end
	if ft>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local x = ft and ft < #g or #g
	local sg=g:Select(tp,1,x,nil)
	if #sg>0 then
		for tc in aux.Next(sg) do
		if Duel.GetLocationCount(tp,4)<=0 then break end
		local pos=tc:GetPreviousPosition()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,pos)
		end
		Duel.SpecialSummonComplete()
	end
end