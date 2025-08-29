--出千
local s,id,o=GetID()
function s.initial_effect(c)
	--xmat
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(s.xcon)
	e1:SetOperation(s.xop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.lostcon)
		ge1:SetOperation(s.lostop)
		Duel.RegisterEffect(ge1,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SUMMON)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_SPSUMMON)
		Duel.RegisterEffect(ge4,0)
		--to szone
		local ge21=Effect.CreateEffect(c)
		ge21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge21:SetCode(EVENT_SSET)
		ge21:SetCondition(s.dtoscon)
		ge21:SetOperation(s.dtosop)
		Duel.RegisterEffect(ge21,0)
		--to deck
		local ge22=ge21:Clone()
		ge22:SetCondition(s.stodcon)
		ge22:SetOperation(s.stodop)
		Duel.RegisterEffect(ge22,0)

		local _ConfirmCards=Duel.ConfirmCards
		function Duel.ConfirmCards(player,targets)
			_ConfirmCards(player,targets)
			if aux.GetValueType(targets)=="Card" then
				local tc=targets
				if tc:GetOriginalCode()==id and tc:GetOwner()~=player then
					Duel.Hint(HINT_CARD,0,86541496)
					Duel.Win(player,0x0)
				end
			end
			if aux.GetValueType(targets)=="Group" then
				local sg=targets
				for tc in aux.Next(sg) do
					if tc:GetOriginalCode()==id and tc:GetOwner()~=player then
						Duel.Hint(HINT_CARD,0,86541496)
						Duel.Win(player,0x0)
					end
				end
			end
		end
		local _SSet=Duel.SSet
		function Duel.SSet(player,targets,tplayer,bool)
			if not tplayer then tplayer=player end
			if not bool then bool=true end
			local lost=false
			if bool==true then
				if aux.GetValueType(targets)=="Card" then
					local tc=targets
					if tc:GetOriginalCode()==id and tc:GetOwner()==tplayer then
						local lost=true
					end
				elseif aux.GetValueType(targets)=="Group" then
					local sg=targets
					for tc in aux.Next(sg) do
						if tc:GetOriginalCode()==id and tc:GetOwner()==tplayer then
							local lost=true
						end
					end
				end
			end
			local count=_SSet(player,targets,tplayer,bool)
			if lost then
				Duel.Hint(HINT_CARD,0,86541496)
				Duel.Win(1-tplayer,0x0)
			end
			return count
		end
		local _SortDecktop=Duel.SortDecktop
		function Duel.SortDecktop(sort_player,target_player,count)
			_SortDecktop(sort_player,target_player,count)
			local sg=Duel.GetDecktopGroup(target_player,count)
			for tc in aux.Next(sg) do
				if tc:GetOriginalCode()==id and tc:GetOwner()~=sort_player then
					Duel.Hint(HINT_CARD,0,86541496)
					Duel.Win(sort_player,0x0)
				end
			end
		end
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.ChangeCard(card1,card2,seq)
	if not KOISHI_CHECK then return end
	local code1=card1:GetOriginalCode()
	local code2=card2:GetOriginalCode()
	if card1:IsLocation(LOCATION_DECK) then
		Duel.DisableShuffleCheck()
		Duel.Exile(card1,REASON_RULE)
		Duel.SendtoDeck(Duel.CreateToken(card1:GetControler(),code2),tp,seq,REASON_RULE)
	else
		Duel.DisableShuffleCheck()
		card1:ReplaceEffect(code2,0,0)
		card1:SetEntityCode(code2)
		s.addremain(card1,card2)
		Duel.RaiseEvent(card1,EVENT_CUSTOM+65131100,Effect.GlobalEffect(),0,0,0,0)
		Duel.RaiseSingleEvent(card1,EVENT_CUSTOM+65131100,Effect.GlobalEffect(),0,0,0,0)
	end   
	if card2:IsLocation(LOCATION_DECK) then
		Duel.DisableShuffleCheck()
		Duel.Exile(card2,REASON_RULE)
		Duel.SendtoDeck(Duel.CreateToken(card2:GetControler(),code1),tp,seq,REASON_RULE)
	else
		Duel.DisableShuffleCheck()
		card2:ReplaceEffect(code1,0,0)
		card2:SetEntityCode(code1)
		s.addremain(card2,card1)
		Duel.RaiseEvent(card2,EVENT_CUSTOM+65131100,Effect.GlobalEffect(),0,0,0,0)
		Duel.RaiseSingleEvent(card2,EVENT_CUSTOM+65131100,Effect.GlobalEffect(),0,0,0,0)
	end  
end
function s.addremain(c,cc)
	local fe=cc:GetCardRegistered(s.fefilter,GETEFFECT_INITIAL)
	if not fe then return end
	local code=cc:GetOriginalCode()
	local fe2=fe:Clone()
	fe:SetCondition(function (code)
		return function(e,tp,eg,ep,ev,re,r,rp)
			if e:GetHandler():GetOriginalCode()==code then
				return true
			else
				e:Reset()
				return false
			end
		end
	end)
	c:RegisterEffect(fe2)
