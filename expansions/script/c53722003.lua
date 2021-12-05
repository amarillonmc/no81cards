local m=53722003
local cm=_G["c"..m]
cm.name="大祭环 祗芭"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.GreatCircle(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
end
cm.list={
		CATEGORY_DESTROY,
		CATEGORY_RELEASE,
		CATEGORY_REMOVE,
		CATEGORY_TOHAND,
		CATEGORY_TODECK,
		CATEGORY_TOGRAVE,
		CATEGORY_DECKDES,
		CATEGORY_HANDES,
		CATEGORY_POSITION,
		CATEGORY_CONTROL,
		CATEGORY_DISABLE,
		CATEGORY_DISABLE_SUMMON,
		CATEGORY_EQUIP,
		CATEGORY_DAMAGE,
		CATEGORY_RECOVER,
		CATEGORY_ATKCHANGE,
		CATEGORY_DEFCHANGE,
		CATEGORY_COUNTER,
		CATEGORY_LVCHANGE,
		CATEGORY_NEGATE,
}
function cm.nfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x3531) and c:IsType(TYPE_MONSTER)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not rp==1-tp then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) or (g and g:IsExists(cm.nfilter,1,nil)) then return false end
	if cm.nfilter(re:GetHandler()) then return true end
	local res,ceg,cep,cev,re,r,rp=Duel.CheckEvent(re:GetCode())
	if res and ceg and ceg:IsExists(cm.nfilter,1,nil) then return true end
	for i,ctg in pairs(cm.list) do
		local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,ctg)
		if tg then
			if tg:IsExists(cm.nfilter,1,nil) then return true end
		elseif v and v>0 and Duel.IsExistingMatchingCard(cm.nfilter,tp,v,0,1,nil) then
			return true
		end
	end
	return false
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,2) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end
