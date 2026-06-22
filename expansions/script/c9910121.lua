--战车道装甲·丘吉尔MkⅦ
Duel.LoadScript("c9910100.lua")
function c9910121.initial_effect(c)
	--xyz summon
	QutryZcd.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),5,2,c9910121.xyzfilter,99)
	c:EnableReviveLimit()
	--to deck top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910121,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9910121.drcost)
	e1:SetTarget(c9910121.drtg)
	e1:SetOperation(c9910121.drop)
	c:RegisterEffect(e1)
end
function c9910121.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9958) and c:IsFaceup()))
		and c:IsRace(RACE_MACHINE)
end
function c9910121.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsPlayerCanDraw(tp,1) end
	local ct=1
	while c:CheckRemoveOverlayCard(tp,ct,REASON_COST) and Duel.IsPlayerCanDraw(tp,ct) do
		ct=ct+1
	end
	e:SetLabel(c:RemoveOverlayCard(tp,1,ct,REASON_COST))
end
function c9910121.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c9910121.cfilter(c)
	return c:IsSetCard(0x9958) and c:IsLocation(LOCATION_HAND) and not c:IsPublic()
end
function c9910121.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetDecktopGroup(p,d)
	if Duel.Draw(p,d,REASON_EFFECT)==d and g:IsExists(c9910121.cfilter,1,nil)
		and Duel.IsChainDisablable(ev) and Duel.SelectYesNo(p,aux.Stringid(9910121,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CONFIRM)
		local tc=g:FilterSelect(p,c9910121.cfilter,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-p,tc)
		Duel.ShuffleHand(p)
		Duel.NegateEffect(ev)
	end
end
