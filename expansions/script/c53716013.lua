if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=53716013
local cm=_G["c"..m]
cm.name="断片折光 幻想牲都"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,7))
	e5:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.discon)
	e5:SetTarget(cm.distg)
	e5:SetOperation(cm.disop)
	c:RegisterEffect(e5)
end
function cm.costfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_ONFIELD,0,2,nil) end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
	local list={}
	for tc in aux.Next(g) do
		if tc:IsLocation(LOCATION_SZONE) then table.insert(list,tc:GetSequence()) end
	end
	if #list>0 then
		table.insert(list,5)
		e:SetLabel(table.unpack(list))
	else e:SetLabel(5) end
	Duel.Release(g,REASON_EFFECT)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.offilter(c,list)
	return c:GetSequence()<5 and bit.band(table.unpack(list),c:GetSequence())==0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local list={e:GetLabel()}
	local zg=Duel.GetMatchingGroup(cm.offilter,tp,LOCATION_SZONE,0,nil,list)
	if #zg>0 then
		for tc in aux.Next(zg) do
			table.insert(list,tc:GetSequence()) 
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and #list<6 then
		local filter=0
		for i=1,#list do
			filter=filter|1<<(list[i]+8)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local flag=Duel.SelectField(tp,1,LOCATION_SZONE,0,filter)
		rsop.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,2^(math.log(flag,2)-8))
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==1-tp and rc:IsOnField() and not e:GetHandler():GetColumnGroup():IsContains(rc)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct1=c:GetFlagEffect(m)
	local ct2=c:GetFlagEffect(m+50)
	if chk==0 then return (ct1<2 and Duel.IsPlayerCanDiscardDeck(tp,1)) or (ct2<2 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,nil)) end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct1=c:GetFlagEffect(m)
	local ct2=c:GetFlagEffect(m+50)
	local b1=Duel.IsPlayerCanDiscardDeck(tp,1) and ct1<2
	local b2=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,nil) and ct2<2
	local opt=0
	if b1 and b2 then opt=Duel.SelectOption(1-tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then opt=Duel.SelectOption(1-tp,aux.Stringid(m,1))
	else opt=Duel.SelectOption(1-tp,aux.Stringid(m,2))+1 end
	if opt==0 then
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,ct1+3))
		c:ResetFlagEffect(m+50)
	else 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,cm.filter,1-tp,0,LOCATION_REMOVED,1,1,nil)
		if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN) end
		c:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,ct2+5))
		c:ResetFlagEffect(m)
	end
end
