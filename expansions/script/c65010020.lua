--『Lost One的号哭』美竹兰
function c65010020.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65010020)
	e1:SetTarget(c65010020.destg)
	e1:SetOperation(c65010020.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,65010021)
	e3:SetTarget(c65010020.target2)
	e3:SetOperation(c65010020.activate2)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c65010020.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c65010020.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)~=0 then
		local sig=0
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local num=Duel.Destroy(g,REASON_EFFECT)
			if num>0 then
				local dg=Duel.GetOperatedGroup()
				if dg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==0 then
					sig=1
				end
			else
				sig=1
			end
		else
			sig=1
		end
		if sig==1 then
			local tdg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_ONFIELD,0,1,1,nil)
			if tdg:GetCount()>0 then
				Duel.HintSelection(tdg)
				Duel.SendtoDeck(tdg,nil,2,REASON_RULE)
			end
		end
	end
end

function c65010020.filter2(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetAttack()>=2000 and c:IsAbleToGrave() 
end
function c65010020.filter3(c,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function c65010020.filter4(c,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetAttack()>=2000 and c:IsAbleToGrave() and c:IsRelateToEffect(e) 
end
function c65010020.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=eg:Filter(c65010020.filter2,nil)
	if chk==0 then return sg:GetCount()>0 and sg:IsExists(c65010020.filter3,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65010020.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c65010020.filter4,nil,e)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.GetMZoneCount(tp)>0 and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end