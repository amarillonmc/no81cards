--樱色的一等星 尽所有的光辉
function c28366214.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	--e1:SetCountLimit(1,28366214+EFFECT_COUNT_CODE_OATH)
	--e1:SetCondition(c28366214.condition)
	e1:SetTarget(c28366214.target)
	e1:SetOperation(c28366214.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+28322511)
	e2:SetOperation(c28366214.repop)
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
		ge1:SetTarget(c28366214.reptg)
		ge1:SetValue(aux.FALSE)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28366214.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c28366214.tfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsFaceup()-- and (c:IsLevelAbove(1) or c:IsRankAbove(1))
end
function c28366214.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28366214.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28366214.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c28366214.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c28366214.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or tc:IsImmuneToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(28366214,3))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(c28366214.efilter)
	e1:SetOwnerPlayer(tp)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	--discard
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28366214,2)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(#g*1700)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c28366214.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function c28366214.repfilter(c)
	return c:IsHasEffect(28322511) and c:GetDestination()==LOCATION_DECK --and c:IsLocation(LOCATION_GRAVE)
end
function c28366214.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c28366214.repfilter,nil)
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
function c28366214.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,28366214)
	Duel.DiscardDeck(tp,Duel.GetFieldGroupCount(tp,LOCATION_HAND,0),REASON_EFFECT)
end
