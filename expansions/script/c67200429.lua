--术结天缘砦 古娜拉库亚
function c67200429.initial_effect(c)
	c:EnableCounterPermit(0x671)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c67200429.ctcon)
	e1:SetOperation(c67200429.ctop1)
	c:RegisterEffect(e1) 
	--SendtoGrave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c67200429.target)
	e2:SetOperation(c67200429.activate)
	c:RegisterEffect(e2)
	--move to field zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200429,3))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,67200429)
	e3:SetTarget(c67200429.tftg)
	e3:SetOperation(c67200429.tfop)
	c:RegisterEffect(e3)   
end
--
function c67200429.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200429.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200429.ctfilter,1,nil,tp)
end
function c67200429.ctop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x671,1)>0 then
		local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x671,1)
		local ct=g:GetCount()
		if ct>0 then
			local tc=g:GetFirst()
			while tc do
				tc:AddCounter(0x671,1)
				tc=g:GetNext()
			end
		end
	end
end
--
function c67200429.tgfilter(c)
	return c:IsAbleToGrave() and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x5671)
end
function c67200429.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200429.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c67200429.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200429.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			local ct=g:GetFirst():GetOriginalLevel()
			if ct>0 and Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x671,1)>0
				and Duel.SelectYesNo(tp,aux.Stringid(67200429,0)) then
				while ct>0 do
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
					local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,1,nil,0x671,1):GetFirst()
					if not tc then break end
					tc:AddCounter(0x671,1)
					ct=ct-1
				end
			end
		end
	end
end
--
function c67200429.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200429.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end