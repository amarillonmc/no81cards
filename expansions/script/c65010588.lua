--见习魔女 弦卷心
if not pcall(function() require("expansions/script/c65010000") end) then require("script/c65010000") end
local m,cm=rscf.DefineCard(65010588)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsSynchroType,TYPE_SYNCHRO),aux.Tuner(nil),nil,aux.NonTuner(nil),1,99)
	local e1=rsef.FV_LIMIT_PLAYER(c,"act",cm.actlimit,nil,{0,1})
	local e2=rsef.FC(c,EVENT_CHAIN_SOLVING,nil,nil,nil,LOCATION_MZONE,cm.discon,cm.disop)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.negcon)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
end
cm.material_type=TYPE_SYNCHRO
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsLocation(LOCATION_MZONE)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsRelateToEffect(re)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	rshint.Card(m)
	Duel.NegateEffect(ev)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
	local g=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function cm.disfilter(c)
	return c:IsCode(m) and aux.disfilter1(c)
end
function cm.nbcon(tp,re)
	local rc=re:GetHandler()
	return Duel.IsPlayerCanRemove(tp)
		and (not rc:IsRelateToEffect(re) or rc:IsAbleToRemove(tp,POS_FACEDOWN))
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_ONFIELD,0,nil)
	for tc in aux.Next(g) do
		local e1,e2=rsef.SV_LIMIT({e:GetHandler(),tc},"dis,dise",nil,nil,rsreset.est_pend,"cd")
	end
end
