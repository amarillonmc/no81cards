--人理之星 罗慕路斯
function c22021380.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xff1),2,2)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021380,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22021380)
	e1:SetTarget(c22021380.cointg)
	e1:SetOperation(c22021380.coinop)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021380,7))
	e2:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22021380)
	e2:SetCondition(c22021380.erescon)
	e2:SetCost(c22021380.erecost)
	e2:SetTarget(c22021380.cointg)
	e2:SetOperation(c22021380.coinop)
	c:RegisterEffect(e2)
end
c22021380.toss_coin=true
function c22021380.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22021380,1))
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c22021380.filter1(c,e,sp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c22021380.filter2(c,e,sp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xff1) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c22021380.coinop(e,tp,eg,ep,ev,re,r,rp)
	local cg1=Duel.GetMatchingGroup(c22021380.filter1,tp,0,LOCATION_DECK,nil,e,tp)
	local cg2=Duel.GetMatchingGroup(c22021380.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	local c=e:GetHandler()
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==0 then
		Duel.SelectOption(tp,aux.Stringid(22021380,3))
	end
	if c1+c2+c3==1 then
		Duel.SelectOption(tp,aux.Stringid(22021380,4))
	end
	if c1+c2+c3==2 then
		Duel.SelectOption(tp,aux.Stringid(22021380,5))
	end
	if c1+c2+c3==3 then
		Duel.SelectOption(tp,aux.Stringid(22021380,6))
	end
	if c1+c2+c3<=2 and cg1:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(1-tp,aux.Stringid(22021380,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg1=cg1:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(sg1,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
	if c1+c2+c3>=2 and cg2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(22021380,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=cg2:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c22021380.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22021380.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end