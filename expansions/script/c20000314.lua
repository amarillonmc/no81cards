--模块量产
local m=20000314
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(function(c)return c:IsSetCard(0xfd3)and c:IsFaceup()end,tp,LOCATION_MZONE,0,1,nil)end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSetCard(0xfd3)and c:IsFaceup()end,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if tc:IsFaceup()then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(function(e,re)
					return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
				end)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				e1:SetOwnerPlayer(tp)
				tc:RegisterEffect(e1)
			end
			Duel.BreakEffect()
			if tc:IsSetCard(0x3fd3)and Duel.IsExistingMatchingCard(function(c)return c:IsSetCard(0xfd3)and c:IsAbleToHand()end,tp,LOCATION_DECK,0,1,nil)
				and Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,0))then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSetCard(0xfd3)and c:IsAbleToHand()end,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			end
			if tc:IsSetCard(0x5fd3)and Duel.IsExistingMatchingCard(function(c)return c:IsSetCard(0xfd3)and c:IsAbleToHand()end,tp,LOCATION_GRAVE,0,1,nil)
				and Duel.GetFlagEffect(tp,m+1)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,1))then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSetCard(0xfd3)and c:IsAbleToHand()end,tp,LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
			end
			if tc:IsSetCard(0x6fd3)and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
				and Duel.GetFlagEffect(tp,m+2)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,2))then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
				Duel.HintSelection(g)
				Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
				Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end)
	c:RegisterEffect(e1)
end
