if not require and dofile then function require(str) return dofile(str..".lua") end end
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
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x20004,LOCATION_EXTRA)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCost(cm.cost)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	SNNM.ActivatedAsSpellorTrapCheck(c)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cost=Duel.GetMatchingGroup(function(c)return c:IsSetCard(0x353b) and c:IsReleasable()end,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return #cost>1 and not e:GetHandler():IsForbidden() and e:GetHandler():CheckUniqueOnField(tp) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=cost:Select(tp,2,2,e:GetHandler())
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local ct1=c:GetFlagEffect(m)
	local ct2=c:GetFlagEffect(m+50)
	local b1=Duel.IsPlayerCanDiscardDeck(tp,1) and ct1<2
	local b2=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_REMOVED,0,1,nil) and ct2<2
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
			local g=Duel.SelectMatchingCard(1-tp,cm.tgfilter,1-tp,0,LOCATION_REMOVED,1,1,nil)
			if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN) end
			c:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,ct2+5))
			c:ResetFlagEffect(m)
		end
	end
end
