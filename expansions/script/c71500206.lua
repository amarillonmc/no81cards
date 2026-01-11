--命运预见『星星』
--命运预见『星星』
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Delayed Trigger
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(s.regcon)
	e1:SetOperation(s.regop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp) 
		and r&REASON_EFFECT~=0 
		and re and re:GetHandler() 
		and not re:GetHandler():IsSetCard(0x781) --Replace 0x333 with "Destiny Foresight" Setcode
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	--Select 5 random
	local pool={}
	for _,code in ipairs(s.pool) do
		table.insert(pool,code)
	end
	local selected_codes={}
	for i=1,5 do
		if #pool==0 then break end
		local idx=s.create()
		table.insert(selected_codes,pool[idx])
		table.remove(pool,idx)
	end
	
	local codes=selected_codes
	table.sort(codes)
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
	local ac=Duel.AnnounceCard(tp,table.unpack(opcodes))
	
	--Create and Add
	local tc=Duel.CreateToken(tp,ac)
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.create()
	local _TGetID=GetID
	while not ac do
		local int=Duel.GetRandomNumber(1,132000016)
		--continuously updated
		if int>132000000 and int<132000014 then int=int+739100000 end
		if int==132000014 then int=460524290 end
		if int==132000015 then int=978210027 end
		if int==132000016 then int=250000000 end
		if KOISHI_CHECK then
			local cc,ca,ctype=Duel.ReadCard(int,CARDDATA_CODE,CARDDATA_ALIAS,CARDDATA_TYPE)
			if cc then
				local dif=cc-ca
				local real=0
				if dif>-10 and dif<10 then
					real=ca
				else
					real=cc
				end
				if ctype&TYPE_TOKEN==0 and not cm.list(real) then
					ac=real
				end
			end
		else
			if not _G["c"..int] then
				_G["c"..int]={}
				_G["c"..int].__index=_G["c"..int]
			end
			GetID=function()
				return _G["c"..int],int,int<100000000 and 1 or 100
			end
			if pcall(function() dofile("expansions/script/c"..int..".lua") end) or pcall(function() dofile("script/c"..int..".lua") end) then
				_G["c"..int]=nil
				local bool,token=pcall(Duel.CreateToken,tp,int)
				if bool and not token:IsType(TYPE_TOKEN) then
					ac=token:GetCode()
				end
			end
		end
	end
	GetID=_TGetID
	return ac	
end