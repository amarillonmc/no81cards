--时穿剑反
local m=14000018
local cm=_G["c"..m]
cm.named_with_Chronoblade=1
xpcall(function() require("expansions/script/c14000001") end,function() require("script/c14000001") end)
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCondition(cm.condition2)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_SSET)
	e5:SetCondition(cm.condition2)
	e5:SetTarget(cm.target3)
	e5:SetOperation(cm.activate3)
	c:RegisterEffect(e5)
	--remain field
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(cm.discon)
	e7:SetOperation(cm.disop)
	c:RegisterEffect(e7)
end
function cm.filter(c,tp)
	return c:GetColumnGroup():IsExists(cm.lfilter,1,nil,tp)
end
function cm.lfilter(c,tp)
	return c:IsFaceup() and chrb.CHRB(c) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsAbleToDeck() and c:IsOnField()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if not eg or not eg:IsExists(cm.filter,1,nil,tp) then return end
	return Duel.IsChainNegatable(ev) and rp==1-tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst()
	local tg=Group.CreateGroup()
	while tc do
		tg:Merge(tc:GetColumnGroup():Filter(function(c) return c:IsControler(1-tp) and c:IsAbleToGrave() end,nil))
		tc=eg:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,tg:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		local tg=ec:GetColumnGroup():Filter(function(c) return c:IsControler(1-tp) and c:IsAbleToGrave() end,nil)
		tg:AddCard(ec)
		local cg=ec:GetColumnGroup():Filter(cm.lfilter,nil,tp)
		Duel.HintSelection(tg)
		if Duel.SendtoGrave(tg,REASON_RULE)~=0 then
			if #cg>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local cg1=cg:Select(tp,1,1,nil)
				if Duel.SendtoDeck(cg1,tp,2,REASON_EFFECT) then
					Duel.Damage(1-tp,1000,REASON_EFFECT)
				end
			end
		end
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not eg or not eg:IsExists(cm.filter,1,nil,tp) then return end
	return Duel.GetCurrentChain()==0 and rp==1-tp
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.filter,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	local tc=eg:GetFirst()
	local tg=Group.CreateGroup()
	while tc do
		tg:Merge(tc:GetColumnGroup():Filter(function(c) return c:IsControler(1-tp) and c:IsAbleToGrave() end,nil))
		tc=eg:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(cm.filter,nil,tp)
	Duel.NegateSummon(tg)
	local tc=tg:GetFirst()
	local g=Group.CreateGroup()
	local cg=Group.CreateGroup()
	while tc do
		tc:CancelToGrave()
		g:Merge(tc:GetColumnGroup():Filter(function(c) return c:IsControler(1-tp) and c:IsAbleToGrave() end,nil))
		g:AddCard(tc)
		cg:Merge(tc:GetColumnGroup():Filter(cm.lfilter,nil,tp))
		tc=tg:GetNext()
	end
	Duel.HintSelection(g)
	if Duel.SendtoGrave(g,REASON_RULE)~=0 then
		if cg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local cg1=cg:Select(tp,1,1,nil)
			if Duel.SendtoDeck(cg1,tp,2,REASON_EFFECT) then
				Duel.Damage(1-tp,1000,REASON_EFFECT)
			end
		end
	end
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst()
	local tg=Group.CreateGroup()
	while tc do
		tg:Merge(tc:GetColumnGroup():Filter(function(c) return c:IsControler(1-tp) and c:IsAbleToGrave() end,nil))
		tc=eg:GetNext()
	end
	if eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,tg:GetCount(),0,0)
	Duel.SetChainLimit(cm.limit(tg))
end
function cm.limit(tg)
	return  function (e,lp,tp)
				return not tg:IsContains(e:GetHandler())
			end
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(cm.filter,nil,tp)
	local mg=tg:Filter(Card.IsType,nil,TYPE_MONSTER)
	if mg:GetCount()>0 then
		Duel.NegateSummon(mg)
		local tc=mg:GetFirst()
		while tc do
			tc:CancelToGrave()
			tc=mg:GetNext()
		end
	end
	local tc=tg:GetFirst()
	local g=Group.CreateGroup()
	local cg=Group.CreateGroup()
	while tc do
		g:Merge(tc:GetColumnGroup():Filter(function(c) return c:IsControler(1-tp) and c:IsAbleToGrave() end,nil))
		g:AddCard(tc)
		cg:Merge(tc:GetColumnGroup():Filter(cm.lfilter,nil,tp))
		tc=tg:GetNext()
	end
	Duel.HintSelection(g)
	if Duel.SendtoGrave(g,REASON_RULE)~=0 then
		if cg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local cg1=cg:Select(tp,1,1,nil)
			if Duel.SendtoDeck(cg1,tp,2,REASON_EFFECT)~=0 and cg1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
				Duel.Damage(1-tp,1000,REASON_EFFECT)
			end
		end
	end
end
function cm.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and chrb.CHRB(c) and c:IsAttackPos() and seq1==4-seq2
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	seq=aux.MZoneSequence(seq)
	return rp==1-tp and ((loc&LOCATION_SZONE==LOCATION_SZONE) or(loc&LOCATION_MZONE==LOCATION_MZONE)) 
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
end