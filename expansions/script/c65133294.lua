--引幻叙言的甘醇好饵
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65133296)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon opponent
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--draw and immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x838) and c:IsRace(RACE_FIEND)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,1-tp,LOCATION_GRAVE,0,1,nil,e,1-tp) end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.min(3,Duel.GetLocationCount(1-tp,LOCATION_MZONE),Duel.GetMatchingGroupCount(s.spfilter,1-tp,LOCATION_GRAVE,0,nil,e,1-tp))
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(1-tp,s.spfilter,1-tp,LOCATION_GRAVE,0,ct,ct,nil,e,1-tp)
		if sg:GetCount()>0 then
			local c=e:GetHandler()
			for tc in aux.Next(sg) do
				if Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					tc:RegisterEffect(e2)
					local e3=e1:Clone()
					e3:SetCode(EFFECT_SET_ATTACK)
					e3:SetValue(0)
					tc:RegisterEffect(e3)
				end
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function s.drfilter(c,tp)
	return c:IsCode(65133296) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsControler(tp)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.drfilter,1,nil,tp)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE) then
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(s.imtg)
			e1:SetValue(s.imval)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.imtg(e,c)
	return c:IsSetCard(0x838) and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.imval(e,re)
	return re:GetOwnerPlayer()==1-e:GetHandlerPlayer() and re:IsActivated()
end
