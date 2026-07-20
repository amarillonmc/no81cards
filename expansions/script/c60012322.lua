-- 能量外溢
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local all_mode=Duel.GetFlagEffect(tp,60012309)>0
	if all_mode then
		local g=Duel.GetDecktopGroup(tp,7)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			local sg=g:Filter(Card.IsType,nil,TYPE_SPELL)
			if #sg>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tg=sg:Select(tp,1,1,nil)
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
			Duel.ShuffleDeck(tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g2>0 then
			Duel.Destroy(g2,REASON_EFFECT)
		end
		Duel.Recover(tp,2000,REASON_EFFECT)
	else
		local opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		if opt==0 then
			local g=Duel.GetDecktopGroup(tp,7)
			if #g>0 then
				Duel.ConfirmCards(1-tp,g)
				local sg=g:Filter(Card.IsType,nil,TYPE_SPELL)
				if #sg>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local tg=sg:Select(tp,1,1,nil)
					Duel.SendtoHand(tg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tg)
				end
				Duel.ShuffleDeck(tp)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
			Duel.Recover(tp,2000,REASON_EFFECT)
		end
	end
	Duel.RegisterFlagEffect(tp,60012308,RESET_PHASE+PHASE_END,0,1)
end