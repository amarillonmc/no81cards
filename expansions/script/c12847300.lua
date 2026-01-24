--青眼大师
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89631139,5405694,23995346)
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(0xff)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsCode(89631139) or aux.IsCodeListed(c,89631139)
end
function s.check(c)
	return c:GetOriginalCode()==id
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(s.check,tp,0xff,0,nil)
	if #cg>=2 then
		local ag=cg:RandomSelect(tp,#cg-1)
		for tc in aux.Next(ag) do
			tc:SetEntityCode(89631139)
			if not tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(tp,tc) end
		end
	end
	local g2=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if #g2>=15 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(id,5))
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(s.thcon)
		e1:SetOperation(s.thop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,3))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCondition(s.setcon)
		e2:SetOperation(s.setop)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(id,1))
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,tp)
		--
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(197042,2))
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_FREE_CHAIN)
		e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetCurrentChain()==0 and Duel.IsMainPhase() end)
		Duel.RegisterEffect(e5,tp)
	end
	c:SetEntityCode(89631139)
	if not c:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(tp,c) end
	if Duel.GetMatchingGroupCount(Card.IsOriginalCodeRule,tp,0xff,0,nil,89631139)>3 then	
		Debug.Message("因违反卡组只能投入三张同名卡的规则而判负")
		local WIN_REASON_CREATORGOD=0x13
		Duel.Win(1-tp,WIN_REASON_CREATORGOD)
	end
end
function s.thfilter(c)
	return (c:IsCode(89631139) or aux.IsCodeListed(c,89631139))
end
function s.cfilter(c)
	return c:IsSetCard(0xdd) and not c:IsPublic()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsMainPhase() and Duel.GetFlagEffect(tp,id)==0 
	and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(id,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg2=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #sg2>0 then
		local tc=sg2:GetFirst()
		local token=Duel.CreateToken(tp,tc:GetOriginalCode())
		Duel.Exile(tc,REASON_RULE)
		Duel.SendtoHand(token,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,token)
	end
	Duel.BreakEffect()
	local g=Group.CreateGroup()
	local token1=Duel.CreateToken(tp,23995346)
	g:AddCard(token1)
	local token2=Duel.CreateToken(tp,5405694)
	g:AddCard(token2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	Duel.RegisterEffect(e2,tp)
	Duel.SendtoGrave(g,REASON_RULE)
	Duel.RegisterFlagEffect(tp,id,0,0,1)
	e1:Reset()
	e2:Reset()
end
function s.cfilter2(c)
	return c:IsSetCard(0xdd) and c:IsFaceup()
end
function s.setfilter(c)
	return aux.IsCodeListed(c,89631139) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsMainPhase() and Duel.GetFlagEffect(tp,id+1)==0
	and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0
	and (Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil)
	or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0)
	and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(id,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #sg>0 then
		local dc=sg:GetFirst()
		Duel.MoveToField(dc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		Duel.ConfirmCards(1-tp,dc)
		if dc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,4))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			dc:RegisterEffect(e1)
		end
		if dc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,4))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			dc:RegisterEffect(e1)
		end
	end
	Duel.RegisterFlagEffect(tp,id+1,0,0,1)
end