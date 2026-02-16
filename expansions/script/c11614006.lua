--雪域生灵 鹰崽
local s,id,o=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5226) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.ospfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c,e,tp)
	if #g>0 then
		g:AddCard(c)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==2 then
			Duel.BreakEffect()
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(1-tp,s.ospfilter,1-tp,LOCATION_DECK,0,1,1,nil,e,1-tp)
			local tc=sg:GetFirst()
			if tc then
				if Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP)>0 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_CANNOT_ACTIVATE)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					e3:SetValue(1)
					tc:RegisterEffect(e3)
				end
			end
		end
	end
end
function s.cfilter(c)
	return c:GetFlagEffect(id)>0 and c:IsFaceup()
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then return false end
	if not (re:GetHandler():IsSetCard(0x5226) and re:IsActiveType(TYPE_MONSTER) and rp==tp) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsControler,nil,1-tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
		local tc=g:GetFirst()
		if g:GetCount()>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetValue(s.remval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		tc:RegisterFlagEffect(11614056,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.remval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
