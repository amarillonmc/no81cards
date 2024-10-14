--S.B.系统 记忆泄露
local s,id,o=GetID()
function c21401125.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOGRAVE)
	--e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummon(tp)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		return g:FilterCount(Card.IsAbleToHand,nil)>0 and
			Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local sg=Group.CreateGroup()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<6 then
		sg=g:Select(tp,1,1,nil)
	else
		sg=g:Select(tp,1,2,nil)
	end
	e:SetLabel(Duel.Remove(sg,POS_FACEUP,REASON_COST))
	Duel.SetTargetPlayer(tp)
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end

function s.thfilter(c,e,tp)
	return c:IsSetCard(0x3d70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()*3
	
	local tp=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(tp,ct)
	local totg=Duel.GetDecktopGroup(tp,ct)
	local g=totg:Filter(s.thfilter,nil,e,tp)
	if g:GetCount()>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		totg:Sub(sg)
	end
	if #totg ~= Duel.Remove(totg,POS_FACEDOWN,REASON_EFFECT) then
		Duel.ShuffleDeck(tp)
	end	
	

end
