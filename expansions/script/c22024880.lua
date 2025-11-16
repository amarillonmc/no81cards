--星之开拓者-莱昂纳多·达·芬奇
function c22024880.initial_effect(c)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(c22024880.condition)
	e1:SetTarget(c22024880.target)
	e1:SetOperation(c22024880.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCost(c22024880.cost)
	e2:SetDescription(aux.Stringid(22024880,1))
	c:RegisterEffect(e2)
end
function c22024880.filter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xaff1)
end
function c22024880.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep and Duel.GetCurrentChain()==0 and eg:IsExists(c22024880.filter,1,nil)
end
function c22024880.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,eg,eg:GetCount(),0,0)
end
function c22024880.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	if Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) then 
		local sc=Duel.GetFirstMatchingCard(c22024880.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
			if sc and Duel.SelectYesNo(tp,aux.Stringid(22024880,0)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
	end
end
function c22024880.sfilter(c,e,tp)
	return c:IsCode(22024870) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22024880.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end