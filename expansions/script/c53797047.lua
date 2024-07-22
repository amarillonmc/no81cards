if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(id)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(s.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		s.OAe={}
	end
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_QUICKPLAY) and c:GetActivateEffect()end,0,LOCATION_DECK,LOCATION_DECK,nil)
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		for _,v in pairs(le) do
			if v:GetRange()&0x10a~=0 and not SNNM.IsInTable(v,s.OAe) then
				table.insert(s.OAe,v)
				local e1=v:Clone()
				e1:SetRange(LOCATION_DECK)
				e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
				tc:RegisterEffect(e1,true)
				local e2=SNNM.Act(tc,e1)
				e2:SetRange(LOCATION_DECK)
				e2:SetCost(s.costchk)
				e2:SetOperation(s.costop)
				tc:RegisterEffect(e2,true)
			end
		end
	end
end
function s.pubfilter(c)
	return c:IsHasEffect(id) and not c:IsPublic()
end
function s.costchk(e,te,tp)
	return Duel.IsExistingMatchingCard(s.pubfilter,tp,LOCATION_HAND,0,1,nil)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local tc=Duel.SelectMatchingCard(tp,s.pubfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local e1=Effect.CreateEffect(tc)
	e1:SetDescription(66)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local check=1
	--[[local le={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SUMMON)}
	for _,v in pairs(le) do
		local tg=v:GetTarget() or aux.TRUE
		if tg(v,tc,tp,SUMMON_TYPE_NORMAL,POS_FACEUP,tp,e) then check=0 end
	end]]--
	local e2=Effect.CreateEffect(tc)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetLabel(check)
	e2:SetLabelObject(tc)
	e2:SetOperation(s.op1)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
	tc:CreateEffectRelation(e2)
	local ev0=Duel.GetCurrentChain()+1
	local e3=Effect.CreateEffect(tc)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e3:SetLabelObject(e:GetHandler())
	e3:SetOperation(s.op2)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	tc:RegisterEffect(e3,true)
	SNNM.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local check=e:GetLabel()
	local le={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SUMMON)}
	for _,v in pairs(le) do
		local tg=v:GetTarget() or aux.TRUE
		if tg(v,c,tp,SUMMON_TYPE_NORMAL,POS_FACEUP,tp,e) then check=check+1 end
	end
	if check==2 and c:IsRelateToEffect(e) then return end
	local ev0=Duel.GetCurrentChain()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(s.disop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.tdop)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT,tp,true)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local le={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SUMMON)}
	for _,v in pairs(le) do
		if v:GetOwner()==e:GetLabelObject() then
			local tg=v:GetTarget() or aux.TRUE
			if tg(v,c,tp,SUMMON_TYPE_ADVANCE,POS_FACEUP,tp,e) then v:SetTarget(s.chtg(tg,c)) end
		end
	end
	local b1=c:IsAbleToRemove()
	local b2=c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)})
	if op==1 then Duel.Remove(c,POS_FACEUP,REASON_EFFECT) else
		local s1=c:IsSummonable(true,nil,1)
		local s2=c:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,c,true,nil,1)
		else
			Duel.MSet(tp,c,true,nil,1)
		end
	end
end
function s.chtg(_tg,tc)
	return  function(e,c,...)
				return _tg(e,c,...) and c~=tc
			end
end
function s.chkfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.valcheck(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():FilterCount(s.chkfilter,nil))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,e:GetLabel(),1-tp,LOCATION_ONFIELD)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,Duel.GetTurnPlayer(),HINTMSG_TOGRAVE)
		local sg=g:Select(Duel.GetTurnPlayer(),e:GetLabel(),e:GetLabel(),nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE,1-tp)
	end
end
