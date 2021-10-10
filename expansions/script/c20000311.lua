--模块调适
local m=20000311
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,m+1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp,chk)
		return eg:IsExists(function(c)return c:IsSetCard(0xfd3) and c:IsSummonPlayer(tp)end,1,nil)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local b1=Duel.IsExistingMatchingCard(function(c)return c:IsFacedown() and c:IsAbleToDeck()end,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
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
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,function(c)return c:IsFacedown() and c:IsAbleToDeck()end,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
			local a=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
			local a=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end

	end)
	c:RegisterEffect(e2)
end
