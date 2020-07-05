--求婚
function c79029510.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(c79029510.damtg)
	e1:SetOperation(c79029510.activate)
	c:RegisterEffect(e1)   
end
function c79029510.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c79029510.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local opt=0
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,89252157)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,97574404)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,99030164)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,57935140)
		and Duel.SelectYesNo(tp,aux.Stringid(79029510,2)) then
		opt=1
	end
	if opt==0 then
		opt=Duel.SelectOption(p,aux.Stringid(79029510,0),aux.Stringid(79029510,1))
	else
		opt=Duel.SelectOption(p,aux.Stringid(79029510,0))
	end
	if opt==0 then
		Duel.Win(1-p,WIN_REASON_MARRY)
	end
end