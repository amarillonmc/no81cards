--动物朋友 北之玄武
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700084.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(33700084,2))
	Senya.AddAttackSE(c,aux.Stringid(33700084,3))
		--xyz summon
	c:EnableReviveLimit()
	Senya.AddXyzProcedureCustom(c,c33700084.xyzfilter,c33700084.xyzcheck,1,2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700084,4))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c33700084.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55935416,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33700084.drcost)
	e1:SetTarget(c33700084.drtg)
	e1:SetOperation(c33700084.drop)
	c:RegisterEffect(e1)
end
function c33700084.xyzfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4) or (c:IsSummonableCard() and c:IsSetCard(0x442))
end
function c33700084.xyzcheck(g,xyzc)
	if g:GetCount()==1 then
		local tc=g:GetFirst()
		return tc:IsSummonableCard() and tc:IsSetCard(0x442)
	else
		if g:IsExists(function(c) return not c:IsXyzLevel(xyzc,4) end,1,nil) then return false end
		local tc1=g:GetFirst()
		local tc2=g:GetNext()
		return not (tc1:IsCode(tc2:GetCode()) or tc1:IsAttribute(tc2:GetAttribute()) or tc1:IsRace(tc2:GetRace()))
	end
end
function c33700084.indcon(e)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c33700084.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33700084.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(33700084,5))
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c33700084.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,g:GetCount(),REASON_EFFECT)
	 local cg=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-tp,cg)
   if cg:GetClassCount(Card.GetCode)~=cg:GetCount() then
	Duel.SendtoGrave(cg,REASON_EFFECT)
end
   Duel.ShuffleHand(tp)
end