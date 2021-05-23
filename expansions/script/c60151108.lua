--├黑魔司令 谢赛伽特┤
function c60151108.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c60151108.spcon)
	e2:SetOperation(c60151108.spop)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c60151108.sumsuccon)
	e3:SetOperation(c60151108.sumsuc)
	c:RegisterEffect(e3)
	--coin
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,60151108)
	e4:SetCondition(c60151108.coincon)
	e4:SetTarget(c60151108.cointg)
	e4:SetOperation(c60151108.coinop)
	c:RegisterEffect(e4)
	local e444=Effect.CreateEffect(c)
	e444:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e444:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e444:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e444:SetCode(EVENT_SPSUMMON_SUCCESS)
	e444:SetCountLimit(1,60151108)
	e444:SetCondition(c60151108.coincon2)
	e444:SetTarget(c60151108.cointg)
	e444:SetOperation(c60151108.coinop)
	c:RegisterEffect(e444)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60151108,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,6011108)
	e5:SetCondition(c60151108.spcon2)
	e5:SetTarget(c60151108.sptg2)
	e5:SetOperation(c60151108.spop2)
	c:RegisterEffect(e5)
end
c60151108.toss_coin=true
function c60151108.coincon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(60151199)
end
function c60151108.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(60151199)
end
function c60151108.cfilter(c)
	return not c:IsAbleToDeckOrExtraAsCost()
end
function c60151108.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9b23)
end
function c60151108.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60151108.cfilter2,tp,LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0
		and not g:IsExists(c60151108.cfilter,1,nil)
end
function c60151108.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c60151108.cfilter2,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct>0 then
		local a=Group.CreateGroup()
		for i=1,ct do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g1=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
			if g1:GetFirst():IsAbleToDeckOrExtraAsCost() then 
				a:Merge(g1)
			end
		end
		Duel.SendtoDeck(a,nil,2,REASON_COST)
		local a1=a:GetCount()
		for i=1,a1 do
			e:GetHandler():RegisterFlagEffect(60151108,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c60151108.sumsuccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c60151108.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(60151108)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(ct*400)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e:GetHandler():RegisterEffect(e2)
end
function c60151108.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151108.chlimit)
		Duel.RegisterFlagEffect(tp,60151108,RESET_CHAIN,0,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c60151108.chlimit(e,ep,tp)
	return tp==ep
end
function c60151108.filter2(c)
	return c:IsAbleToGrave()
end
function c60151108.filter3(c)
	return true
end
function c60151108.filter4(c,tp)
	return c:GetOwner()==tp and c:IsLocation(LOCATION_GRAVE) 
end
function c60151108.coinop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() then return end
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local res=0
	if Duel.GetFlagEffect(tp,60151108)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151108.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
	if res==1 then
		local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
		local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
		local a=Group.CreateGroup()
		if ct1>ct2 then
			local g2=Duel.GetMatchingGroup(c60151108.filter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
			if g2:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g2:Select(tp,ct1-ct2,ct1-ct2,nil)
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_RULE)
				Duel.BreakEffect()
				local og=Duel.GetOperatedGroup()
				local ct=og:FilterCount(c60151108.filter4,nil,tp)
				if ct>0 then
					Duel.Draw(tp,ct,REASON_EFFECT)
				end
			end
		elseif ct1<ct2 then
			local g2=Duel.GetMatchingGroup(c60151108.filter3,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
			if g2:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local sg=g2:Select(1-tp,ct2-ct1,ct2-ct1,nil)
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_RULE)
				Duel.BreakEffect()
				local og=Duel.GetOperatedGroup()
				local ct=og:FilterCount(c60151108.filter4,nil,tp)
				if ct>0 then
					Duel.Draw(tp,ct-1,REASON_EFFECT)
				end
			end
		else 
			return false
		end
	end
end
function c60151108.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler()~=e:GetHandler()
		and re:GetHandler():IsSetCard(0x9b23)
end
function c60151108.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c60151108.spop2(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(60151199)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9b23))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end