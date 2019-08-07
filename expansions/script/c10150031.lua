--极速疾驰
function c10150031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10150031+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10150031.target)
	e1:SetOperation(c10150031.activate)
	c:RegisterEffect(e1)	
end
function c10150031.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10150031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10150031.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10150031.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsPlayerCanSpecialSummonCount(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10150031.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10150031.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
	local g=Duel.GetMatchingGroup(c10150031.filter,tp,LOCATION_MZONE,0,tc)
	if g:GetCount()<=0 then return end
	local sg=Duel.GetMatchingGroup(c10150031.sfilter,tp,LOCATION_EXTRA,0,nil,g,tc)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10150031,0)) then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local sc=sg:Select(tp,1,1,nil):GetFirst()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	   local mat=g:FilterSelect(tp,c10150031.sfilter2,1,1,nil,sc,tc)
	   mat:AddCard(tc)
	   Duel.SynchroSummon(tp,sc,nil,mat)
	end 
end
function c10150031.filter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c10150031.sfilter(c,mg,tc)
	return mg:IsExists(c10150031.sfilter2,1,nil,c,tc)
end
function c10150031.sfilter2(c,sc,tc)
	local mg=Group.FromCards(c,tc)
	return sc:IsSynchroSummonable(nil,mg)
end
