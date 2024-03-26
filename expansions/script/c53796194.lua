if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,53796195)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(function(e,se,sp,st)return se==e:GetLabelObject() and Duel.GetFlagEffect(e:GetHandlerPlayer(),id)==0 end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,12))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
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
	if not s.global_check then
		s.global_check=true
		if c53796195 and not c53796195[0] then
			c53796195[0]={}
			c53796195[1]={}
		end
	end
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
function s.cfilter(c)
	return c:IsCode(53796195) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function s.spcfilter(c,e,tp)
	return c:IsFaceup() and c:IsAbleToExtraAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0 and (aux.IsCodeListed(c,53796195) or c:IsType(TYPE_LINK))
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.spcfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	c:CompleteProcedure()
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+SNNM.GetCurrentPhase(),0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_REMOVED,0)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_PHASE+SNNM.GetCurrentPhase())
	Duel.RegisterEffect(e1,tp)
end
function s.efilter(e,te,c)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function s.repfilter(c,tp)
	return c:IsControler(1-tp) and c:GetDestination()==LOCATION_GRAVE and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local repg=eg:Filter(s.repfilter,nil,tp)
	local gct=#repg
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFacedown,Card.IsAbleToDeck),e:GetHandlerPlayer(),LOCATION_REMOVED,0,nil)
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
	if chk==0 then return gct>0 and g:GetClassCount(Card.GetCode)>=gct and check end
	local sel=gct-1
	if sel>10 then sel=10 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,sel)) then
		local ag=Group.CreateGroup()
		local codes={}
		for c in aux.Next(g) do
			local code=c:GetCode()
			if not ag:IsExists(Card.IsCode,1,nil,code) then
				ag:AddCard(c)
				table.insert(codes,code)
			end
		end
		table.sort(codes)
		local ct=#codes
		local nt={codes[1],OPCODE_ISCODE}
		if ct>1 then
			for i=2,ct do
				table.insert(nt,codes[i])
				table.insert(nt,OPCODE_ISCODE)
				table.insert(nt,OPCODE_OR)
			end
		end
		local t={}
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CODE)
		while gct>0 and ct>0 do
			local ac=Duel.AnnounceCard(p,table.unpack(nt))
			table.insert(t,ac)
			table.insert(nt,ac)
			table.insert(nt,OPCODE_ISCODE)
			table.insert(nt,OPCODE_NOT)
			table.insert(nt,OPCODE_AND)
			ct=ct-1
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
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.tdfilter(c,t,g)
	return c:IsFacedown() and c:IsCode(table.unpack(t)) and g:IsExists(Card.IsCode,1,nil,c:GetCode()) and c:IsAbleToDeck()
end
function s.rmop(t)
	return  function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetTargetsRelateToChain():Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
		local tdg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,nil,t,g)
		if #tdg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=tdg:SelectSubGroup(tp,aux.dncheck,false,1,#g)
			if sg then
				Duel.ConfirmCards(1-tp,sg)
				local tg=g:Filter(function(c,sg)return sg:IsExists(Card.IsCode,1,nil,c:GetCode())end,nil,sg)
				if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT) end
			end
		end
		if c53796195 and SNNM.Intersection(t,c53796195[tp]) and Duel.SelectYesNo(tp,aux.Stringid(id,14)) then SNNM.Merge(c53796195[tp],t) end
		e:SetOperation(nil)
	end
end
