--争鸣
function c20000076.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1  end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
		local tc=Duel.SendtoDeck(g,1-tp,2,REASON_EFFECT)
		if tc~=0 then
			Duel.ShuffleDeck(1-tp)
			Duel.BreakEffect()
			local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
			for i=1,tc do
				local g2=Duel.GetDecktopGroup(1-tp,1)
				Duel.SendtoDeck(g2,tp,2,REASON_EFFECT)
				local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
			end
		end
	end)
	c:RegisterEffect(e1)
end
