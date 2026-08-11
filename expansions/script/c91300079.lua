--最终龙王 提亚马特
function c91300079.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,c91300079.matfilter,1)
	c:EnableReviveLimit()
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(1,0)
	--e1:SetCost(c91300079.costchk)
	e1:SetTarget(c91300079.costtg)
	e1:SetOperation(c91300079.costop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91300079,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+91300079)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c91300079.cpcon)
	e2:SetCost(c91300079.cpcost)
	e2:SetTarget(c91300079.cptg)
	e2:SetOperation(c91300079.cpop)
	c:RegisterEffect(e2)
	--
	if not c91300079.global_check then
		c91300079.global_check=true
		local _RockPaperScissors=Duel.RockPaperScissors
		function Duel.RockPaperScissors(...)
			local p=_RockPaperScissors(...)
			Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+91300079,nil,0,p,p,0)
			return p
		end
	end
	if not CROSSROADS_ENTITY then
		CROSSROADS_ENTITY = true
		Crossroads_card_list={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetOperation(c91300079.regop)
		Duel.RegisterEffect(ge1,0)
	end
	--
	if not CROSSROADS_MORRA then
		CROSSROADS_MORRA = true
		Crossroads_morra_effect_list={}
		Crossroads_morra_win_effect_list={}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c91300079.clear)
		Duel.RegisterEffect(ge0,0)
	end
end
function c91300079.regop(e,tp,eg,ep,ev,re,r,rp)
	for _,code in pairs({91300063,91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
		local tc=Duel.CreateToken(0,code)
		Crossroads_card_list[code]=tc
	end
end
function c91300079.clear(e,tp,eg,ep,ev,re,r,rp)
	Crossroads_morra_effect_list={}
	Crossroads_morra_win_effect_list={}
end
function c91300079.matfilter(c)
	return c:IsOriginalCodeRule(9300420,10173087,33701339,91300067,91300073,91300079)
end
function c91300079.tgfilter(c)
	return c:IsOriginalCodeRule(9300420,10173087,33701339,91300067,91300073,91300079) and c:IsAbleToGrave()
end
function c91300079.costchk(e,te_or_c,tp)
	return Duel.GetFlagEffect(tp,91300079)==0 and Duel.IsExistingMatchingCard(c91300079.tgfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsAbleToGrave()
end
function c91300079.costtg(e,te,tp)
	e:SetLabelObject(te)
	return te:IsHasProperty(EFFECT_FLAG_COIN)
end
function c91300079.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if Duel.GetFlagEffect(tp,91300079)==0 and Duel.IsExistingMatchingCard(c91300079.tgfilter,tp,LOCATION_HAND,0,1,te:GetHandler()) and e:GetHandler():IsAbleToGrave() and c91300079.used_e~=e:GetLabelObject() and Duel.SelectYesNo(tp,aux.Stringid(91300079,2)) then
		c91300079.used_e=e:GetLabelObject()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c91300079.tgfilter,tp,LOCATION_HAND,0,1,1,te:GetHandler())
		g:AddCard(e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)
		Dead_Town_99_Check=true--morra;91300063
		local p=Duel.RockPaperScissors()
		if e:IsActivated() then
			Crossroads_morra_win_effect_list[aux.Stringid(91300079,0)]=c91300079.win
			if p==tp then
				Crossroads_morra_effect_list[aux.Stringid(91300079,1)]=c91300079.lost
			else
				Crossroads_morra_effect_list[aux.Stringid(91300079,0)]=c91300079.win
			end
		end
		if c91300079.win(e,p,eg,ep,ev,re,r,rp,0) then
			c91300079.win(e,p,eg,ep,ev,re,r,rp,1)
		end
		if c91300079.lost(e,1-p,eg,ep,ev,re,r,rp,0) then
			c91300079.lost(e,1-p,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c91300079.win(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={}
	if CROSSROADS_MORRA then
		for des,f in pairs(Crossroads_morra_win_effect_list) do
			local res=f(e,tp,eg,ep,ev,re,r,rp,0)
			if res then
				for _,v in pairs(t) do
					if v==des then res=false end
				end
			end
			if res then table.insert(t,des) end
		end
	end
	if chk==0 then
		return #t>0
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVEEFFECT)
		local sel=Duel.SelectOption(tp,table.unpack(t))
		local des=t[sel+1]
		local f=Crossroads_morra_win_effect_list[des]
		f(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c91300079.lost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	else
		Duel.RegisterFlagEffect(tp,91300079,RESET_PHASE+PHASE_END,0,1)
	end
end
function c91300079.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c91300079.tdfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsFaceupEx() and c:IsAbleToExtraAsCost()
end
function c91300079.gcheck(g,ec)
	return g:FilterCount(Card.IsType,nil,TYPE_FUSION)==1 and g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)==1 and g:FilterCount(Card.IsType,nil,TYPE_XYZ)==1 and g:IsContains(ec)
end
function c91300079.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c91300079.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return g:CheckSubGroup(c91300079.gcheck,3,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(tp,c91300079.gcheck,false,3,3,e:GetHandler())
	Duel.HintSelection(tg)
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c91300079.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=false
	for _,code in pairs({91300063,91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
		local tc=Crossroads_card_list[code]
		if code~=e:GetHandler():GetCode() and tc:CheckActivateEffect(false,true,false)~=nil then res=true break end
	end
	if chk==0 then return res and Duel.GetFlagEffect(tp,91300079)==0 end
end
function c91300079.cpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,91300079)~=0 then return end
	local codes={}
	for _,code in pairs({91300063,91300065,91300067,91300069,91300071,91300073,91300075,91300077,91300079,91300081,91300083}) do
		local tc=Crossroads_card_list[code]
		if tc:CheckActivateEffect(false,true,false)~=nil then
			table.insert(codes,code)
		end
	end
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
	local tc=Crossroads_card_list[ac]
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(0)--Original Property
end
