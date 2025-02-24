--Walk This Way!鹿乃
function c75646410.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,75646410)
	e1:SetCost(c75646410.cost)
	e1:SetTarget(c75646410.target)
	e1:SetOperation(c75646410.activate)
	c:RegisterEffect(e1)
	--special
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,5646410)
	e2:SetCost(c75646410.spcost)
	e2:SetTarget(c75646410.sptg)
	e2:SetOperation(c75646410.spop)
	c:RegisterEffect(e2)
end
function c75646410.filter(c)
	return  c:IsSetCard(0x32c4) and c:IsAbleToGraveAsCost()
end
function c75646410.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646410.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) and g:FilterCount(Card.IsAbleToGraveAsCost,nil)==1 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c75646410.filter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	if g:GetFirst():IsSetCard(0x32c4) then e:SetLabel(1) else e:SetLabel(0) end
	g:Merge(g1)
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646410.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c75646410.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)<1 then return end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x32c4) and Duel.SelectYesNo(tp,aux.Stringid(75646410,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75646402,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x32c4)
		local tc=g:GetFirst()
		if tc then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
		end
	end
end
function c75646410.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c75646410.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75646411,0x32c4,0x4011,0,2300,5,RACE_PSYCHO,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c75646410.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,75646411,0x32c4,0x4011,0,2300,5,RACE_PSYCHO,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,75646411)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end