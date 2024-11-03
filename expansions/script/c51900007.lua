--《到临·天灾》辛希娅
function c51900007.initial_effect(c)
	aux.AddCodeList(c,51900003) 
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,51900003,function(c) return c:IsFusionAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON+RACE_FAIRY) end,2,127,true,true) 
	--code
	aux.EnableChangeCode(c,51900003,LOCATION_MZONE+LOCATION_GRAVE) 
	--negate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c51900007.discon) 
	e1:SetTarget(c51900007.distg)
	e1:SetOperation(c51900007.disop)
	c:RegisterEffect(e1) 
	--reflect battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c51900007.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
end 
function c51900007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c51900007.rmfilter(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsAbleToRemove()
end 
function c51900007.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c51900007.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,re:GetHandler():GetCode())
	if Duel.NegateEffect(ev) and g:GetCount()>0 then 
		Duel.BreakEffect() 
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	end 
end




