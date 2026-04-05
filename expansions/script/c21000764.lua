--秒出警
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(2,id+EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(s.target)
	e0:SetOperation(s.prop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.con)
	e1:SetTarget(s.target2)
	e1:SetOperation(s.prop2)
	c:RegisterEffect(e1)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x606) and c:IsAbleToRemove() and c:IsType(TYPE_SPELL)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a = false
	local ct=Duel.GetCurrentChain()
	if ct>=2 then 
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		a = tep==1-tp and e:IsHasType(EFFECT_TYPE_ACTIVATE)
	end
	
	local b = a and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
	
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	if b then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_HAND)
	end
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
		
		local ct=Duel.GetCurrentChain()
		local a = false
		if ct>=2 then 
			local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			a = tep==1-tp and e:IsHasType(EFFECT_TYPE_ACTIVATE)
		end
		if a and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter1),tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g0=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter1),tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
			if g0:GetCount()>0 then
				Duel.SpecialSummon(g0,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end


function s.filter(c,e,tp)
	return c:IsCode(21000763) and c:IsFaceup()
end
function s.filter0(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsCode(21000763) and c:IsFaceupEx()
end
function s.filter2(c,e,tp)
	local sq=4-c:GetSequence()
	local zone = 2^sq
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and aux.NegateEffectMonsterFilter(c) and Duel.IsExistingMatchingCard(s.filter0,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter2(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local sq=4-tc:GetSequence()
		local zone = 2^sq
		if zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter0),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter0),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
			if g:GetCount()~=0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)~=0 and aux.NegateEffectMonsterFilter(tc) then
			
			
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
				Duel.AdjustInstantly()
			end
		end
		
		
	end
end
function s.spfilter1(c,e,tp)
	return c:IsCode(21000763) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end