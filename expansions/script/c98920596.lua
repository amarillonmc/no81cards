--秘仪之力ACE-圣杯
function c98920596.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c98920596.spcon)
	c:RegisterEffect(e0)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920596,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c98920596.cointg)
	e1:SetOperation(c98920596.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--coin result
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920596,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c98920596.coincon1)
	e4:SetCost(aux.bfgcost)
	e4:SetOperation(c98920596.coinop1)
	c:RegisterEffect(e4)
end
c98920596.toss_coin=true
function c98920596.filter(c)
	return c:IsFaceup() and c:IsCode(73206827)
end
function c98920596.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c98920596.filter,c:GetControler(),LOCATION_FZONE,0,1,nil)
end
function c98920596.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c98920596.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	if res==1 then
		if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		   Duel.ShuffleHand(tp)
		   Duel.BreakEffect()
		   Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	else
		local h1=Duel.Draw(tp,1,REASON_EFFECT)
		local h2=Duel.Draw(1-tp,1,REASON_EFFECT)
		if h1>0 and h2>0 then Duel.BreakEffect() end
		if h1>0 then
		   Duel.ShuffleHand(tp)
		   Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c98920596.coincon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex and ct>0 then
		e:SetLabelObject(re)
		return true
	else return false end
end
function c98920596.coinop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_COIN_NEGATE)
	e1:SetCountLimit(1)
	e1:SetCondition(c98920596.coincon2)
	e1:SetOperation(c98920596.coinop2)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c98920596.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c98920596.coinop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,98920596)
	local res={Duel.GetCoinResult()}
	local ct=ev
	for i=1,ct do
		res[i]=1
	end
	Duel.SetCoinResult(table.unpack(res))
end
