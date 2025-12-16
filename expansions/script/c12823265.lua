--衣装谐奏
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,500)
end
function s.thfilter(c)
	return c:IsSetCard(0xca70,0x5a70) and c:IsAbleToDeck()
end
function s.thfilter2(c)
	return c:IsSetCard(0xca70) and c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(id)
end
function s.filter(c)
	return c:IsCode(12823205) and c:IsSummonable(true,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local cl=Duel.GetCurrentChain()
	local c=e:GetHandler()
	if Duel.Recover(tp,500,REASON_EFFECT)>0 and Duel.Recover(1-tp,500,REASON_EFFECT)>0 then
		local tg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
		if cl==1 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			if tc then
				Duel.Summon(tp,tc,true,nil)
			end
		end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if cl==5 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
			if sg1 then
			Duel.SendtoHand(sg1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg1)
			end
		end
	end
end
