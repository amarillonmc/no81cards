--深海姬的假面舞会
function c13015722.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1,13015722)
	e2:SetCondition(c13015722.xxcon) 
	e2:SetTarget(c13015722.xxtg) 
	e2:SetOperation(c13015722.xxop) 
	c:RegisterEffect(e2) 
	--change 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)   
	e3:SetRange(LOCATION_SZONE) 
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e3:SetValue(ATTRIBUTE_WATER) 
	c:RegisterEffect(e3) 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_CHANGE_RACE)   
	e3:SetRange(LOCATION_SZONE) 
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e3:SetValue(RACE_AQUA) 
	c:RegisterEffect(e3)
	--splimit 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) 
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0) 
	e4:SetTarget(function(e,c)
	return not c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_EXTRA) end)  
	c:RegisterEffect(e4)
end
function c13015722.xxcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(function(c) return c:IsSetCard(0xe01) and c:IsType(TYPE_MONSTER) end,1,nil)  
end 
function c13015722.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and c:IsSetCard(0xe01) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
	local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) 
	if chk==0 then return b1 or b2 or b3 end  
end 
function c13015722.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	local b1=Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and c:IsSetCard(0xe01) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
	local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) 
	local op=3 
	if b1 and b2 and b3 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015722,1),aux.Stringid(13015722,2),aux.Stringid(13015722,3))
	elseif b1 and b2 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015722,1),aux.Stringid(13015722,2))
	elseif b1 and b3 then   
		op=Duel.SelectOption(tp,aux.Stringid(13015722,1),aux.Stringid(13015722,3))
		if op==1 then op=op+1 end 
	elseif b2 and b3 then   
		op=Duel.SelectOption(tp,aux.Stringid(13015722,2),aux.Stringid(13015722,3))+1
	elseif b1 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015722,1)) 
	elseif b2 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015722,2))+1 
	elseif b3 then 
		op=Duel.SelectOption(tp,aux.Stringid(13015722,2))+2  
	end 
	if op==0 then 
		local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToHand() and c:IsSetCard(0xe01) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE,0,1,1,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)   
	elseif op==1 then  
		local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)   
		if sg:GetFirst():IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local lg=Group.FromCards(sg):Select(1-tp,1,1,nil)
			Duel.HintSelection(lg)
			Duel.Remove(lg,POS_FACEDOWN,REASON_RULE)
		end
	elseif op==2 then  
		local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil) 
		Duel.ChangePosition(sg,POS_FACEDOWN)   
		local tc=sg:GetFirst() 
		while tc do 
			tc:CancelToGrave()  
			tc=sg:GetNext() 
		end 
		Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)  
	end  
end
