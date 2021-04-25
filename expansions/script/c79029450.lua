--个人行动-技力光环
function c79029450.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029450)
	e1:SetCost(c79029450.cost)
	e1:SetTarget(c79029450.target)
	e1:SetOperation(c79029450.activate)
	c:RegisterEffect(e1)  
	--to deck and draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19029450)
	e2:SetCost(c79029450.tdcost)
	e2:SetTarget(c79029450.tdtg)
	e2:SetOperation(c79029450.tdop)
	c:RegisterEffect(e2)
end
function c79029450.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c79029450.filter1(c,e,tp)
	return c:IsSetCard(0xa900) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c79029450.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c79029450.filter2(c,e,tp,tcode)
	return c:IsSetCard(0xd90c) and c.assault_name==tcode and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c79029450.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c79029450.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c79029450.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
end
function c79029450.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c79029450.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
	end 
end
function c79029450.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c79029450.tdfil(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xd90c)
end
function c79029450.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029450.tdfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c79029450.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c79029450.tdfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) then return end
	local sg=Duel.SelectMatchingCard(tp,c79029450.tdfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.Draw(tp,2,REASON_EFFECT)
end
	








