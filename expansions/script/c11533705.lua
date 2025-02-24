--界十万
function c11533705.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,c11533705.lcheck)
	c:EnableReviveLimit()
	--to deck and draw 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11533705) 
	e1:SetTarget(c11533705.tddtg) 
	e1:SetOperation(c11533705.tddop) 
	c:RegisterEffect(e1) 
end 
function c11533705.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()  
end
function c11533705.tddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)  
end 
function c11533705.seqfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function c11533705.tddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,99,nil) 
		local ct=Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)  
		local p=tp
		for i=1,2 do
			local dg=sg:Filter(c11533705.seqfilter,nil,p)
			if #dg>1 then
				Duel.SortDecktop(tp,p,#dg)
			end
			for i=1,#dg do
				local mg=Duel.GetDecktopGroup(p,1)
				Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
			end
			p=1-tp
		end   
		local x=0 
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then x=1 end 
		if Duel.Draw(tp,ct,REASON_EFFECT)~=0 and x==1 and Duel.SelectYesNo(tp,aux.Stringid(11533705,0)) then 
			Duel.Draw(tp,1,REASON_EFFECT)  
		end 
	end  
end 







