--纯白的一等星 爱之誓言
function c28366501.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES_SELF+CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,28366501+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c28366501.target)
	e1:SetOperation(c28366501.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+28322511)
	e2:SetOperation(c28366501.repop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(28322511)
	e0:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e0)
	--global
	if not ILLUMINA_REPLACE_GLOBAL then
		ILLUMINA_REPLACE_GLOBAL = true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EFFECT_SEND_REPLACE)
		ge1:SetTarget(c28366501.reptg)
		ge1:SetValue(aux.FALSE)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28366501.thfilter(c)
	return c:IsSetCard(0x284) and c:IsLevel(4) and c:IsAbleToHand()
end
function c28366501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28366501.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c28366501.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local codes={}
	if g:IsExists(Card.IsCode,1,nil,28315443) then table.insert(codes,28315443) end
	if g:IsExists(Card.IsCode,1,nil,28315548) then table.insert(codes,28315548) end
	if g:IsExists(Card.IsCode,1,nil,28315746) then table.insert(codes,28315746) end
	table.sort(codes)
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c28366501.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil):Filter(Card.IsCode,nil,ac)
	if #g==0 then return end
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tc=g:FilterSelect(tp,Card.IsCode,1,1,nil,ac):GetFirst()
	end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
	local e0=Effect.CreateEffect(e:GetHandler())
	if tc:IsCode(28315443) then
		e0:SetDescription(aux.Stringid(28366501,1))
	elseif tc:IsCode(28315548) then
		e0:SetDescription(aux.Stringid(28366501,2))
	elseif tc:IsCode(28315746) then
		e0:SetDescription(aux.Stringid(28366501,3))
	end
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(0x20000000+28366501)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e0:SetTargetRange(1,0)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	--limit
	local ge1=Effect.CreateEffect(e:GetHandler())
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetCode(EFFECT_MUST_BE_FMATERIAL)
	ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ge1:SetRange(LOCATION_MZONE)
	ge1:SetTargetRange(1,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,ac))
	e1:SetLabelObject(ge1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local ge2=ge1:Clone()
	ge2:SetCode(EFFECT_MUST_BE_SMATERIAL)
	local e2=e1:Clone()
	e2:SetLabelObject(ge2)
	Duel.RegisterEffect(e2,tp)
	local ge3=ge1:Clone()
	ge3:SetCode(EFFECT_MUST_BE_XMATERIAL)
	local e3=e1:Clone()
	e3:SetLabelObject(ge3)
	Duel.RegisterEffect(e3,tp)
	local ge4=ge1:Clone()
	ge4:SetCode(EFFECT_MUST_BE_LMATERIAL)
	local e4=e1:Clone()
	e4:SetLabelObject(ge4)
	Duel.RegisterEffect(e4,tp)
end
function c28366501.repfilter(c)
	return c:IsHasEffect(28322511) and c:GetDestination()==LOCATION_DECK --and c:IsLocation(LOCATION_GRAVE)
end
function c28366501.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c28366501.repfilter,nil)
	if chk==0 then return #tg>0 and bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284) end
	for p in aux.TurnPlayers() do
		local g=tg:Filter(Card.IsControler,nil,p)
		local ops,t={aux.Stringid(28384553,3)},{}
		for tc in aux.Next(g) do table.insert(ops,aux.Stringid(tc:GetOriginalCode(),0)) table.insert(t,tc) end
		if #g>1 then
			while #t>1 do
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_RESOLVEEFFECT)
				local sel=Duel.SelectOption(p,table.unpack(ops))
				if sel~=0 then
					local tc=t[sel]
					Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+28322511,re,REASON_EFFECT,p,p,0)
					--tc.replace_operation(e,p,eg,ep,ev,re,r,rp)
					table.remove(ops,sel+1)
					table.remove(t,sel)
				else break end
			end
		end
		for _,tc in ipairs(t) do Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+28366501,re,REASON_EFFECT,p,p,0) end
	end
	return false
end
function c28366501.repop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_DECK_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(LOCATION_HAND)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1)
	e2:SetOperation(c28366501.chkop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOHAND+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e2)
end
function c28366501.chkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.ShuffleHand(tp)
end
