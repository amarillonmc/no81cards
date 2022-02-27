--无主物之神
function c72412790.initial_effect(c)
		--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c72412790.lcheck)
	--redraw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72412790,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c72412790.drcost)
	e2:SetTarget(c72412790.drtg)
	e2:SetOperation(c72412790.drop)
	c:RegisterEffect(e2)
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c72412790.lcheck(g,lc)
	if #g<2 then return false end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return c1:GetAttack()==c2:GetAttack() or c1:GetDefense()==c2:GetDefense()
end
function c72412790.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end

end
function c72412790.cfilter(c)
	return not c:IsPublic() and c:IsAbleToDeck()
end
function c72412790.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c72412790.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c72412790.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c72412790.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) then
		local g2=Duel.GetDecktopGroup(tp,1)
		local tc2=g2:GetFirst()
		Duel.Draw(tp,1,REASON_EFFECT)
		local e1=Effect.CreateEffect(tc2)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1)
		tc2:RegisterFlagEffect(72412790,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(72412790,0))   
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,0)
		e2:SetValue(c72412790.aclimit)
		e2:SetLabel(tc:GetCode())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c72412790.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
