--召唤夺取
function c49966672.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c49966672.target)
	e1:SetOperation(c49966672.activate)
	c:RegisterEffect(e1)
end
function c49966672.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0  end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c49966672.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		local tg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SUMMON)
			local sg=tg:Select(p,1,1,nil)
			local tc=sg:GetFirst()
		if tc:IsSummonable(true,nil) then
			Duel.Summon(tp,tc,true,nil)
		end
end
		Duel.ShuffleHand(1-p)
	end
end