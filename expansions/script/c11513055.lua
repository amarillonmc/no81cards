--轮回统治者·泽勒尔
function c11513055.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_PHASE+PHASE_END) 
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_DECK) 
	e2:SetCondition(c11513055.hspcon) 
	e2:SetOperation(c11513055.hspop) 
	c:RegisterEffect(e2)	
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1) end)
	c:RegisterEffect(e3) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e,te)
	return te:GetOwner()~=e:GetOwner() end) 
	c:RegisterEffect(e3)
	--atk 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BECOME_TARGET) 
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCountLimit(1)
	e4:SetCondition(c11513055.atkcon)
	e4:SetTarget(c11513055.atktg)
	e4:SetOperation(c11513055.atkop)
	c:RegisterEffect(e4) 
	--td dr 
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK) 
	e5:SetType(EFFECT_TYPE_IGNITION) 
	e5:SetRange(LOCATION_HAND) 
	e5:SetCountLimit(1,11513055) 
	e5:SetTarget(c11513055.tddtg) 
	e5:SetOperation(c11513055.tddop)  
	c:RegisterEffect(e5) 
	if not c11513055.global_check then
		c11513055.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c11513055.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c11513055.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if tc:IsLevel(1) then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),11513055,0,0,0)  
		end 
		if tc:IsLevel(2) then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),21513055,0,0,0)  
		end 
		if tc:IsLevel(3) then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),31513055,0,0,0)  
		end 
		if tc:IsLevel(4) then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),41513055,0,0,0)  
		end 
		if tc:IsLevel(5) then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),51513055,0,0,0)  
		end 
		if tc:IsLevel(6) then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),61513055,0,0,0)  
		end 
		if tc:IsLevel(7) then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),71513055,0,0,0)  
		end 
		if tc:IsLevel(8) then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),81513055,0,0,0)  
		end 
		if tc:IsLevel(9) then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),91513055,0,0,0)  
		end 
		if tc:IsLevel(10) then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),1513055,0,0,0)  
		end 
		tc=eg:GetNext()
	end
end
function c11513055.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetTurnPlayer()==tp  
	   and Duel.GetFlagEffect(tp,11513055)~=0 
	   and Duel.GetFlagEffect(tp,21513055)~=0 
	   and Duel.GetFlagEffect(tp,31513055)~=0 
	   and Duel.GetFlagEffect(tp,41513055)~=0 
	   and Duel.GetFlagEffect(tp,51513055)~=0 
	   and Duel.GetFlagEffect(tp,61513055)~=0 
	   and Duel.GetFlagEffect(tp,71513055)~=0 
	   and Duel.GetFlagEffect(tp,81513055)~=0 
	   and Duel.GetFlagEffect(tp,91513055)~=0 
	   and Duel.GetFlagEffect(tp,1513055)~=0   
end 
function c11513055.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c11513055.hspcon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(11513055,0)) then 
		Duel.Hint(HINT_CARD,0,11513055) 
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,11513055)
		if g:GetCount()>0 then 
			Duel.BreakEffect() 
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)  
		end 
	end 
end 
function c11513055.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c11513055.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c11513055.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(c:GetAttack()*2) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)	
	end 
end
function c11513055.tddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and e:GetHandler():IsAbleToDeck() end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)   
end
function c11513055.tddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,1,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then 
		Duel.BreakEffect() 
		Duel.Draw(tp,1,REASON_EFFECT)   
	end 
end 





