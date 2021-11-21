--大王咒使
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16150019,"DAIOUJYUTSUKAI")
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m) 
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
end
function cm.costfilter2(c,tp)
	return c:IsType(TYPE_SPELL) and (c:IsFaceup() or c:IsControler(tp)) and c:IsReleasable()
end 
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.costfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	if c:GetEquipGroup() and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,16150020) then
		g=Duel.GetMatchingGroup(cm.costfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD,nil,tp)
	end
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:Select(tp,1,1,nil)
	Duel.Release(sg,REASON_COST)
	sg:KeepAlive()
	e:SetLabelObject(sg)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,rp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
	if re:GetHandler() then
		re:GetHandler():CancelToGrave()
		Duel.SendtoDeck(re:GetHandler(),nil,2,REASON_EFFECT)
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end