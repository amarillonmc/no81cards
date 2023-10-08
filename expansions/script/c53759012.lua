local m=53759012
local cm=_G["c"..m]
cm.name="异次元魔导 因蒂维加尔"
cm.Snnm_Ef_Rst=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
cm.SpecialSummonableSpellorTrap=true
cm.SSST_Data={TYPE_EFFECT,RACE_SPELLCASTER,ATTRIBUTE_DARK,12,3500,3500}
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	SNNM.MultipleGroupCheck(c)
	SNNM.SpellorTrapSPable(c)
end
cm.lvup={m-8}
cm.lvdn={m-7,m-11,m-10,m-9,m-8}
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(cm.efilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
end
function cm.efilter(e,te,c)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsSetCard(0x41) and loc&LOCATION_MZONE>0
end
function cm.filter(c,code)
	return c:IsSetCard(0x6e) and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
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
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	getmetatable(e:GetHandler()).announce_filter={table.unpack(afilter)}
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
end
function cm.fselect(g,code)
	return g:IsExists(Card.IsCode,1,nil,code)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,4,ac)
	if sg then Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local opt=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.sptg(c,ac))
	e1:SetOperation(cm.spop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_REMOVED,LOCATION_REMOVED)
	e2:SetTarget(cm.eftg(ac))
	e2:SetReset(RESET_PHASE+PHASE_END,opt+1)
	e2:SetLabelObject(e1)
	e2:SetLabel(Duel.GetTurnCount()+opt)
	e2:SetCondition(cm.efcon)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetOperation(cm.adjustop(c,ac))
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetTargetRange(LOCATION_REMOVED,LOCATION_REMOVED)
	e4:SetTarget(cm.eftg(ac))
	e4:SetReset(RESET_PHASE+PHASE_END,2-opt)
	e4:SetLabelObject(e3)
	e4:SetLabel(Duel.GetTurnCount()+1-opt)
	e4:SetCondition(cm.efcon)
	Duel.RegisterEffect(e4,tp)
end
function cm.efcon(e)
	return Duel.GetTurnCount()==e:GetLabel()
end
function cm.eftg(code)
	return
	function(e,c)
		return c:IsFaceup() and c:IsCode(code)
	end
end
function cm.sptg(owner,code)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and cm.accheck(tp,code,1) end
		cm.account(e:GetHandler(),tp,code,1)
		cm.adup(owner)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function cm.adjustop(owner,code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rse={c:IsHasEffect(m)}
	for _,v in pairs(rse) do
		if v:GetLabelObject():GetLabelObject() then v:GetLabelObject():GetLabelObject():Reset() end
		if v:GetLabelObject() then v:GetLabelObject():Reset() end
		v:Reset()
	end
	local le={c:GetActivateEffect()}
	for _,v in pairs(le) do
		local e1=v:Clone()
		if #le==1 then e1:SetDescription(aux.Stringid(m,4)) end
		e1:SetRange(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local te={Duel.IsPlayerAffectedByEffect(0,m)}
		for _,v2 in pairs(te) do
			local ae=v2:GetLabelObject()
			if ae:GetLabelObject() and ae:GetLabelObject()==v and ae:GetCode() and ae:GetCode()==EFFECT_ACTIVATE_COST then
				local e2=ae:Clone()
				e2:SetRange(LOCATION_REMOVED)
				e2:SetLabelObject(e1)
				e2:SetTarget(cm.actarget)
				local cost=v2:GetCost()
				if not cost then cost=aux.TRUE end
				e2:SetCost(cm.accost(cost,code))
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e2)
				local ex=Effect.CreateEffect(c)
				ex:SetType(EFFECT_TYPE_SINGLE)
				ex:SetCode(m)
				ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				ex:SetLabelObject(e2)
				ex:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(ex)
			end
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ACTIVATE_COST)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_REMOVED)
		e3:SetTargetRange(1,1)
		e3:SetLabelObject(e1)
		e3:SetTarget(cm.actarget)
		e3:SetCost(cm.accost(aux.TRUE,code))
		e3:SetOperation(cm.costop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(m)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetLabelObject(e3)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAINING)
		e5:SetLabelObject(e1)
		e5:SetCondition(cm.negcon)
		e5:SetOperation(cm.negop(owner,code))
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetLabelObject(e5)
		c:RegisterEffect(e6)
	end
	end
end
function cm.actarget(e,te,tp)
	return te==e:GetLabelObject()
end
function cm.accost(_cost,code)
	return function(e,te,tp)
				if not cm.accheck(tp,code,2) then return false end
				return _cost(e,te,tp)
			end
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	if tc:IsLocation(LOCATION_SZONE) then return end
	local tp=te:GetHandlerPlayer()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	tc:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function cm.negop(owner,code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		cm.adup(owner)
		cm.account(e:GetOwner(),rp,code,2)
	end
end
function cm.adup(c)
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function cm.accheck(tp,code,num)
	local le={Duel.IsPlayerAffectedByEffect(tp,m+33*num)}
	local b=true
	for _,v in pairs(le) do if v:GetLabel()==code then b=false end end
	return b
end
function cm.account(c,tp,code,num)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(m+33*num)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(code)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
