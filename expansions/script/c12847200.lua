--师徒之绊
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121,13604200,60709218,86509711,75190122,1784686)
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
function s.check(c)
	return c:GetOriginalCode()==id
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(s.check,tp,0xff,0,nil)
	if #cg>=2 then
		local ag=cg:RandomSelect(tp,#cg-1)
		for tc in aux.Next(ag) do
			tc:SetEntityCode(46986414)
			if not tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(tp,tc) end
		end
	end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(id,5))
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetTarget(s.splimit1)
	Duel.RegisterEffect(e0,tp)
	local e0_1=Effect.CreateEffect(c)
	e0_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e0_1,tp)
	local e0_2=Effect.CreateEffect(c)
	e0_2:SetDescription(aux.Stringid(id,0))
	e0_2:SetType(EFFECT_TYPE_FIELD)
	e0_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e0_2:SetTargetRange(1,0)
	Duel.RegisterEffect(e0_2,tp)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD,0)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(s.ntcon)
	e1:SetTarget(s.filter0)
	Duel.RegisterEffect(e1,tp)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetDescription(aux.Stringid(id,2))
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1_1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1_1,tp)
	--
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,46986414))
	Duel.RegisterEffect(e2,tp)
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetDescription(aux.Stringid(id,4))
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2_1:SetTargetRange(1,0)
	Duel.RegisterEffect(e2_1,tp)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,6))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(s.drcon)
	e3:SetOperation(s.drop)
	Duel.RegisterEffect(e3,tp)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,9))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(s.setcon)
	e4:SetOperation(s.setop)
	Duel.RegisterEffect(e4,tp)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,11))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(s.adcon)
	e5:SetOperation(s.adop)
	Duel.RegisterEffect(e5,tp)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,12))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetCurrentChain()==0 and Duel.IsMainPhase() end)
	Duel.RegisterEffect(e6,tp)
	--
	c:SetEntityCode(46986414)
	if not c:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(tp,c) end
	if Duel.GetMatchingGroupCount(Card.IsOriginalCodeRule,tp,0xff,0,nil,46986414)>3 then	
		Debug.Message("因违反卡组只能投入三张同名卡的规则而判负")
		local WIN_REASON_CREATORGOD=0x13
		Duel.Win(1-tp,WIN_REASON_CREATORGOD)
	end
end
function s.filter0(e,c)
	return c:IsCode(46986414,38033121)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.splimit1(e,c)
	return not c:IsRace(RACE_SPELLCASTER) and not c:IsLocation(LOCATION_EXTRA)
end
function s.thfilter(c)
	return c:IsCode(46986414)
end
function s.cfilter(c)
	return aux.IsCodeListed(c,46986414) and not c:IsPublic()
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsMainPhase() and Duel.GetFlagEffect(tp,id)==0 
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(id,6))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #sg>0 and Duel.SendtoDeck(sg,nil,1,REASON_RULE)>0 then
		local res=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,46986414) 
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		local op=aux.SelectFromOptions(tp,{true,aux.Stringid(id,7)},{res,aux.Stringid(id,8)})
		if op==1 then
			local g=Duel.GetDecktopGroup(tp,1)
			local ec=g:GetFirst()
			local code=ec:GetOriginalCode()
			Duel.Exile(ec,REASON_RULE)
			local token=Duel.CreateToken(tp,code)
			Duel.SendtoHand(token,nil,REASON_RULE)
		elseif op==2 then
			local sg2=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if #sg2>0 then
				Duel.SendtoHand(sg2,nil,REASON_RULE)
				Duel.ConfirmCards(1-tp,sg2)
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
				Duel.DiscardDeck(tp,1,REASON_RULE)
				e1:Reset()
				e2:Reset()
			end
		end
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.cfilter2(c)
	return c:IsCode(46986414,38033121) and not c:IsPublic()
end
function s.setfilter(c)
	return c:IsCode(13604200,60709218,86509711)
end
function s.tffilter(c)
	return c:IsCode(46986414,38033121)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsMainPhase() and Duel.GetFlagEffect(tp,id+o)==0
	and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(id,9))
	local g1=Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	local ct1=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ct2=g2:GetClassCount(Card.GetCode)
	if ct2<=ct1 then ct2=ct1 end
	if ct2<=#g1 then ct2=#g1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g1:Select(tp,1,ct2,nil)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg2=g2:SelectSubGroup(tp,aux.dncheck,false,#sg1,#sg1,nil)
	if #sg2==0 then return end
	for tc in aux.Next(sg2) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(id,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		if tc:IsType(TYPE_TRAP) then
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(id,2))
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	Duel.ConfirmCards(1-tp,sg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg3=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.MoveToField(sg3:GetFirst(),tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	Duel.RegisterFlagEffect(tp,id+o,0,0,1)
end
function s.cfilter4(c)
	return c:IsCode(60709218) and not c:IsPublic()
end
function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
	return Duel.GetCurrentChain()==0 and Duel.IsMainPhase() and Duel.GetFlagEffect(tp,id+o*2)==0
	and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and 
	(res or Duel.IsExistingMatchingCard(s.cfilter4,tp,LOCATION_HAND,0,1,nil))
end
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(id,11))
	local check=false
	local res=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
	if res and not (Duel.IsExistingMatchingCard(s.cfilter4,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,13))) then
		check=true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	if not check then
		local cg=Duel.SelectMatchingCard(tp,s.cfilter4,tp,LOCATION_HAND,0,1,1,nil)
		if #cg>0 then
			Duel.ConfirmCards(1-tp,cg)
			Duel.ShuffleHand(tp)
			check=true
		end
	end
	if check then
		Duel.DiscardHand(tp,nil,1,1,REASON_RULE,nil)
		local token1=Duel.CreateToken(tp,1784686)
		Duel.SendtoHand(token1,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,token1)
		Duel.BreakEffect()
		local token2=Duel.CreateToken(tp,75190122)
		Duel.SendtoDeck(token2,nil,SEQ_DECKTOP,REASON_EFFECT)
		Duel.ConfirmCards(tp,token2)
		Duel.ConfirmCards(1-tp,token2)
	end
	Duel.RegisterFlagEffect(tp,id+o*2,0,0,1)
end