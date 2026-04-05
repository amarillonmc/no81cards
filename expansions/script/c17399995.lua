--美好
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(s.oppcon)
	e2:SetTarget(s.opptg)
	e2:SetOperation(s.oppop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and Duel.GetFlagEffect(rp,id+1)==0 then
		Duel.RegisterFlagEffect(rp,id+1,RESET_PHASE+PHASE_END,0,1)
	elseif re:IsActiveType(TYPE_SPELL) and Duel.GetFlagEffect(rp,id+2)==0 then
		Duel.RegisterFlagEffect(rp,id+2,RESET_PHASE+PHASE_END,0,1)
	elseif re:IsActiveType(TYPE_TRAP) and Duel.GetFlagEffect(rp,id+3)==0 then
		Duel.RegisterFlagEffect(rp,id+3,RESET_PHASE+PHASE_END,0,1)
	end
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	if Duel.GetFlagEffect(1-tp,id+1)>0 then ct=ct+1 end 
	if Duel.GetFlagEffect(1-tp,id+2)>0 then ct=ct+1 end 
	if Duel.GetFlagEffect(1-tp,id+3)>0 then ct=ct+1 end 
	return ct>=2
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		return #g>0 
	end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	s.operation_logic(e,tp)
end
function s.operation_logic(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)   
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()	   
		local d1=0
		local d2=0
		for tc in aux.Next(og) do
			if tc:IsLocation(LOCATION_HAND) then
				if tc:IsPreviousControler(0) then 
					d1=d1+1
				else 
					d2=d2+1 
				end
			end
		end	   
		if d1>0 and Duel.IsPlayerCanDraw(0,d1) and Duel.SelectYesNo(0,aux.Stringid(id,1)) then 
			Duel.Draw(0,d1,REASON_EFFECT) 
		end
		if d2>0 and Duel.IsPlayerCanDraw(1,d2) and Duel.SelectYesNo(1,aux.Stringid(id,1)) then 
			Duel.Draw(1,d2,REASON_EFFECT) 
		end
	end
end
function s.oppcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.opptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function s.oppop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		s.operation_logic(e,1-tp)
	end
end