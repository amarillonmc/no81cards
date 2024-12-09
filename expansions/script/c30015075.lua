--终墟戮反
local m=30015075
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(aux.NegateSummonCondition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(cm.cont)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.tgt)
	e4:SetOperation(cm.opt)
	c:RegisterEffect(e4)
	--Effect 2  
	local e2=ors.redraw(c)
	--all
	local ge1=ors.alldrawflag(c)
end
c30015075.isoveruins=true
--
function cm.nbcon(tp,re)
	local rc=re:GetHandler()
	local b1=not rc:IsRelateToEffect(re)
	local b2=rc:IsAbleToRemove(tp,POS_FACEDOWN)
	return Duel.IsPlayerCanRemove(tp) and (b1 or b2)
end
--cost--
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=daval[0]+daval[1]
	if ct==0 then ct=1 end
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	if ct>=#dg then ct=#dg end
	local g=Duel.GetDecktopGroup(tp,ct)
	if chk==0 then return ct>0 and g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==ct end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
--Effect 1
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	if not Duel.IsPlayerCanRemove(tp) then return false end
	local rg=eg:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
end
--trap and spell
function cm.cont(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function cm.tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
	if re:GetActivateLocation()==LOCATION_GRAVE then
		e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(e:GetCategory()&~CATEGORY_GRAVE_ACTION)
	end
end
function cm.opt(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end
--summon

