--远古造物 三峡夷陵虫
Duel.LoadScript("c9910700.lua")
function c9910702.initial_effect(c)
	--flag
	QutryYgzw.AddTgFlag(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c9910702.target)
	e1:SetOperation(c9910702.operation)
	c:RegisterEffect(e1)
end
function c9910702.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910702.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-p,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xc950) and QutryYgzw.SetFilter(tc,e,p)
			and Duel.IsPlayerCanDraw(p,1) and Duel.SelectYesNo(p,aux.Stringid(9910702,0)) then
			if QutryYgzw.Set(tc,e,p) then Duel.Draw(p,1,REASON_EFFECT) end
		elseif not tc:IsSetCard(0xc950) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(p)
	end
end
