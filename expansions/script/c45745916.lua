--极翼灵兽 Galar火焰鸟
function c45745916.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x881),10,2)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745916,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,45745916)
	e1:SetCondition(c45745916.diccon)
	e1:SetTarget(c45745916.dictg)
	e1:SetOperation(c45745916.dicop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45745916,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,45745983)
	e2:SetCost(c45745916.discost)
	e2:SetTarget(c45745916.distg)
	e2:SetOperation(c45745916.disop)
	c:RegisterEffect(e2)

end
--e1
function c45745916.diccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c45745916.dictg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,Duel.GetTurnPlayer(),1)
end
function c45745916.dicop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end
--e2
function c45745916.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c45745916.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c45745916.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end