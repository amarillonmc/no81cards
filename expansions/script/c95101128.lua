--虚无的少女 梅贝尔
function c95101128.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK+TYPE_PENDULUM),3)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c95101128.thtg)
	e1:SetOperation(c95101128.thop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--select
	local e3=Effect.CreateEffect(c)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	--e3:SetCost(c95101128.cost)
	e3:SetTarget(c95101128.target)
	e3:SetOperation(c95101128.operation)
	c:RegisterEffect(e3)
end
function c95101128.pfilter(c,chk)
	return aux.IsCodeListed(c,95101001) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c95101128.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101128.pfilter,tp,LOCATION_EXTRA,0,2,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function c95101128.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c95101128.pfilter,tp,LOCATION_EXTRA,0,2,2,nil,1)--:GetFirst()
	if #tg==2 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c95101128.chkfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsPublic()
end
function c95101128.cfilter(c)
	return aux.IsCodeListed(c,95101001)
end
function c95101128.gcheck(g,ct)
	return g:GetClassCount(Card.GetAttribute)==ct
end
function c95101128.thfilter(c,chk)
	return c:IsSetCard(0xbbd) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c95101128.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c95101128.chkfilter,tp,LOCATION_HAND,0,nil)
	local b1=g:CheckSubGroup(c95101128.gcheck,3,3,1)
	local b2=g:CheckSubGroup(c95101128.gcheck,3,3,3) and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
	local b3=g:CheckSubGroup(c95101128.gcheck,3,3,2) and Duel.IsExistingMatchingCard(c95101128.thfilter,tp,LOCATION_DECK,0,1,nil,0)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(95101128,1),1},
		{b2,aux.Stringid(95101128,2),3},
		{b3,aux.Stringid(95101128,3),2})
	e:SetLabel(op)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,c95101128.gcheck,false,3,3,op)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	if op==1 then
		e:SetCategory(0)
	elseif op==3 then
		e:SetCategory(CATEGORY_DESTROY)
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if sg:FilterCount(c95101128.cfilter,nil)==3 then
		Duel.SetChainLimit(c95101128.chainlm)
	end
end
function c95101128.chainlm(e,rp,tp)
	return tp==rp
end
function c95101128.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	elseif e:GetLabel()==3 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c95101128.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
