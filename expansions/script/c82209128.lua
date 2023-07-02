--圆神，启动！
local m=82209128
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end  
function cm.numcheck(num,num2)
	return (num==4 or num==num2)
end
function cm.rmfilter(c)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.filter(c,num)  
	return c:IsAbleToHand() 
	and ((c:IsSetCard(0x132) and c:IsType(TYPE_MONSTER) and cm.numcheck(num,0))
	or (c:IsSetCard(0x14a) and cm.numcheck(num,1))
	or (c:IsCode(71645242) and cm.numcheck(num,2))
	or (c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAttack(300) and c:IsDefense(100) and cm.numcheck(num,3)))
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,4) end
	local numbers={}
	local options={}
	for i=0,3 do
		if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,i) then
			table.insert(numbers,i)
			table.insert(options,aux.Stringid(m,i))
		end
	end
	local num=numbers[Duel.SelectOption(tp,table.unpack(options))+1]
	e:SetLabel(num)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local rg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(cm.rmfilter,nil)
	if rg:GetCount()>0 and Duel.Remove(rg:RandomSelect(1-tp,1),POS_FACEDOWN,REASON_EFFECT)~=0 then
		if not (e:GetLabel()>-1 and e:GetLabel()<4) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())  
		if g:GetCount()>0 then  
			Duel.SendtoHand(g,nil,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,g)  
		end  
	end
end