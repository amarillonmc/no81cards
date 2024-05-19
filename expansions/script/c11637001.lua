--料理厨·银明
local s,id,o=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--copyname
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.cptg)
	e2:SetOperation(s.cpop)
	c:RegisterEffect(e2)
end

function s.setfilter(c)
	return c:IsSetCard(0xa221) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

function s.cpfilter(c,code)
	return c:IsSetCard(0xa221) and ((c:IsAbleToDeck() and c:IsLocation(LOCATION_GRAVE)) or c:IsLocation(LOCATION_DECK)) and not c:IsCode(code)
end
function s.opfilter(c,code)
	return ((c:IsAbleToDeck() and c:IsLocation(LOCATION_GRAVE)) or c:IsLocation(LOCATION_DECK)) and c:IsCode(code)
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,code) end
	local g=Duel.GetMatchingGroup(s.cpfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,code)
	local ag=Group.CreateGroup()
	local codes={}
	for tc in aux.Next(g) do
		local tc_code=tc:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,tc_code) then
			ag:AddCard(tc)
			table.insert(codes,tc_code)
		end
	end
	table.sort(codes)
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(ac)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.opfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,ac):GetFirst()
	if tc then
		if tc:IsLocation(LOCATION_GRAVE) then
			Duel.HintSelection(Group.FromCards(tc))
			Duel.SendtoDeck(tc,nil,2,REASON_COST)
		else
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleDeck(tp)
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_END)
		e2:SetOperation(s.tgop)
		e2:SetLabelObject(c)
		Duel.RegisterEffect(e2,tp)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)~=0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.SendtoGrave(tc,nil,REASON_EFFECT)
	end
	e:Reset()
end