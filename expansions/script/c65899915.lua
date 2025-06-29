--剑刃解放
function c65899915.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65899915.target)
	e1:SetOperation(c65899915.activate)
	c:RegisterEffect(e1)
end
function c65899915.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,65899915)
	if chk==0 then return ct<2 or (ct==2 and Duel.IsPlayerCanDraw(tp,2)) end
	if ct==1 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	elseif ct==2 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function c65899915.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,65899915)
	if ct<2 then
		Duel.RegisterFlagEffect(tp,65899915,0,0,0)
	end
	if (ct==1 or (ct==2 and Duel.Draw(tp,2,REASON_EFFECT)>0))
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(65899915,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
