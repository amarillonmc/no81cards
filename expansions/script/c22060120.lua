--异天枝-拉结尔
function c22060120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22060120,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22060120)
	e1:SetCost(c22060120.cost)
	e1:SetTarget(c22060120.target)
	e1:SetOperation(c22060120.operation)
	c:RegisterEffect(e1)
end
function c22060120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
end
function c22060120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)

end
function c22060120.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c22060120.bantg)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,1-tp,REASON_EFFECT)
	end
end
function c22060120.bantg(e,c)
	local fcode=e:GetLabel()
	return c:IsOriginalCodeRule(fcode)
end
