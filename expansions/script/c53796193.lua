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
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xff,0xff)
	e2:SetLabel(0)
	e2:SetCondition(s.costcon)
	e2:SetOperation(s.costop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,13))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+id)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(0)
	e4:SetCondition(s.tgcon)
	e4:SetTarget(s.tgtg)
	c:RegisterEffect(e4)
	e2:SetLabelObject(e4)
	e3:SetLabelObject(e4)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.MergedDelayEventCheck1(g,e2,e3,e4))
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_CHAIN_END)
	e7:SetOperation(s.MergedDelayEventCheck2(g,e2,e3,e4))
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(id)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(1,1)
	c:RegisterEffect(e8)
	if not s.global_check then
		s.global_check=true
		if c53796195 and not c53796195[0] then
			c53796195[0]={}
			c53796195[1]={}
		end
		local f1=aux.PendOperation
		aux.PendOperation=function()
			local func1=f1()
			local func2=func1
			func2=function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local res=func1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				if Duel.IsPlayerAffectedByEffect(0,id) then s.pendcount=#sg end
				return res
			end
			return func2
		end
		local f2=Duel.SpecialSummon
		Duel.SpecialSummon=function(tg,...)
			if Duel.IsPlayerAffectedByEffect(0,id) then if aux.GetValueType(tg)=="Card" then s.pendcount=1 else s.pendcount=#tg end end
			local ct=f2(tg,...)
			s.pendcount=0 s.pendcheck=0
			return ct
		end
	end
end
s.pendcount=0
s.pendcheck=0
function s.MergedDelayEventCheck1(g,e2,e3,e4)
	return  function(e,tp,eg,ep,ev,re,r,rp)
		g:Merge(eg)
		if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
			local _eg=g:Clone()
			local t=SNNM.Remove(SNNM.Merged({e2:GetLabel()},{e3:GetLabel()}),0)
			if #t>0 then e4:SetLabel(table.unpack(t)) Duel.RaiseEvent(Group.__add(_eg,e:GetHandler()),EVENT_CUSTOM+id,re,r,rp,ep,ev) end
			e2:SetLabel(0) e3:SetLabel(0)
			g:Clear()
		end
	end
end
function s.MergedDelayEventCheck2(g,e2,e3,e4)
	return  function(e,tp,eg,ep,ev,re,r,rp)
		if #g>0 then
			local _eg=g:Clone()
			local t=SNNM.Remove(SNNM.Merged({e2:GetLabel()},{e3:GetLabel()}),0)
			if #t>0 then e4:SetLabel(table.unpack(t)) Duel.RaiseEvent(Group.__add(_eg,e:GetHandler()),EVENT_CUSTOM+id,re,r,rp,ep,ev) end
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
	return c:IsFaceup() and c:IsAbleToExtraAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler()) and (aux.IsCodeListed(c,53796195) or c:IsType(0x40))
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.spcfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SendtoDeck(g,nil,REASON_COST)
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
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.efilter(e,te,c)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c)
end
function s.costcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
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
	if tp==p or not check then s.pendcount=0 s.pendcheck=0 return end
	if s.pendcheck==0 then s.pendcount=(s.pendcount>0 and s.pendcount) or 1 end
	if s.pendcount>0 and s.pendcheck==0 then
		s.pendcheck=s.pendcount-1
		local g=Duel.GetMatchingGroup(aux.AND(Card.IsFacedown,Card.IsAbleToDeck),p,LOCATION_REMOVED,0,nil)
		if g:GetClassCount(Card.GetCode)>=s.pendcount and Duel.SelectEffectYesNo(p,e:GetHandler(),aux.Stringid(id,s.pendcount-1)) then
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
			while s.pendcount>0 and ct>0 do
				local ac=Duel.AnnounceCard(p,table.unpack(nt))
				table.insert(t,ac)
				table.insert(nt,ac)
				table.insert(nt,OPCODE_ISCODE)
				table.insert(nt,OPCODE_NOT)
				table.insert(nt,OPCODE_AND)
				ct=ct-1
				s.pendcount=s.pendcount-1
			end
			if e:GetLabel()==0 then e:SetLabel(table.unpack(t)) else e:SetLabel(table.unpack(SNNM.Merged({e:GetLabel()},t))) end
		end
		s.pendcount=0
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and eg:IsContains(e:GetHandler())
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={e:GetLabel()}
	local table=t
	if chk==0 then return true end
	e:SetOperation(s.tgop(table))
	local g=eg:Filter(Card.IsSummonPlayer,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function s.tdfilter(c,t,g)
	return c:IsFacedown() and c:IsCode(table.unpack(t)) and g:IsExists(Card.IsCode,1,nil,c:GetCode()) and c:IsAbleToDeck()
end
function s.tgop(t)
	return  function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
		local tdg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,nil,t,g)
		if #tdg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=tdg:SelectSubGroup(tp,aux.dncheck,false,1,#g)
			if sg then
				Duel.ConfirmCards(1-tp,sg)
				local tg=g:Filter(function(c,sg)return sg:IsExists(Card.IsCode,1,nil,c:GetCode())end,nil,sg)
				if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then Duel.SendtoGrave(tg,REASON_RULE) end
			end
		end
		if c53796195 and not SNNM.AllExist(c53796195[tp],t) and Duel.SelectYesNo(tp,aux.Stringid(id,14)) then SNNM.Merge(c53796195[tp],t) end
		e:SetOperation(nil)
	end
end
