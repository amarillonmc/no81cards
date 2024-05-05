--紫炎蔷薇浮现初心
dofile("expansions/script/c9911550.lua")
function c9911565.initial_effect(c)
	--Activate only search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911565,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9911565.cost)
	e1:SetTarget(c9911565.target1)
	e1:SetOperation(c9911565.activate1)
	c:RegisterEffect(e1)
	--Activate when spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911565,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CUSTOM+9911565)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c9911565.target2)
	e2:SetOperation(c9911565.activate2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(9911565,2))
	e3:SetCode(EVENT_CUSTOM+9911566)
	e3:SetTarget(c9911565.target3)
	c:RegisterEffect(e3)
	QutryZyqw.RegisterMergedDelayedEvent(c,9911565,EVENT_SPSUMMON_SUCCESS)
end
function c9911565.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsType,1,REASON_COST,true,nil,TYPE_PENDULUM) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,REASON_COST,true,nil,TYPE_PENDULUM)
	Duel.Release(g,REASON_COST)
end
function c9911565.filter(c)
	return c:IsSetCard(0x6952) and c:IsAbleToHand()
end
function c9911565.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911565.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911565.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911565.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911565,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCountLimit(1,9911565)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9911565.cfilter(c,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetLevel()>0 and c:IsCanBeEffectTarget(e)
end
function c9911565.rfilter(c,mg)
	return c:IsType(TYPE_PENDULUM) and (not mg:IsContains(c) or mg:Filter(aux.TRUE,c):GetClassCount(Card.GetLevel)>=2)
end
function c9911565.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Clone()
	if chk==0 then
		if #g==0 then return false end
		g=g:Filter(c9911565.cfilter,nil,e)
		return g:GetClassCount(Card.GetLevel)>=2 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	end
	g=g:Filter(c9911565.cfilter,nil,e)
	local op=0
	local b0=Duel.IsExistingMatchingCard(c9911565.filter,tp,LOCATION_DECK,0,1,nil)
	local b1=b0 and Duel.CheckReleaseGroupEx(tp,Card.IsType,1,REASON_COST,true,nil,TYPE_PENDULUM)
	local b2=b0 and Duel.CheckReleaseGroupEx(tp,c9911565.rfilter,1,REASON_COST,true,nil,g)
		and Duel.IsExistingMatchingCard(c9911565.filter,tp,LOCATION_DECK,0,1,nil)
	if b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9911565,0),aux.Stringid(9911565,3),aux.Stringid(9911565,4))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9911565,0),aux.Stringid(9911565,3))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911565,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg1=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,REASON_COST,true,nil,TYPE_PENDULUM)
		Duel.Release(rg1,REASON_COST)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(EFFECT_FLAG_DELAY)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g1=g:SelectSubGroup(tp,aux.dlvcheck,false,2,2)
		Duel.SetTargetCard(g1)
		Duel.HintSelection(g1)
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg2=Duel.SelectReleaseGroupEx(tp,c9911565.rfilter,1,1,REASON_COST,true,nil,g)
		Duel.Release(rg2,REASON_COST)
		g:Sub(rg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g2=g:SelectSubGroup(tp,aux.dlvcheck,false,2,2)
		Duel.SetTargetCard(g2)
		Duel.HintSelection(g2)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c9911565.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Filter(function(c) return c:GetFlagEffect(9911551)==0 end,nil)
	if chk==0 then
		if #g==0 or not g:IsExists(function(c) return c:GetFlagEffect(9911550)>0 end,1,nil) then return false end
		g=g:Filter(c9911565.cfilter,nil,e)
		return g:GetClassCount(Card.GetLevel)>=2 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	end
	g=g:Filter(c9911565.cfilter,nil,e)
	local op=0
	local b0=Duel.IsExistingMatchingCard(c9911565.filter,tp,LOCATION_DECK,0,1,nil)
	local b1=b0 and Duel.CheckReleaseGroupEx(tp,Card.IsType,1,REASON_COST,true,nil,TYPE_PENDULUM)
	local b2=b0 and Duel.CheckReleaseGroupEx(tp,c9911565.rfilter,1,REASON_COST,true,nil,g)
		and Duel.IsExistingMatchingCard(c9911565.filter,tp,LOCATION_DECK,0,1,nil)
	if b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9911565,0),aux.Stringid(9911565,3),aux.Stringid(9911565,4))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9911565,0),aux.Stringid(9911565,3))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911565,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg1=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,REASON_COST,true,nil,TYPE_PENDULUM)
		Duel.Release(rg1,REASON_COST)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(EFFECT_FLAG_DELAY)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g1=g:SelectSubGroup(tp,aux.dlvcheck,false,2,2)
		Duel.SetTargetCard(g1)
		Duel.HintSelection(g1)
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg2=Duel.SelectReleaseGroupEx(tp,c9911565.rfilter,1,1,REASON_COST,true,nil,g)
		Duel.Release(rg2,REASON_COST)
		g:Sub(rg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g2=g:SelectSubGroup(tp,aux.dlvcheck,false,2,2)
		Duel.SetTargetCard(g2)
		Duel.HintSelection(g2)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c9911565.cfilter2(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c9911565.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local res=0
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c9911565.filter,tp,LOCATION_DECK,0,1,1,nil)
		if #sg>0 then
			res=Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9911565,5))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCountLimit(1,9911565)
		e1:SetValue(aux.TRUE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if op~=0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9911565.cfilter2,nil,e)
		if #g~=2 then return end
		local lv1=g:GetFirst():GetLevel()
		local lv2=g:GetNext():GetLevel()
		local num=math.abs(lv1-lv2)
		local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		if #tg==0 then return end
		if res then Duel.BreakEffect() end
		for tc in aux.Next(tg) do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(num*300)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e3)
		end
		if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
