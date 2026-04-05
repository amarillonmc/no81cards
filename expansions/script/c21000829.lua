--泳装福利开放！
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.cost2)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.prop2)
	c:RegisterEffect(e3)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,99,REASON_COST+REASON_DISCARD)
	e:SetLabel(ct)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num = e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,num) end
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local num = e:GetLabel()
	if Duel.IsPlayerCanDiscardDeck(tp,num) then
		Duel.ConfirmDecktop(tp,num)
		local g=Duel.GetDecktopGroup(tp,num)
		local cnum = 0
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(s.filter0,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g:Filter(s.filter0,nil)
				g:Sub(sg)
				cnum = Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
			end
		end
		if cnum <= 0 then return end
		local ct = g:GetCount()
		if ct>0 then 
			Duel.SortDecktop(tp,tp,ct)
			for i=1,ct do
				local mg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
			end
		end
		if not Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil) then return end
		local dnum = Duel.GetMatchingGroupCount(s.filter1,tp,LOCATION_MZONE,0,nil)
		if dnum>0 and Duel.IsPlayerCanDiscardDeck(tp,dnum) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local dg=Duel.GetDecktopGroup(tp,dnum)
			Duel.SendtoGrave(dg,REASON_EFFECT)
		end
	end
end
function s.filter0(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsType(0x609)
end


function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.thfilter(c)
	return c:IsSSetable() and c:IsSetCard(0x609) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL))
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsSSetable() and Duel.SSet(tp,tc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			tc:RegisterEffect(e2)
		end
	end
end