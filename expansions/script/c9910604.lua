--星辉之星镜
function c9910604.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910604+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910604.cost)
	e1:SetTarget(c9910604.target)
	e1:SetOperation(c9910604.activate)
	c:RegisterEffect(e1)
end
function c9910604.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
		and Duel.CheckReleaseGroup(tp,nil,2,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local g=Duel.SelectReleaseGroup(tp,nil,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c9910604.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
end
function c9910604.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	local sg=Group.CreateGroup()
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local ct1=math.min(#g1,5)
		local sg1=g1:Select(tp,ct1,ct1,nil)
		sg:Merge(sg1)
	end
	if #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local ct2=math.min(#g2,5)
		local sg2=g2:Select(1-tp,ct2,ct2,nil)
		sg:Merge(sg2)
	end
	if #sg>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
