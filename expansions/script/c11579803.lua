--衔尾蛇
function c11579803.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c11579803.lcheck)
	c:EnableReviveLimit() 
	--draw 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_TODECK) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11579803)  
	e1:SetTarget(c11579803.xxtg) 
	e1:SetOperation(c11579803.xxop) 
	c:RegisterEffect(e1) 
end
function c11579803.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkRace)==1 
end 
function c11579803.setfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) or ((c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable(true))  
end 
function c11579803.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c11579803.setfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,c) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED) 
end 
function c11579803.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsPlayerCanDraw(tp,1) and Duel.Draw(tp,1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c11579803.setfil,tp,LOCATION_HAND,0,1,nil,e,tp) then 
		local tc=Duel.SelectMatchingCard(tp,c11579803.setfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst() 
		if tc:IsType(TYPE_MONSTER) then 
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		else 
			Duel.SSet(tp,tc)
		end 
		if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,c) then 
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,1,c) 
			if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) then 
				local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil) 
				if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,nil) then  
					local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,1,nil) 
					Duel.SendtoDeck(dg,nil,SEQ_DECKTOP,REASON_EFFECT) 
				end 
			end 
		end 
	end 
end 



