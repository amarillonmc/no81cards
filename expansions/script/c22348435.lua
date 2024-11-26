--拉特金的接触
function c22348435.initial_effect(c)
	--Activate
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetTarget(c22348435.target)
	e11:SetOperation(c22348435.activate)
	c:RegisterEffect(e11)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22348435)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22348435.eqtg)
	e2:SetOperation(c22348435.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
c22348435.has_text_type=TYPE_UNION
function c22348435.beqfilter(c,tp)
	return c:IsFaceup() --and c:IsSummonPlayer(1-tp)
end
function c22348435.eqfilter(c,e,tp)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and Duel.IsExistingMatchingCard(c22348435.eqfilter2,tp,LOCATION_GRAVE,0,1,c)
end
function c22348435.eqfilter2(c)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c22348435.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c22348435.beqfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c22348435.eqfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c22348435.beqfilter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,0,1,0,0)
end
function c22348435.filter2(c,e,tp)
	return c22348435.beqfilter(c,tp) and c:IsRelateToEffect(e)
end
function c22348435.gcheck(g,e,tp)
	return Duel.IsExistingMatchingCard(c22348435.eqfilter2,tp,LOCATION_GRAVE,0,g:GetCount(),g)

end
function c22348435.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c22348435.filter2,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ctg=Duel.GetMatchingGroup(c22348435.eqfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=Duel.GetMatchingGroup(c22348435.eqfilter,tp,LOCATION_GRAVE,0,nil,e,tp):GetCount()
	local tc=g:GetFirst()
	if not tc or ft<1 or ct<1 then return end
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	if ct>ft then
		ct=ft
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local cct=0
	local tg=ctg:SelectSubGroup(tp,c22348435.gcheck,false,1,ct,e,tp)
	local ec=tg:GetFirst()
	while ec do
		if Duel.Equip(tp,ec,tc)~=0 then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c22348435.eqlimit)
			e1:SetLabelObject(tc)
			ec:RegisterEffect(e1)
	cct=cct+1 end
		ec=tg:GetNext()
	end
	if Duel.IsExistingMatchingCard(c22348435.eqfilter2,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.BreakEffect()
		local ttg=Duel.SelectMatchingCard(tp,c22348435.eqfilter2,tp,LOCATION_GRAVE,0,cct,cct,nil)
		Duel.SendtoDeck(ttg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c22348435.eqlimit(e,c)
	return c==e:GetLabelObject()
end


function c22348435.cthfilter(c)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22348435.cspfilter(c,e,tp)
	return c:IsSetCard(0x970b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348435.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348435.cthfilter,tp,LOCATION_DECK,0,1,nil)
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348435.cspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c22348435.activate(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c22348435.cthfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(22348435,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348435.cspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
		ops[off]=aux.Stringid(22348435,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(1-tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c22348435.cthfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c22348435.cspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetFirst():IsLocation(LOCATION_MZONE) 
		then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
	end
end

