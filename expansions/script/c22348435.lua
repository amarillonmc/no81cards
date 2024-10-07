--拉特金的接触
function c22348435.initial_effect(c)
	--Activate
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
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
	return c:IsFaceup() and c:IsSummonPlayer(1-tp)
end
function c22348435.eqfilter(c)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and Duel.IsExistingMatchingCard(c22348435.eqfilter2,c:GetControler(),LOCATION_GRAVE,0,1,c)
end
function c22348435.eqfilter2(c)
	return c:IsSetCard(0x970b) and c:IsAbleToDeck()
end
function c22348435.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c22348435.beqfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c22348435.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
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
	local ctg=Duel.GetMatchingGroup(c22348435.eqfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=Duel.GetMatchingGroup(c22348435.eqfilter,tp,LOCATION_GRAVE,0,nil):GetCount()
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
		if Duel.Equip(tp,ec,tc,true,true)~=0 then 
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
function c22348435.thfilter(c,tp)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(c22348435.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c22348435.cfilter(c,code)
	return c:IsCode(code) and (c:IsFaceup() or not c:IsOnField())
end
function c22348435.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348435.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348435.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c22348435.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c22348435.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x970b) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c22348435.refilter(c)
	return c:IsSetCard(0x970b) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function c22348435.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c22348435.refilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,c) and eg:IsExists(c22348435.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c22348435.repval(e,c)
	return c22348435.repfilter(c,e:GetHandlerPlayer())
end
function c22348435.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22348435.refilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=g:Select(tp,2,2,nil)
	dg:AddCard(c)
	Duel.ConfirmCards(1-tp,dg)
	Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

