--主宰之怒 污染者
local s,id,o=GetID()
function s.initial_effect(c)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.postg1)
	e2:SetOperation(s.posop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.postg2)
	e3:SetOperation(s.posop2)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(s.sumtg)
	e4:SetOperation(s.raop)
	c:RegisterEffect(e4)
end


function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	if not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) then return end
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE)
end

function s.postg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function s.posop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function s.postg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsFacedown() and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function s.posop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFacedown() then
		Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	end
end 


function s.filter1(c)
	return c:IsFaceup() and (c:GetAttack()~=0 or c:GetDefense()~=0) 
end
function s.filter2(c)
	return c:IsReleasable()
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=true
	local b2=Duel.IsExistingTarget(s.filter1,tp,0,LOCATION_MZONE,1,nil)
	local b3=Duel.CheckReleaseGroupEx(tp,nil,1,REASON_COST,true,c)
	if chk==0 then return true end
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,0)},
			{b2,aux.Stringid(id,1)},
			{b3,aux.Stringid(id,2)})
	if op==1 then
		e:SetLabel(1)
	elseif op==2 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e:SetLabel(2)
	elseif op==3 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,REASON_COST,true,c)
		Duel.Release(g,REASON_COST)
		e:SetLabel(3)
	end
end
function s.raop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(aux.TRUE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		Duel.RegisterEffect(e2,tp)
	elseif e:GetLabel()==2 then
		local sg=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_MZONE,nil,e)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	elseif e:GetLabel()==3 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(aux.TRUE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		Duel.RegisterEffect(e2,tp)
		local sg=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_MZONE,nil,e)
		local tc=sg:GetFirst()
		while tc do
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e3:SetValue(0)
			tc:RegisterEffect(e3)
			tc=sg:GetNext()
		end
	end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end