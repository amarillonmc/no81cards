--重兵装型女子高中生・Drei
function c67670310.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c67670310.mfilter,2)
	c:EnableReviveLimit() 
	--cannot be material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c67670310.limit)
	c:RegisterEffect(e1)   
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)   
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_REMOVE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(1,1)
	e7:SetTarget(c67670310.infilter)
	c:RegisterEffect(e7) 
	--remove
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_CHAINING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,67670310*1)
	e8:SetCondition(c67670310.rmcon)
	e8:SetCost(c67670310.rmcost)
	e8:SetOperation(c67670310.rmop)
	c:RegisterEffect(e8)
end
function c67670310.mfilter(c)
	return c:IsSetCard(0x1b7)
end
function c67670310.limit(e,c,sumtype)
	if not c then return false end
	return not c:IsSetCard(0x1b7)
end 
--indes
function c67670310.infilter(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x1b7) and c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and re and r&REASON_EFFECT>0 and rp==1-tp
end
--remove
function c67670310.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c67670310.rmfilter(c)
	return c:IsSetCard(0x1b7) and c:IsAbleToRemoveAsCost()
end
function c67670310.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67670310.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c67670310.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c67670310.rmop(e,tp,eg,ep,ev,re,r,rp)
	local op=0
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
	local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67670310,0),aux.Stringid(67670310,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67670310,0))
	elseif b2 then Duel.SelectOption(tp,aux.Stringid(67670310,1)) op=1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
	else
		local sg=g2:RandomSelect(1-tp,1)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end