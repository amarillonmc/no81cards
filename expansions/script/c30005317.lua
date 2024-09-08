--猩红姬 唤魔者
local m=30005317
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,cm.lcheck)
	c:EnableReviveLimit()
	--extra material
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e01:SetRange(LOCATION_EXTRA)
	e01:SetTargetRange(LOCATION_SZONE,0)
	e01:SetTarget(cm.mattg)
	e01:SetValue(cm.matval)
	c:RegisterEffect(e01)
	--Effect 1
	local e31=Effect.CreateEffect(c)
	e31:SetType(EFFECT_TYPE_SINGLE)
	e31:SetCode(EFFECT_IMMUNE_EFFECT)
	e31:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e31:SetRange(LOCATION_MZONE)
	e31:SetValue(cm.efilter)
	c:RegisterEffect(e31)
	--Effect 2  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.tcon)
	e3:SetTarget(cm.ttg)
	e3:SetOperation(cm.top)
	c:RegisterEffect(e3)
	--Effect 3 
	local e4=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.dcon)
	e4:SetTarget(cm.dtg)
	e4:SetOperation(cm.dop)
	c:RegisterEffect(e4)
	--all
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--
function cm.sf(c)
	return c:GetOriginalType()&TYPE_TRAP~=0
end
function cm.lcheck(g,lc)
	return g:FilterCount(cm.sf,nil)>=2 and g:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)<=1
end
function cm.mattg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP)
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,true
end
--Effect 1
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
--Effect 2
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	--if re:GetHandler()==e:GetHandler() then return false end
	local loc,race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_RACE)
	local b1=re:IsActiveType(TYPE_TRAP)
	local b2=re:IsActiveType(TYPE_MONSTER) and race&RACE_FIEND~=0
	return loc&LOCATION_ONFIELD~=0 and (b1 or b2)
end
function cm.gf(c)
	local b1=c:IsLocation(LOCATION_DECK) and c:IsAbleToGrave()
	local b2=c:IsLocation(LOCATION_REMOVED) 
	return c:IsFaceupEx() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and (b1 or b2)
end
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.gf,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local loc=LOCATION_DECK+LOCATION_REMOVED 
	local g=Duel.GetMatchingGroup(cm.gf,tp,loc,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sgc=g:Select(tp,1,1,nil):GetFirst()
	if sgc==nil then return false end
	if sgc:IsLocation(LOCATION_REMOVED) then
		Duel.SendtoGrave(sgc,REASON_EFFECT+REASON_RETURN)
	else
		Duel.SendtoGrave(sgc,REASON_EFFECT)
	end
	Duel.AdjustAll()
	if sgc:IsLocation(LOCATION_GRAVE) and ec:IsFaceup() and ec:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(ec)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		ec:RegisterEffect(e1)
	end
end
--Effect 3 
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function cm.cf(c)
	local b1=c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand()
	local b2=c:IsLocation(LOCATION_REMOVED) 
	return c:IsFaceupEx() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and (b1 or b2)
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.cf,tp,LOCATION_GRAVE+LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.cf),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #rg==0 and #tg==0 then return end
	local op=aux.SelectFromOptions(tp,{#rg>0,1192},{#tg>0,1191})
	if op==1 then
		cm.rmove(e,tp,eg,ep,ev,re,r,rp)
	else
		cm.tohand(e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.rmove(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tag=g:Select(tp,1,1,nil)
	if #tag==0 then return false end
	Duel.Remove(tag,POS_FACEUP,REASON_EFFECT)
end
function cm.tohand(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.cf),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g==0 then return end
	local tg=g:Filter(aux.NecroValleyFilter(Card.IsAbleToHand),nil)
	local gg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	local op=aux.SelectFromOptions(tp,{#tg>0,1190},{#gg>0,1191})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tag=tg:Select(tp,1,1,nil)
		if #tag==0 then return false end
		Duel.SendtoHand(tag,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tag)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tag=gg:Select(tp,1,1,nil)
		if #tag==0 then return false end
		Duel.SendtoGrave(sgc,REASON_EFFECT+REASON_RETURN)
	end
end
