--mdzz
function c10173030.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173030,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c10173030.negcon)
	e1:SetTarget(c10173030.negtg)
	e1:SetOperation(c10173030.negop)
	c:RegisterEffect(e1) 
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c10173030.atkval)
	c:RegisterEffect(e2)
end
function c10173030.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_GRAVE+LOCATION_REMOVED)*100
end
function c10173030.negcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=nil
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
	   tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	end
	if not Duel.IsChainNegatable(ev) then return false end
	return (re:GetActivateLocation()==LOCATION_GRAVE and re:GetHandlerPlayer()~=tp) or (tg and tg:IsExists(c10173030.cfilter,1,nil,1-tp))
end
function c10173030.cfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
end
function c10173030.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10173030.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if Duel.NegateActivation(ev) and g:GetCount()>0 then
	   local ct=Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	   if ct>0 and c:IsRelateToEffect(e) then
		  Duel.BreakEffect()
		  Duel.Destroy(c,REASON_EFFECT)
	   end
	end
end