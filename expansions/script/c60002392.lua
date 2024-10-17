--隐秘的拉比林斯王
local cm,m,o=GetID()
function cm.initial_effect(c)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(cm.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x17e))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000000)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
if not cm.lblsz then
	cm.lblsz=true
	cm._sset=Duel.SSet
	Duel.SSet=function (tp,cg,...)
		local single=0
		if aux.GetValueType(cg)=="Card" and cg:IsSetCard(0x17e) and cg:IsType(TYPE_TRAP) then
			single=1
		elseif aux.GetValueType(cg)=="Group" then
			if cg:GetCount()==1 and cg:GetFirst():IsSetCard(0x17e) and cg:GetFirst():IsType(TYPE_TRAP) then
				single=1
			end
		end
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,m) and single==1 and Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			local tg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,m)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
			return 0
		else
			return cm._sset(tp,cg,...)
		end
	end
end
function cm.indtg(e,c)
	return c:IsFacedown()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return false end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if not te then return false end
	local b1=te:GetHandler():IsSetCard(0x17e) and not te:GetHandler():IsCode(m)
	local b2=te:GetActiveType()==TYPE_TRAP
	return (b1 or b2) and p==tp and rp==1-tp
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end