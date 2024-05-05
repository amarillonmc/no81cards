if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s[0]=Duel.SetChainLimit
		s[1]=Duel.SetChainLimitTillChainEnd
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function s.filter(c,tp)
	return c:IsCode(94145021,130006048,130006049) and c:IsAbleToHand(1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	if #g==0 then return end
	local t={}
	for i=1,g:GetClassCount(Card.GetCode) do table.insert(t,i) end
	local d=Duel.AnnounceNumber(tp,table.unpack(t))
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local og=Group.CreateGroup()
	if Duel.Draw(p,d,REASON_EFFECT)==d then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,d,d)
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
		og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
		Duel.ShuffleHand(p)
	end
	if #og>0 then
		local c=e:GetHandler()
		local code_table={}
		for tc in aux.Next(og) do
			local codes={tc:GetCode()}
			for i=1,#codes do table.insert(code_table,codes[i]) end
		end
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetTargetRange(0xff,0)
		e1:SetLabel(table.unpack(code_table))
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(s.efilter)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(0xff)
		e3:SetOperation(s.adjustop)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e4:SetTargetRange(0xff,0xff)
		e4:SetLabel(table.unpack(code_table))
		e4:SetTarget(s.tg)
		e4:SetLabelObject(e3)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		s[2]=Duel.SetChainLimit
		Duel.SetChainLimit=function(f)
			local func=f
			func=function(re,...)
					local codes={re:GetHandler():GetCode()}
					return (SNNM.Intersection(code_table,codes) and Duel.GetFlagEffect(0,id)>0) or f(re,...)
				end
			return s[2](func)
		end
		s[3]=Duel.SetChainLimitTillChainEnd
		Duel.SetChainLimitTillChainEnd=function(f)
			local func=f
			func=function(re,...)
					local codes={re:GetHandler():GetCode()}
					return (SNNM.Intersection(code_table,codes) and Duel.GetFlagEffect(0,id)>0) or f(re,...)
				end
			return s[3](func)
		end
		local e5=Effect.GlobalEffect()
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e5:SetOperation(function(e)Duel.SetChainLimit=s[0] Duel.SetChainLimitTillChainEnd=s[1] e:Reset()end)
		Duel.RegisterEffect(e5,0)
	end
end
function s.efilter(e,ct)
	local code_table={e:GetLabel()}
	local code1,code2=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	return SNNM.IsInTable(code1,code_table) or SNNM.IsInTable(code2,code_table)
end
function s.tg(e,c)
	local code_table={e:GetLabel()}
	local codes={c:GetCode()}
	return SNNM.Intersection(code_table,codes)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local code_table={e:GetHandler():GetCode()}
	local le1={e:GetHandler():IsHasEffect(EFFECT_CANNOT_TRIGGER)}
	local le2={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	for _,v in pairs(le1) do
		if v:GetType()==EFFECT_TYPE_SINGLE then
			local con=v:GetCondition() or aux.TRUE
			v:SetCondition(s.chcon(con,code_table))
		end
		if v:GetType()==EFFECT_TYPE_EQUIP then
			local con=v:GetCondition() or aux.TRUE
			v:SetCondition(s.chcon2(con,code_table))
		end
		if v:GetType()==EFFECT_TYPE_FIELD then
			local tg=v:GetTarget() or aux.TRUE
			v:SetTarget(s.chtg(tg,code_table))
		end
	end
	for _,v in pairs(le2) do
		local val=v:GetValue()
		if val then
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			v:SetValue(s.chval(val,code_table))
		end
	end
end
function s.chcon(_con,code_table)
	return  function(e,...)
				local codes={e:GetHandler():GetCode()}
				return not (SNNM.Intersection(code_table,codes) and Duel.GetFlagEffect(0,id)>0) and _con(e,...)
			end
end
function s.chcon2(_con,code_table)
	return  function(e,...)
				local codes={e:GetHandler():GetEquipTarget():GetCode()}
				return not (SNNM.Intersection(code_table,codes) and Duel.GetFlagEffect(0,id)>0) and _con(e,...)
			end
end
function s.chtg(_tg,code_table)
	return function(e,c)
				local codes={c:GetCode()}
				return not (SNNM.Intersection(code_table,codes) and Duel.GetFlagEffect(0,id)>0) and _tg(e,c)
			end
end
function s.chval(_val,code_table)
	return function(e,re,...)
				local codes={re:GetHandler():GetCode()}
				return not (SNNM.Intersection(code_table,codes) and Duel.GetFlagEffect(0,id)>0) and _val(e,re,...)
			end
end
