--魔导飞行队 芙萝丝忒·诺娃
local cm,m=GetID()
function cm.initial_effect(c)
	if not PNFL_PROPHECY_FLIGHT_CHECK then
		dofile("expansions/script/c11451851.lua")
		pnfl_prophecy_flight_initial(c)
	end
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--road to the top
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK)
	e2:SetCondition(function(e) return e:GetHandler():IsFaceup() end)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
	local e7=e2:Clone()
	e7:SetCode(EVENT_MOVE)
	--c:RegisterEffect(e7)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(11451851)
	--e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(function(e) return e:GetHandler():IsFaceup() end)
	c:RegisterEffect(e3)
	--I have the highground!
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_DECK)
	e4:SetCondition(function(e,tp) return e:GetHandler():IsFaceup() and Duel.GetDecktopGroup(tp,1):IsContains(e:GetHandler()) end)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetCountLimit(1)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e6)
end
cm.toss_coin=true
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x6e) and c:IsLevel(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if PNFL_PROPHECY_FLIGHT_TACTIC_VIEW then
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_DECK,0,nil,11451851)
			local g1=g:Filter(pnflpf.tdfilter,nil)
			local g2=g-g1
			local tpg=Group.CreateGroup()
			if #g1>0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,6))
				Duel.DisableShuffleCheck()
				Group.SelectUnselect(g1,tpg,tp,true,true,#g1,#g1)
			end
			if #g2>0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,7))
				Duel.DisableShuffleCheck()
				Group.SelectUnselect(g2,tpg,tp,true,true,#g2,#g2)
			end
			tpg:DeleteGroup()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if c:IsRelateToEffect(e) then
		local res=Duel.TossCoin(tp,1)
		if PNFL_PROPHECY_FLIGHT_DEBUG then res=1 end
		if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT) and c:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(c:GetControler())
			if res==1 then c:ReverseInDeck() end
		end
	end
end
function cm.topfilter(c)
	return c:GetFlagEffect(11451851)>0
end
function cm.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function cm.labfilter(c,seq)
	return c:GetFlagEffectLabel(11451851)==seq
end
function cm.labseqfilter(c,ct)
	return c:GetFlagEffectLabel(11451851)+c:GetSequence()~=ct
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	pnfl_adjusting=true
	local c=e:GetHandler()
	if PNFL_PROPHECY_FLIGHT_DEBUG then Debug.Message("adjust"..c:GetCode()) end
	c:ReverseInDeck()
	pnflpf.resetop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_DECK,0,nil,11451851)
	local sg=tg:Filter(cm.topfilter,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if #sg~=#tg then
		if PNFL_PROPHECY_FLIGHT_DEBUG then Debug.Message("selecttop"..c:GetCode()) end
		local fc
		if #tg>1 and PNFL_PROPHECY_FLIGHT_OPERATION_PERMIT then
			if PNFL_PROPHECY_FLIGHT_TACTIC_VIEW then
				local g1=tg:Filter(pnflpf.tdfilter,nil)
				local tpg=Group.CreateGroup()
				if #g1>0 then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,6))
					Duel.DisableShuffleCheck()
					Group.SelectUnselect(g1,tpg,tp,true,true,#g1,#g1)
				end
				tpg:DeleteGroup()
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,1))
			fc=tg:Select(tp,1,1,nil):GetFirst()
		end
		if #Group.__band(Duel.GetDecktopGroup(tp,#tg),tg)~=#tg then
			if fc then tg:RemoveCard(fc) end
			for tc in aux.Next(tg) do
				Duel.MoveSequence(tc,0)
				tc:ReverseInDeck()
			end
		end
		if fc then tg:AddCard(fc) Duel.MoveSequence(fc,0) end
		if #tg>1 and not PNFL_PROPHECY_FLIGHT_OPERATION_PERMIT then
			if PNFL_PROPHECY_FLIGHT_TACTIC_VIEW then
				local g1=tg:Filter(pnflpf.tdfilter,nil)
				local tpg=Group.CreateGroup()
				if #g1>0 then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,6))
					Duel.DisableShuffleCheck()
					Group.SelectUnselect(g1,tpg,tp,true,true,#g1,#g1)
				end
				tpg:DeleteGroup()
			end
			Duel.SortDecktop(tp,tp,#tg)
		end
		for i=1,#tg do
			local tc=tg:Filter(cm.seqfilter,nil,ct-i):GetFirst()
			tc:RegisterFlagEffect(11451851,RESET_EVENT+RESETS_STANDARD,0,1,i)
			tc:ReverseInDeck()
		end
	elseif tg:IsExists(cm.labseqfilter,1,nil,ct) then
		if PNFL_PROPHECY_FLIGHT_DEBUG then Debug.Message("move"..c:GetCode()) end
		for i=#tg,1,-1 do
			local tc=tg:Filter(cm.labfilter,nil,i):GetFirst()
			Duel.MoveSequence(tc,0)
			tc:ReverseInDeck()
		end
	end
	pnfl_adjusting=false
end
function cm.tgfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsOnField()
end
function cm.nfilter(c,g)
	return g:IsExists(cm.nnfilter,1,nil,c)
end
function cm.nnfilter(c,tc)
	local seq=c:GetSequence()
	local s=tc:GetSequence()
	local tp=tc:GetControler()
	local loc=tc:GetLocation()
	return c==tc or (s<5 and seq<5 and math.abs(seq-s)<=1 and c:IsControler(tp) and c:IsLocation(loc))
end
function cm.dsfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.tfilter(c)
	return c:IsFacedown() and c:IsOnField()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(cm.tgfilter,nil,re)
	local fg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ng=Duel.GetMatchingGroup(cm.dsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	g=g:Filter(cm.nfilter,nil,ng)
	if #g>0 and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		local tc=g:GetFirst()
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			tc=g:Select(tp,1,1,nil):GetFirst()
		end
		Duel.Hint(HINT_CARD,0,m)
		local rg=ng:Filter(cm.nnfilter,nil,tc)
		Duel.HintSelection(rg)
		for tc in aux.Next(rg) do tc:CancelToGrave() end
		if Duel.ChangePosition(rg,POS_FACEDOWN)>0 then
			rg=rg:Filter(cm.tfilter,nil)
			for tc in aux.Next(rg) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
				tc:RegisterEffect(e2)
			end
		end 
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetTurnID()~=Duel.GetTurnCount() or Duel.SelectYesNo(tp,aux.Stringid(11451851,2)) then
		Duel.DisableShuffleCheck()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end