if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
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
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.fselect(g,ft)
	return g:IsExists(function(c)return c:IsLocation(LOCATION_SZONE) and c:GetSequence()~=5 and c:IsFaceup()end,1,nil) or ft>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local costg=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()end,tp,LOCATION_ONFIELD,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return costg:CheckSubGroup(cm.fselect,2,2,ft) and not e:GetHandler():IsForbidden() and e:GetHandler():CheckUniqueOnField(tp) end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=costg:SelectSubGroup(tp,cm.fselect,false,2,2,ft)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
	local list={}
	for tc in aux.Next(g) do if tc:IsLocation(LOCATION_SZONE) and tc:IsFacedown() and tc:GetSequence()~=5 then table.insert(list,tc:GetSequence()) end end
	if #list>0 then
		table.insert(list,5)
		e:SetLabel(table.unpack(list))
	else e:SetLabel(5) end
	Duel.Release(g,REASON_EFFECT)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local list={e:GetLabel()}
	local c=e:GetHandler()
	local chkl=0
	for cl=0,4 do if Duel.CheckLocation(tp,LOCATION_SZONE,cl) and not SNNM.IsInTable(cl,list) then chkl=1 end end
	if not c:IsRelateToEffect(e) or chkl==0 then return end
	local filter=0
	for i=1,#list do filter=filter|1<<(list[i]+8) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local flag=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,filter)
	if flag and rsop.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,2^(math.log(flag,2)-8)) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local ct1=c:GetFlagEffect(m)
	local ct2=c:GetFlagEffect(m+50)
	local b1=Duel.IsPlayerCanDiscardDeck(tp,1) and ct1<2
	local b2=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,nil) and ct2<2
	if rp==1-tp and rc:IsOnField() and not e:GetHandler():GetColumnGroup():IsContains(rc) and (b1 or b2) then
		Duel.Hint(HINT_CARD,0,m)
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
end
