--散华
function c11561016.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_HAND) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,11561016)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD) end) 
	e1:SetTarget(c11561016.xxtg) 
	e1:SetOperation(c11561016.xxop) 
	c:RegisterEffect(e1)  
end 
function c11561016.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c11561016.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c11561016.checkop)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,0) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_PHASE+PHASE_END)  
	e2:SetCountLimit(1) 
	e2:SetCondition(c11561016.hxcon) 
	e2:SetOperation(c11561016.hxop) 
	e2:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e2,tp) 
end 
function c11561016.checkop(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(rp,11561016) 
	if flag==nil then 
		Duel.RegisterFlagEffect(rp,11561016,RESET_PHASE+PHASE_END,0,1,1) 
	else 
		flag=flag+1 
		Duel.SetFlagEffectLabel(rp,11561016,flag)  
	end 
end
function c11561016.hxcon(e,tp,eg,ep,ev,re,r,rp)  
	local flag=Duel.GetFlagEffectLabel(1-tp,11561016)  
	return flag and flag>0  
end 
function c11561016.hxop(e,tp,eg,ep,ev,re,r,rp) 
	local flag=Duel.GetFlagEffectLabel(1-tp,11561016)   
	if flag and flag>0 then 
		Duel.Hint(HINT_CARD,0,11561016)
		local x=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) 
		if flag>x then flag=x end  
		local g=Duel.GetDecktopGroup(tp,flag)  
		Duel.ConfirmCards(tp,g) 
		if flag>4 then 
			local d=math.floor(flag/4)  
			local chk=0 
			local a=0 
			local msg=Group.CreateGroup()
			for i=1,d do 
				if chk==0 and g:IsExists(Card.IsAbleToHand,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11561016,0)) then  
					local sg=g:Filter(Card.IsAbleToHand,nil):Select(tp,1,1,nil)
					g:Sub(sg) 
					msg:Merge(sg) 
					a=a+1 
				else 
					chk=1 
				end 
			end 
			Duel.SendtoHand(msg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,msg)   
			if a>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,a,nil) then 
				Duel.BreakEffect() 
				local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,a,a,nil) 
				Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)   
			end 
		end 
	end 
end 
 









