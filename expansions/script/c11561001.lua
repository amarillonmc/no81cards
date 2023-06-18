--巴哈精选
function c11561001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11561001.target)
	e1:SetOperation(c11561001.activate)
	c:RegisterEffect(e1)
end
function c11561001.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(12) and c:IsAbleToHand()
end
function c11561001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11561001.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11561001.filter,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:RandomSelect(tp,1)
		if Duel.SendtoHand(sg,tp,REASON_EFFECT)~=0 then 
			Duel.ConfirmCards(1-tp,sg) 
			Duel.BreakEffect()
			local p=tp 
			for i=1,2 do  
			if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>=5 then 
				Duel.ConfirmDecktop(p,5) 
				Duel.SortDecktop(tp,p,5)
				for i=1,5 do
					local mg=Duel.GetDecktopGroup(p,1)
					Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
				end
			end 
			p=1-p 
			end
		end  
	end
end

