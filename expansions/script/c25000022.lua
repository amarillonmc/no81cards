--根源破灭海神 伽库佐姆
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000022)
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,true)
	e1:SetRange(LOCATION_DECK)
	local e2=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rscost.cost(cm.tdfilter,"td",rsloc.gr,0,3),rsop.target(rscf.spfilter2(),"sp"),cm.spop) 
	local e3=rsef.QO_NEGATE(c,"neg",{1,m+100},"des",LOCATION_MZONE,rscon.negcon(2,true))
	e3:SetOperation(cm.negop)
	local e5=rsef.QO(c,EVENT_CHAINING,{m,1},{1,m+100},"neg,se,th,ga","dcal,dsp",LOCATION_MZONE,rscon.negcon(4,true),nil,rsop.target2(cm.negfun,cm.thfilter,"th",rsloc.dgr),cm.negop2)
	--local e4=rsef.STO(c,EVENT_LEAVE_FIELD,{m,1},{1,m+200},"des","de,dsp",cm.descon,nil,rsop.target(cm.desfilter,"des",0,LOCATION_ONFIELD,true),cm.desop)
end
function cm.tdfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsFaceup() and c:IsSetCard(0xaf1)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,re:GetHandler():GetAttack(),REASON_EFFECT)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousPosition(POS_FACEUP)
end
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.desop(e,tp)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.negfun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xaf1) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function cm.negop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		rsop.SelectToHand(tp,cm.thfilter,tp,rsloc.dgr,0,1,1,nil,{})
	end
end