local m=82224045
local cm=_G["c"..m]
cm.name="伊芙莉莎"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,cm.mfilter,1)  
	c:EnableReviveLimit() 
	--spsummon  
	local e4=Effect.CreateEffect(c)  
	e4:SetCategory(CATEGORY_COUNTER)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e4:SetType(EFFECT_TYPE_IGNITION)	 
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.cost)  
	e4:SetTarget(cm.tg)  
	e4:SetOperation(cm.op)  
	c:RegisterEffect(e4) 
end
function cm.mfilter(c)  
	return c:IsLinkRace(RACE_SPELLCASTER) and not c:IsLinkType(TYPE_LINK)
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)  
end  
function cm.filter(c)  
	return c:IsFaceup() and c:IsCanAddCounter(0x1,2)  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and cm.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x1)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		if tc:IsCanAddCounter(0x1,2) then  
			tc:AddCounter(0x1,2)  
		end  
	end  
end  