--警告记过
local m=33700739
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp) return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,5,nil) end)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)	
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	local tg=g1:Filter(Card.IsAbleToHand,nil)
	local g2=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_DECK,0,nil,e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	local g3=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_DECK,0,nil)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsLocation(LOCATION_HAND) then ft2=ft2-1 end
	local b1=#tg>0
	local b2=(math.min(#g2,ft1)+math.min(#g3,ft2))>=#g1
	local b3=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	if chk==0 then return Duel.CheckLPCost(tp,500) and (b1 or b3) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	local tg=g1:Filter(Card.IsAbleToHand,nil)
	local g2=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_DECK,0,nil,e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	local g3=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_DECK,0,nil)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=#tg>0
	local b2=(math.min(#g2,ft1)+math.min(#g3,ft2))>=#g1
	local b3=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	if #g1<=0 then return end
	if not b1 and not b3 then return end
	if not Duel.CheckLPCost(tp,500) then return end
	Duel.PayLPCost(tp,500)
	if b1 and (not b3 or not Duel.SelectYesNo(1-tp,aux.Stringid(m,0))) then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,1))
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	else
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,2))
		if not b2 then return end
		if not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
		local g5,g6=Group.CreateGroup(),Group.CreateGroup()
		for i=1,#g1 do
			local g4=Group.CreateGroup()
			if ft1>0 then g4:Merge(g2) end
			if ft2>0 then g4:Merge(g3) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g4:Select(tp,1,1,nil):GetFirst()
			if g2:IsContains(tc) then
				g5:AddCard(tc)
				g2:RemoveCard(tc)
				ft1=ft1-1
			else
				g6:AddCard(tc)
				g3:RemoveCard(tc)
				ft2=ft2-1
			end
		end
		if #g5>0 then
			Duel.SpecialSummon(g5,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
		if #g6>0 then
			Duel.SSet(tp,g6)
		end
	end
end

