--罗德岛·部署-精锐救援
function c79029354.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029354)
	e1:SetCost(c79029354.cost)
	e1:SetOperation(c79029354.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,09029354)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029354.rectg)
	e2:SetOperation(c79029354.recop)
	c:RegisterEffect(e2)
end
function c79029354.cofil(c,e,tp) 
	return c:IsSetCard(0xa900) and c:IsReleasable() and Duel.IsExistingMatchingCard(c79029354.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp,c)>0 and c:IsType(TYPE_MONSTER)
end
function c79029354.spfil(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c79029354.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029354.cofil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c79029354.cofil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
end
function c79029354.thfil(c) 
	return c:IsSetCard(0xa900) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c79029354.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=Duel.SelectMatchingCard(tp,c79029354.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	if e:GetLabelObject()==nil then return end
	if e:GetLabelObject():GetSummonLocation()==LOCATION_EXTRA and Duel.IsExistingMatchingCard(c79029354.thfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029354,0)) then
	local xg=Duel.SelectMatchingCard(tp,c79029354.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(xg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,xg)
	end
end
function c79029354.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_ONFIELD,0,nil,0xa900)
	local xct=lg:GetClassCount(Card.GetCode)
	if chk==0 then return xct>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(xct*800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,xct*800)
end
function c79029354.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end







