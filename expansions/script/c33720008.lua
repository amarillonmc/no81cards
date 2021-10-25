--水晶魔法小妖精 铃奈
function GetID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end
local s,id=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--stack decks
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e0:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e0:SetCondition(s.condition)
	e0:SetCost(aux.bfgcost)
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)
	--floodgates
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e1:SetRange(LOCATION_DECK)
	e1:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e1:SetCondition(s.fcon)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e1x)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DISCARD_DECK)
	e2:SetRange(LOCATION_DECK)
	e2:SetTargetRange(1,1)
	e2:SetCondition(s.fcon)
	c:RegisterEffect(e2)
	--count
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_REMOVE)
		Duel.RegisterEffect(ge2,0)
	end
end
--count
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetPreviousLocation()==LOCATION_DECK then
			Duel.RegisterFlagEffect(tc:GetControler(),id,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
--stack
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ct1,ct2=Duel.GetFlagEffect(tp,id),Duel.GetFlagEffect(1-tp,id)
	if not ct1 then ct1=0 end
	if not ct2 then ct2=0 end
	return ct1+ct2>=13
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1,ct2=Duel.GetFlagEffect(tp,id),Duel.GetFlagEffect(1-tp,id)
	if not ct1 then ct1=0 end
	if not ct2 then ct2=0 end
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct1+ct2 end
	e:GetHandler():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,Duel.GetFieldGroupCount(tp,0,LOCATION_DECK),ct1+ct2,0,0)
end
function s.deckseq(c,ct)
	return c:GetSequence()==ct
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct1,ct2=Duel.GetFlagEffect(tp,id),Duel.GetFlagEffect(1-tp,id)
	if not ct1 then ct1=0 end
	if not ct2 then ct2=0 end
	local dcount=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if dcount<ct1+ct2 then return end
	local g=Duel.GetDecktopGroup(1-tp,ct1+ct2)
	local tg=Group.CreateGroup()
	Duel.DisableShuffleCheck()
	for i=#g,1,-1 do
		local tc=g:Filter(s.deckseq,nil,dcount-i):GetFirst()
		if tc then
			tg:AddCard(tc)
		end		
	end
	if #tg~=#g then return end
	for tc in aux.Next(tg) do
		Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToDeck() and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.SendtoDeck(c,tp,0,REASON_EFFECT)
		if c:IsLocation(LOCATION_DECK) then
			c:ReverseInDeck()
		end
	end
end
--floodgates
function s.fcon(e)
	return e:GetHandler():IsFaceup()
end