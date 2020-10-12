function c82221061.initial_effect(c)  
	--pendulum summon  
	aux.EnablePendulumAttribute(c,false)  
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep2(c,c82221061.mfilter,2,2,false)  
	aux.AddContactFusionProcedure(c,c82221061.mfilter2,LOCATION_HAND+LOCATION_EXTRA,0,Duel.SendtoGrave,REASON_COST+REASON_FUSION+REASON_MATERIAL)  
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	c:RegisterEffect(e1) 
	--banish
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221061,0))  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,82221061)   
	e1:SetTarget(c82221061.tdtg)  
	e1:SetOperation(c82221061.tdop)  
	c:RegisterEffect(e1)  
	--ac
	local e2=Effect.CreateEffect(c)   
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)  
	e2:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1) 
	e2:SetValue(c82221061.aclimit)  
	c:RegisterEffect(e2)  
end  
function c82221061.mfilter(c)  
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_PENDULUM)
end  
function c82221061.mfilter2(c)  
	return c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end   
function c82221061.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end  
end  
function c82221061.tdop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,1-tp,LOCATION_HAND,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end  
end  
function c82221061.aclimit(e,re,tp)  
	return re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_REMOVED  
end  