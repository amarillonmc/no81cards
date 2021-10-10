--模块导入
local m=20000310
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,m+1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xfd3)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local b1=Duel.IsPlayerCanDraw(1)
		local b2=Duel.IsExistingMatchingCard(function(c)return c:IsSetCard(0xfd3) and c:IsAbleToHand()end,tp,LOCATION_DECK,0,1,nil)
		local op=0
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,m+1) 
			and e:GetHandler():IsOnField() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local cc=Duel.Release(e:GetHandler(),REASON_EFFECT)
			if cc==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_GRAVE,0,1,1,nil,m+1)
			local tc=g:GetFirst()
			if tc then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
		elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
		else return end
		if op==0 then
			local a=Duel.Draw(tp,1,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSetCard(0xfd3) and c:IsAbleToHand()end,tp,LOCATION_DECK,0,1,1,nil)
			local a=Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end

	end)
	c:RegisterEffect(e1)
end
