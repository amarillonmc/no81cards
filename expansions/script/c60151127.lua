--├军团次席 律法者丽安塔┤
function c60151127.initial_effect(c)
	c:SetUniqueOnField(1,0,60151127)
	--synchro summon
	aux.AddSynchroProcedure(c,c60151127.tfilter,aux.NonTuner(Card.IsSetCard,0x9b23),2)
	c:EnableReviveLimit()
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151101,2))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60151127.atkcon)
	e1:SetTarget(c60151127.cointg)
	e1:SetOperation(c60151127.coinop)
	c:RegisterEffect(e1)
	local e111=Effect.CreateEffect(c)
	e111:SetDescription(aux.Stringid(60151101,2))
	e111:SetCategory(CATEGORY_DESTROY)
	e111:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e111:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e111:SetCode(EVENT_SPSUMMON_SUCCESS)
	e111:SetCondition(c60151127.atkcon2)
	e111:SetTarget(c60151127.cointg)
	e111:SetOperation(c60151127.coinop)
	c:RegisterEffect(e111)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetTarget(c60151127.destg)
	e2:SetOperation(c60151127.desop)
	c:RegisterEffect(e2)
end
c60151127.toss_coin=true
function c60151127.tfilter(c)
	return c:IsSetCard(0x9b23)
end
function c60151127.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and not e:GetHandler():IsHasEffect(60151199)
end
function c60151127.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and e:GetHandler():IsHasEffect(60151199)
end
function c60151127.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151127.chlimit)
		Duel.RegisterFlagEffect(tp,60151127,RESET_CHAIN,0,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
	end
end
function c60151127.chlimit(e,ep,tp)
	return tp==ep
end
function c60151127.filter2(c)
	return c:IsAbleToGrave()
end
function c60151127.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsDestructable()
end
function c60151127.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local res=0
	if Duel.GetFlagEffect(tp,60151127)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		local g=Duel.GetMatchingGroup(c60151127.filter,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if res==1 then
		--disable and destroy
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60151123,1))
		e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EVENT_SPSUMMON)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c60151127.condition)
		e1:SetOperation(c60151127.disop)
		c:RegisterEffect(e1)
	end
end
function c60151127.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep
end
function c60151127.disop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,60151127)
		local res=0
		res=Duel.TossCoin(tp,1)
		if res==0 then
			if Duel.SelectYesNo(tp,aux.Stringid(60151127,0)) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,c60151127.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
				if g1:GetCount()>0 then
					Duel.SendtoGrave(g1,REASON_EFFECT)
				end
			end
		end
		if res==1 then
			Duel.NegateSummon(eg)
			Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
		end
end
function c60151127.filter3(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c60151127.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151127.filter3,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c60151127.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	local g=Duel.GetMatchingGroup(c60151127.filter3,tp,LOCATION_GRAVE,0,nil)
	local g1=Duel.GetMatchingGroup(c60151127.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c60151127.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60151127.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		if Duel.Draw(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(60151127,0)) then Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,c60151127.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoGrave(g1,REASON_EFFECT)
			end
		end
	end
end