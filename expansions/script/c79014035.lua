--《比第一天来的新人还没用的废物打工仔挽歌》
function c79014035.initial_effect(c)
	aux.AddCodeList(c,79014030)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,19014035) 
	e1:SetCost(c79014035.accost) 
	e1:SetTarget(c79014035.actg) 
	e1:SetOperation(c79014035.acop) 
	c:RegisterEffect(e1) 
	--set 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_GRAVE)   
	e2:SetCountLimit(1,79014035) 
	e2:SetCost(c79014035.setcost)
	e2:SetTarget(c79014035.settg) 
	e2:SetOperation(c79014035.setop) 
	c:RegisterEffect(e2) 
	--act in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
	e3:SetCondition(c79014035.actcon)
	c:RegisterEffect(e3)
end 
function c79014035.pbfil(c) 
	return not c:IsPublic() and c:IsCode(79014030) 
end 
function c79014035.accost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,1000) end 
	Duel.PayLPCost(tp,1000) 
	if e:GetHandler():IsStatus(STATUS_SET_TURN) then
		local g=Duel.SelectMatchingCard(tp,c79014035.pbfil,tp,LOCATION_HAND,0,1,1,nil) 
		if g:GetCount()>0 then 
		Duel.ConfirmCards(1-tp,g) 
		end 
	end
end 
function c79014035.sumfil(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_SPIRIT) and c:IsLevel(4) 
end
function c79014035.musck(c) 
	return c:IsCode(79014036,79014037) 
end 
function c79014035.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c79014035.sumfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end 
	if not Duel.IsExistingMatchingCard(c79014035.musck,tp,LOCATION_FZONE,0,1,nil) then 
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(79014035,0))
	end 
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND +LOCATION_MZONE)
end 
function c79014035.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c79014035.sumfil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.Summon(tp,tc,true,nil) 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c79014035.setcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,500) end 
	Duel.PayLPCost(tp,500)
end 
function c79014035.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil,POS_FACEDOWN) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA) 
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0) 
end 
function c79014035.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil,POS_FACEDOWN) 
	if g:GetCount()>0 then 
		local rg=g:RandomSelect(tp,1) 
		if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 and c:IsSSetable() then  
		Duel.SSet(tp,c)
		end 
	end 
end  
function c79014035.actcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c79014035.pbfil,tp,LOCATION_HAND,0,1,nil) 
end
