--光灵巨像
local m=82209053
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep(c,cm.matfilter,3,true) 
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE,0,Duel.Remove,POS_FACEDOWN,REASON_COST)  
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e1:SetValue(cm.splimit)  
	c:RegisterEffect(e1)  
	--disable  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e2:SetTarget(cm.disable)  
	e2:SetCode(EFFECT_DISABLE)  
	c:RegisterEffect(e2)  
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	--double  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetCondition(cm.damcon)
	e4:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))  
	c:RegisterEffect(e4)  
end  
cm.toss_coin=true  
function cm.splimit(e,se,sp,st)  
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA  
end  
function cm.matfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY)
end
function cm.disable(e,c)  
	return c:IsAttribute(ATTRIBUTE_DARK) and c~=e:GetHandler()
end  
function cm.rmfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup() and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0) 
end  
function cm.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local res=Duel.TossCoin(tp,1)  
	local g
	if res==1 then
		g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_MZONE,nil)
		local ct=Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		if ct>0 then
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_UPDATE_ATTACK)  
			e1:SetValue(ct*1000)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)  
			c:RegisterEffect(e1) 
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	else
		g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end  
function cm.damfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.damcon(e,c,tp)
	return not Duel.IsExistingMatchingCard(cm.damfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end