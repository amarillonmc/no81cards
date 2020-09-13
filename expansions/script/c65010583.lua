--初生之白月骑士
if not pcall(function() require("expansions/script/c65010579") end) then require("script/c65010579") end
local m,cm=rscf.DefineCard(65010583,"WMKnight")
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"se,th",nil,LOCATION_HAND,nil,rscost.cost(0,"dish"),rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e2=rsef.SV_UPDATE(c,"atk",cm.atkval)
	local e3=rsef.QO(c,EVENT_CHAINING,{m,3},1,"tg,neg,des","dcal,dsp",LOCATION_MZONE,cm.negcon,nil,cm.negtg,cm.negop)
end
function cm.thfilter(c,e,tp)
	return rswk.IsSetST(c) and (c:IsAbleToHand() or c:IsSSetable())
end
function cm.thop(e,tp)
	rsop.SelectSolve(HINTMSG_SELF,tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,cm.thfun,e,tp)
end
function cm.thfun(g,e,tp)
	local tc=g:GetFirst()
	local b1=tc:IsAbleToHand()
	local b2=tc:IsSSetable()
	local op=rsop.SelectOption(tp,b1,{m,1},b2,{m,2})
	if op==1 then
		return rsop.SendtoHand(tc,nil,REASON_EFFECT)
	else
		return Duel.SSet(tp,tc)
	end
end
function cm.atkval(e,c)
	return e:GetHandler():GetEquipCount()*500
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and rswk.gecon(e,tp)
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_SZONE,0,1,1,nil,{})>0 and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end