if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,53797140)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,12))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.ngrcost)
	e1:SetOperation(s.ngrop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,13))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(0)
	e3:SetCondition(s.rmcon)
	e3:SetTarget(s.rmtg)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(s.MergedDelayEventCheck1(g,e2,e3))
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAIN_END)
	e5:SetOperation(s.MergedDelayEventCheck2(g,e2,e3))
	c:RegisterEffect(e5)
end
function s.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function s.ngrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.ConfirmCards(1-tp,c)
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function s.ngrop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
end
function s.efilter(e,ct)
	return Duel.GetChainInfo(ct,CHAININFO_EXTTYPE)&0x6>0
end
function s.MergedDelayEventCheck1(g,e2,e3)
	return  function(e,tp,eg,ep,ev,re,r,rp)
		g:Merge(eg)
		if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
			local _eg=g:Clone()
			local t=SNNM.Remove({e2:GetLabel()},0)
			if #t>0 then e3:SetLabel(table.unpack(t)) Duel.RaiseEvent(Group.__add(_eg,e:GetHandler()),EVENT_CUSTOM+id,re,r,rp,ep,ev) end
			e2:SetLabel(0)
			g:Clear()
		end
	end
end
function s.MergedDelayEventCheck2(g,e2,e3)
	return  function(e,tp,eg,ep,ev,re,r,rp)
		if #g>0 then
			local _eg=g:Clone()
			local t=SNNM.Remove({e2:GetLabel()},0)
			if #t>0 then e3:SetLabel(table.unpack(t)) Duel.RaiseEvent(Group.__add(_eg,e:GetHandler()),EVENT_CUSTOM+id,re,r,rp,ep,ev) end
			e2:SetLabel(0) e3:SetLabel(0)
			g:Clear()
		end
	end
end
function s.repfilter(c,tp)
	return c:IsControler(1-tp) and c:GetDestination()==LOCATION_GRAVE and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local repg=eg:Filter(s.repfilter,nil,tp)
	local gct=#repg
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCode),p,LOCATION_EXTRA,0,nil,53797140)
	local codes={}
	for tc in aux.Next(g) do SNNM.Merge(codes,{tc:GetCode()}) end
	local e1=e:GetLabelObject()
	local check=true
	if e:GetHandler():IsHasEffect(EFFECT_CANNOT_TRIGGER) then check=false end
	local p=e:GetHandlerPlayer()
	local le1={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)}
	for _,v in pairs(le1) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,e1,p) then check=false end
	end
	local le2={Duel.IsPlayerAffectedByEffect(p,EFFECT_ACTIVATE_COST)}
	for _,v in pairs(le2) do
		local cost=v:GetCost()
		if cost and not cost(v,e1,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,e1,p) then check=false end
		end
	end
	if chk==0 then return gct>0 and #codes>=gct and check end
	table.sort(codes)
	local sel=gct-1
	if sel>10 then sel=10 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,sel)) then
		local nt={codes[1],OPCODE_ISCODE}
		for i=2,#codes do
			table.insert(nt,codes[i])
			table.insert(nt,OPCODE_ISCODE)
			table.insert(nt,OPCODE_OR)
		end
		local t={}
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CODE)
		while gct>0 do
			local ac=Duel.AnnounceCard(p,table.unpack(nt))
			table.insert(t,ac)
			table.insert(nt,ac)
			table.insert(nt,OPCODE_ISCODE)
			table.insert(nt,OPCODE_NOT)
			table.insert(nt,OPCODE_AND)
			gct=gct-1
		end
		if e:GetLabel()==0 then e:SetLabel(table.unpack(t)) else e:SetLabel(table.unpack(SNNM.Merged({e:GetLabel()},t))) end
	end
	return false
end
function s.repval(e,c)
	return false
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousControler,1,nil,1-tp) and eg:IsContains(e:GetHandler())
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local t={e:GetLabel()}
	local table=t
	if chk==0 then return true end
	e:SetOperation(s.rmop(table))
	local g=eg:Filter(Card.IsPreviousControler,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.rmop(t)
	return  function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetTargetsRelateToChain():Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN):Filter(Card.IsCode,nil,table.unpack(t))
		if #g>0 then Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT) end
		e:SetOperation(nil)
	end
end
