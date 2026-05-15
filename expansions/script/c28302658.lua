--小琉璃难题
function c28302658.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c28302658.cost)
	--e0:SetOperation(c28302658.activate)
	c:RegisterEffect(e0)
	--check:record spcount
	--[[local ce1=e0:Clone()
	ce1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ce1:SetCode(EVENT_MOVE)
	c:RegisterEffect(ce1)]]
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28302658,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c28302658.destg)
	e1:SetOperation(c28302658.desop)
	c:RegisterEffect(e1)
	if not c28302658.global_check then
		c28302658.global_check=true
		c28302658.spsummon_count=0
		--Event Listener
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c28302658.signop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		ge2:SetOperation(c28302658.reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(c28302658.block)--beware Grinder Golem
		ge3:SetLabelObject(ge2)
		Duel.RegisterEffect(ge3,0)
	end
end
function c28302658.costfilter(c)
	return c:IsCode(72971064) and c:GetOverlayCount()>=3 and c:IsFaceup() and c:IsAbleToExtraAsCost()
end
function c28302658.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28302658.costfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		g=g:Select(tp,1,1,nil)
	end
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_COST)
end
function c28302658.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsOnField() or c:IsFacedown() or c:GetFlagEffect(28302658)~=0 then return end
	c:RegisterFlagEffect(28302658,RESET_EVENT+RESETS_STANDARD,0,1,c28302658.spsummon_count)
end
function c28302658.desfilter(c,ct,greater)--...
	for _,v in ipairs({c:GetFlagEffectLabel(28302658)}) do
		if v==ct or greater and v>ct then return true end--equal or greater;greater==false→equal
	end
	return false
end
function c28302658.gcheck(sg,g)
	--if #sg==0 then return false end
	for _,ct in ipairs({sg:GetFirst():GetFlagEffectLabel(28302658)}) do
		if sg:FilterCount(c28302658.desfilter,nil,ct,false)==g:FilterCount(c28302658.desfilter,nil,ct,false) and #sg==sg:FilterCount(c28302658.desfilter,nil,ct,false) then return true end--all the card that have some label
	end
	return false
end
function c28302658.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct_min=e:GetHandler():GetFlagEffectLabel(28302658+1)
	if chk==0 then return eg:IsExists(c28302658.desfilter,1,nil,ct_min,true) end
	local g=Duel.GetMatchingGroup(c28302658.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ct_min,true)--all card can be target
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28302658.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct_min=e:GetHandler():GetFlagEffectLabel(28302658+1)
	--select
	local g=Duel.GetMatchingGroup(c28302658.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ct_min,true)
	if #g==0 then return end
	local sg=g:Clone()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		sg=g:SelectSubGroup(tp,c28302658.gcheck,false,1,#g,g)
	end
	Duel.HintSelection(sg)
	--reset
	local ct=0
	for _,v in ipairs({sg:GetFirst():GetFlagEffectLabel(28302658)}) do
		if sg:FilterCount(c28302658.desfilter,nil,v,false)==g:FilterCount(c28302658.desfilter,nil,v,false) and #sg==sg:FilterCount(c28302658.desfilter,nil,v,false) then ct=v break end--common label
	end
	for tc in aux.Next(sg) do
		local t={tc:GetFlagEffectLabel(28302658)}
		tc:ResetFlagEffect(28302658)
		for _,v in ipairs(t) do
			if ct~=v then tc:RegisterFlagEffect(28302658,RESET_EVENT+RESETS_STANDARD - RESET_TURN_SET,0,1,v) end--only reset the common label
		end
	end
	--destroy
	Duel.Destroy(sg,REASON_EFFECT)
end
function c28302658.sfilter(c)
	return c:GetFlagEffect(28302658+1)==0
end
function c28302658.signop(e,tp,eg,ep,ev,re,r,rp)
	local ct=c28302658.spsummon_count+1
	c28302658.spsummon_count=ct
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(28302658,RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET,0,1,ct)
	end
	--check:record spcount
	local g=Duel.GetMatchingGroup(c28302658.sfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)--beware copy
	if #g==0 then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(28302658+1,RESET_EVENT+RESETS_STANDARD,0,1,ct)
	end
end
function c28302658.reset(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		if e:GetLabel()==1 then return else e:SetLabel(1) end
	end
	local g=Duel.GetMatchingGroup(c28302658.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0,true)--all card with flag count>0
	local ct=c28302658.spsummon_count
	for tc in aux.Next(g) do
		local t={tc:GetFlagEffectLabel(28302658)}
		tc:ResetFlagEffect(28302658)
		for _,v in ipairs(t) do
			if v==ct then tc:RegisterFlagEffect(28302658,RESET_EVENT+RESETS_STANDARD - RESET_TURN_SET,0,1,v) end--reset all old flag
		end
	end
end
function c28302658.block(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then e:GetLabelObject():SetLabel(0) end
end
