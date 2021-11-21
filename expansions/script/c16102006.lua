--SCP-96 害羞的人
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102006,"SCP")
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,false)
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.sprcon,cm.sprop)   
	--local e3=rsef.FTO(c,EVENT_CHAIN_SOLVING,{m,0},nil,"des","de",LOCATION_MZONE,cm.descon,nil,rsop.target(aux.TRUE,"des",LOCATION_MZONE,LOCATION_MZONE,true),cm.desop) 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.descon2)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	--Damage Calc
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.tgcon)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
	local e5=rsef.SV_REDIRECT(c,"leave",LOCATION_HAND,rscon.excard2(rscf.CheckSetCard,LOCATION_ONFIELD,0,1,nil,"SCP_J"))
end
function cm.spcfilter(c,tp)
	return c:IsReleasable() and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function cm.spcfilter2(c,tp)
	return c:IsControler(tp) and c:IsCode(16102002)
end
function cm.spzfilter(g,tp)
	if Duel.GetMZoneCount(tp,g,tp)<=0 then return false end
	return g:FilterCount(cm.spcfilter2,nil,tp)==2 or (#g==1 and g:IsExists(cm.spcfilter,1,nil,tp))
end
function cm.sprcon(e,c,tp)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Card.IsCode,nil,16102002)
	local g2=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil,tp)
	return (g1+g2):CheckSubGroup(cm.spzfilter,1,2,tp)
end
function cm.sprop(e,tp)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Card.IsCode,nil,16102002)
	local g2=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil,tp)
	rshint.Select(tp,"res")
	local sg=(g1+g2):SelectSubGroup(tp,cm.spzfilter,false,1,2,tp)
	Duel.Release(sg,REASON_COST)
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsContains(e:GetHandler())
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_MONSTER)
		 and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_MONSTER)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c==Duel.GetAttacker() or c==Duel.GetAttackTarget()) and c:GetBattleTarget() 
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc or not bc:IsRelateToBattle() then return end
	Duel.SendtoGrave(bc,REASON_RULE)
	if c:IsChainAttackable() then
		Duel.ChainAttack()
	end
end
