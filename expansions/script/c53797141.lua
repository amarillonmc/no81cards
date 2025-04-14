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
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.costcon)
	e2:SetCost(s.costchk)
	e2:SetOperation(s.costop)
	c:RegisterEffect(e2)
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
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.efilter(e,te,c)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function s.costcon(e)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),e:GetHandlerPlayer(),LOCATION_EXTRA,0,1,nil,53797140)
end
function s.costchk(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,13))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.negcon)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	e:GetHandler():RegisterEffect(e1)
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
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCode),p,LOCATION_EXTRA,0,nil,53797140)
	local codes={}
	for tc in aux.Next(g) do SNNM.Merge(codes,{tc:GetCode()}) end
	local c=e:GetHandler()
	--SNNM.RemoveElements(codes,{c:GetFlagEffectLabel(id)})
	if check and #codes>0 and Duel.SelectEffectYesNo(p,c,aux.Stringid(id,0)) then
		table.sort(codes)
		local nt={codes[1],OPCODE_ISCODE}
		for i=2,#codes do
			table.insert(nt,codes[i])
			table.insert(nt,OPCODE_ISCODE)
			table.insert(nt,OPCODE_OR)
		end
		local ac=Duel.AnnounceCard(p,table.unpack(nt))
		--c:RegisterFlagEffect(id,RESET_CHAIN,0,1,ac)
		e1:SetLabel(ac)
		e1:SetLabelObject(e:GetLabelObject())
	else e1:Reset() end
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetLabel()~=0 and e:GetLabelObject()==re end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==re:GetHandler():GetCode() and Duel.NegateActivation(ev) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
