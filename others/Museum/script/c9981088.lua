--自然棘团子
function c9981088.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981088,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,99810880)
	e2:SetTarget(c9981088.thtg)
	e2:SetOperation(c9981088.thop)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9981088)
	e1:SetCondition(c9981088.spcon)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9981088,ACTIVITY_CHAIN,c9981088.chainfilter)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981088.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981088.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981088,0))
end
function c9981088.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0x2a) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE)
end
function c9981088.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCustomActivityCount(9981088,tp,ACTIVITY_CHAIN)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c9981088.thfilter(c,tp)
	return c:IsSetCard(0x2a) and c:GetType()==0x20004
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c9981088.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981088.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9981088.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9981088,3))
	local g=Duel.SelectMatchingCard(tp,c9981088.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end