--乞巧的一等星 进步的祈愿
function c28361677.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,28361677+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c28361677.target)
	e1:SetOperation(c28361677.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+28322511)
	e2:SetOperation(c28361677.repop)
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
		ge1:SetTarget(c28361677.reptg)
		ge1:SetValue(aux.FALSE)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28361677.chkfilter(c)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28361677.tgfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGrave()
end
function c28361677.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28361677.chkfilter,tp,LOCATION_HAND,0,nil)
	local ct=Duel.GetMatchingGroupCount(c28361677.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return e:IsCostChecked() and #g>0 and ct>0 end
	--if ct>#g then ct=#g end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,aux.dabcheck,false,1,ct)
	Duel.ConfirmCards(1-tp,cg)
	Duel.SetTargetCard(cg)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c28361677.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):GetCount()
	local g=Duel.GetMatchingGroup(c28361677.tgfilter,tp,LOCATION_DECK,0,nil)
	if #g>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:Select(tp,ct,ct,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c28361677.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c28361677.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRace(RACE_FAIRY) and ep==tp then
		Duel.SetChainLimit(c28361677.chainlm)
	end
end
function c28361677.chainlm(e,rp,tp)
	return tp==rp
end
function c28361677.repfilter(c)
	return c:IsHasEffect(28322511) and c:GetDestination()==LOCATION_DECK --and c:IsLocation(LOCATION_GRAVE)
end
function c28361677.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c28361677.repfilter,nil)
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
		for _,tc in ipairs(t) do Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+28322511,re,REASON_EFFECT,p,p,0) end
	end
	return false
end
function c28361677.lvfilter(c)
	return (c:IsLevelAbove(1) or c:IsRankAbove(1)) and c:IsRace(RACE_FAIRY) and c:IsFaceup()
end
function c28361677.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,28361677)
	local rc=re:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(3)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	rc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RANK)
	rc:RegisterEffect(e2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c28361677.lvfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	local e3=e1:Clone()
	tc:RegisterEffect(e3)
	local e4=e2:Clone()
	tc:RegisterEffect(e4)
end
