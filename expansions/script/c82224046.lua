local m=82224046
local cm=_G["c"..m]
cm.name="奎因"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)  
	c:EnableReviveLimit()
	--atk  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con)
	e1:SetValue(3000)  
	c:RegisterEffect(e1)  
end
function cm.lcheck(g,lc)  
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()  
end  
function cm.cfilter(c)  
	return c:GetBaseAttack()>=3000 
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter,p,0,LOCATION_MZONE,1,nil) and not Duel.IsExistingMatchingCard(cm.cfilter,p,LOCATION_MZONE,0,1,nil)  
end  