end
function s.fefilter(e)
	return e:GetCode()==EFFECT_REMAIN_FIELD
end
function s.lostfilter(c)
	if c:GetOriginalCode()~=id then return false end
	if c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA) then
		return c:IsFaceupEx()
	end
	if c:IsLocation(LOCATION_HAND) then
		return c:IsPublic()
	end
	if c:IsLocation(LOCATION_DECK) then
		return Duel.GetDecktopGroup(c:GetControler(),1):IsContains(c) and Duel.IsPlayerAffectedByEffect(c:GetControler(),EFFECT_REVERSE_DECK) or c:IsFaceup()
	end
end
function s.lostcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.lostfilter,0,0x7f,0x7f,1,nil)
end
function s.lostop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,86541496)
	local g=Duel.GetMatchingGroup(s.lostfilter,0,0x7f,0x7f,nil)
	local Islost1=false
	local Islost2=false
	for tc in aux.Next(g) do
		if tc:GetOwner()==0 then Islost1=true end
		if tc:GetOwner()==1 then Islost2=true end
	end
	if Islost1 and not Islost2 then Duel.Win(1,0x0)
	elseif not Islost1 and Islost2 then Duel.Win(0,0x0)
	else Duel.Win(PLAYER_NONE,0x0) end
end
function s.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.xop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,86541496)
	local g=Duel.GetOverlayGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local Islost1=false
	local Islost2=false
	for tc in aux.Next(g) do
		if tc:GetOriginalCode()==id and tc:GetOwner()==0 then Islost1=true end
		if tc:GetOriginalCode()==id and tc:GetOwner()==1 then Islost2=true end
	end
	if Islost1 and not Islost2 then Duel.Win(1,0x0)
	elseif not Islost1 and Islost2 then Duel.Win(0,0x0)
	else Duel.Win(PLAYER_NONE,0x0) end
end
function s.dtosfilter(c)
	return c:IsSetCard(0x836) and c:GetOriginalCode()~=id and c:GetSequence()==2
end
function s.dtosfilter2(c)
	return c:GetOriginalCode()==id
end
function s.dtoscon(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(s.dtosfilter,1,nil) then return end
	local sg=eg:Filter(s.dtosfilter,nil)
	local Issset1=false
	local Issset2=false
	local tc=sg:GetFirst() 
	while tc do
		if tc:GetControler()==0 then Issset1=true end
		if tc:GetControler()==1 then Issset2=true end
		tc=sg:GetNext()
	end
	if Issset1 and not Issset2 then return Duel.IsExistingMatchingCard(s.dtosfilter2,0,LOCATION_DECK,0,1,nil)
	else if not Issset1 and Issset2 then return Duel.IsExistingMatchingCard(s.dtosfilter2,1,LOCATION_DECK,0,1,nil)
	else Duel.IsExistingMatchingCard(s.dtosfilter2,0,LOCATION_DECK,LOCATION_DECK,1,nil) end end 
end
function s.dtosop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(s.dtosfilter,nil)
	local tc=sg:GetFirst() 
	while tc do
		local cc=Duel.GetMatchingGroup(s.dtosfilter2,tc:GetControler(),LOCATION_DECK,0,nil,id):GetFirst()
		if cc and tc then s.ChangeCard(cc,tc,0) end
		tc=sg:GetNext()
	end
end

function s.stodfilter(c)
	return c:GetOriginalCode()==id and (c:GetSequence()==0 or c:GetSequence()==4)
end
function s.stodfilter2(c)
	return c:IsSetCard(0x836) and c:GetOriginalCode()~=id
end
function s.stodcon(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(s.stodfilter,1,nil) then return end
	local sg=eg:Filter(s.stodfilter,nil)
	local tc=sg:GetFirst() 
	while tc do
		if tc:GetControler()==0 and Duel.IsExistingMatchingCard(s.stodfilter2,0,LOCATION_DECK,0,1,nil) then return true end
		if tc:GetControler()==1 and Duel.IsExistingMatchingCard(s.stodfilter2,1,LOCATION_DECK,0,1,nil) then return true end
		tc=sg:GetNext()
	end
	return false
end
function s.stodop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(s.stodfilter,nil)
	local tc=sg:GetFirst() 
	while tc do
		if Duel.IsExistingMatchingCard(s.stodfilter2,tc:GetControler(),LOCATION_DECK,0,1,nil) then
			local cc=Duel.SelectMatchingCard(tc:GetControler(),s.stodfilter2,tc:GetControler(),LOCATION_DECK,0,1,1,nil):GetFirst()
			s.ChangeCard(cc,tc,1)
		end
		tc=sg:GetNext()
	end
end