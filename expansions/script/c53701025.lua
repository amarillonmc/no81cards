--惧轮 天狼星
function c53701025.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	c:EnableReviveLimit()
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c53701025.value)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53701025,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,53701025)
	e4:SetTarget(c53701025.destg)
	e4:SetOperation(c53701025.desop)
	c:RegisterEffect(e4)
end
function c53701025.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*300
end
function c53701025.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,nil)
	if ct>3 then ct=3 end
	local sg=g:Select(tp,1,ct,nil)
	e:SetLabel(Duel.Remove(sg,POS_FACEUP,REASON_COST))
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,sg:GetCount())
end
function c53701025.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>0 then
		local g=Duel.GetDecktopGroup(1-tp,ct)
		Duel.DisableShuffleCheck()
		Duel.Destroy(g,REASON_EFFECT)
	end
end
