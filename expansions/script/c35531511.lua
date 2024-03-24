--灰流丽·为什么会有墓指这种东西
function c35531511.initial_effect(c)
	aux.AddCodeList(c,14558127) 
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(function(c) return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_ZOMBIE) end),2)
	c:EnableReviveLimit() 
	--remove
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,35531511) 
	e1:SetTarget(c35531511.rmtg)
	e1:SetOperation(c35531511.rmop)
	c:RegisterEffect(e1) 
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCondition(c35531511.damcon)
	e2:SetOperation(c35531511.damop)
	c:RegisterEffect(e2) 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15531511)
	e2:SetCondition(c35531511.discon)
	e2:SetTarget(c35531511.distg)
	e2:SetOperation(c35531511.disop)
	c:RegisterEffect(e2)
end
function c35531511.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=Duel.GetMatchingGroupCount(function(c) return (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) end,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return x>0 and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,x,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),nil,LOCATION_ONFIELD)
end
function c35531511.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c35531511.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function c35531511.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c35531511.cfilter,1,nil,tp)
end
function c35531511.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,35531511)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c35531511.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c35531511.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c35531511.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end


