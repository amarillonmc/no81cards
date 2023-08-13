--皇家之辉 艾克萨
function c11579804.initial_effect(c)
	c:SetSPSummonOnce(11579804)
	c:EnableReviveLimit()
	--race 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_ADD_RACE) 
	e1:SetRange(0xff) 
	e1:SetValue(RACE_CYBERSE) 
	c:RegisterEffect(e1)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11579804.sprcon)
	e2:SetOperation(c11579804.sprop) 
	e2:SetValue(function(e) 
	return 0,4 end)
	c:RegisterEffect(e2)
	--disable field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(c11579804.dzoneval)
	e1:SetCondition(function(e) 
	return e:GetHandler():GetSequence()<5 end)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SELF_DESTROY)  
	e1:SetRange(LOCATION_MZONE)   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e1) 
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(c11579804.sdtg) 
	c:RegisterEffect(e2)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval) 
	e2:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)<=3 end)
	c:RegisterEffect(e2)
	--battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.imval1)
	e2:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)<=3 end)
	c:RegisterEffect(e2) 
	--sb1 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(11579804,1))
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11579804+EFFECT_COUNT_CODE_DUEL) 
	e3:SetTarget(c11579804.sbtg1) 
	e3:SetOperation(c11579804.sbop1) 
	c:RegisterEffect(e3)
	--sb2 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(11579804,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,21579804+EFFECT_COUNT_CODE_DUEL) 
	e3:SetTarget(c11579804.sbtg2) 
	e3:SetOperation(c11579804.sbop2) 
	c:RegisterEffect(e3)
	--sb3 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(11579804,3))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,31579804+EFFECT_COUNT_CODE_DUEL) 
	e3:SetTarget(c11579804.sbtg3) 
	e3:SetOperation(c11579804.sbop3) 
	c:RegisterEffect(e3) 
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(function(e,c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) end)
	c:RegisterEffect(e4)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
end
c11579804.SetCard_ZH_RoyalGlory=true 
function c11579804.rlfil(c) 
	return c:IsFaceup() and c:IsReleasable() 
	   and ((c:IsRace(RACE_DRAGON) and c:GetBaseAttack()>=4500)   
	   or (c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)))
end 
function c11579804.rlgck(g,e,tp) 
	return g:FilterCount(function(c) return (c:IsRace(RACE_DRAGON) and c:GetBaseAttack()>=4500) end,nil)==1 
	   and g:FilterCount(function(c) return (c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)) end,nil)==1   
	   and Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler(),4)>0 
end 
function c11579804.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c11579804.rlfil,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c11579804.rlgck,2,2,e,tp)
end
function c11579804.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c11579804.rlfil,tp,LOCATION_MZONE,0,nil) 
	local rg=g:SelectSubGroup(tp,c11579804.rlgck,false,2,2,e,tp)
	Duel.Release(rg,REASON_COST) 
end
function c11579804.dzoneval(e) 
	local c=e:GetHandler() 
	local seq=c:GetSequence()  
	local zone=0 
	local x=1 
	if c:GetControler()==1 then x=65536 end 
	if seq==0 then 
		zone=bit.bor(zone,2*x)
	end 
	if seq==1 then 
		zone=bit.bor(zone,1*x)
		zone=bit.bor(zone,4*x)
	end 
	if seq==2 then 
		zone=bit.bor(zone,2*x)
		zone=bit.bor(zone,8*x)
	end 
	if seq==3 then 
		zone=bit.bor(zone,4*x)
		zone=bit.bor(zone,16*x)
	end 
	if seq==4 then 
		zone=bit.bor(zone,8*x) 
	end 
	return zone  
end 
function c11579804.sdckfil(c,e,xc) 
	return c==e:GetHandler() and c:GetSequence()<5 and math.abs(c:GetSequence()-xc:GetSequence())==1 
end 
function c11579804.sdtg(e,c) 
	local tp=e:GetHandlerPlayer() 
	return c:GetSequence()<5 and Duel.IsExistingMatchingCard(c11579804.sdckfil,tp,LOCATION_MZONE,0,1,nil,e,c) 
end 
function c11579804.sbtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11579804)==0 end 
	Duel.RegisterFlagEffect(tp,11579804,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end 
function c11579804.sbop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(c11579804.negcon)  
	e1:SetOperation(c11579804.negop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
end  
function c11579804.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end 
function c11579804.cgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c11579804.cgcon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(11579804,2)) then 
		Duel.ChangeChainOperation(ev,c11579804.repop) 
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		e:Reset()   
	end 
end 
function c11579804.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT) 
end
function c11579804.sbtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11579804)==0 and e:GetHandler():IsAbleToRemove() end 
	Duel.RegisterFlagEffect(tp,11579804,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0) 
end 
function c11579804.sbop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)  
		e1:SetRange(LOCATION_REMOVED) 
		e1:SetCondition(c11579804.cgcon)
		e1:SetOperation(c11579804.cgop) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1) 
	end 
end
function c11579804.negcon(e,tp,eg,ep,ev,re,r,rp)   
	local g=eg:Filter(function(c,tp) return c:IsSummonPlayer(1-tp) and c:IsCanChangePosition() and not c:IsPosition(POS_FACEDOWN_DEFENSE) end,nil,tp)
	return Duel.GetCurrentChain()==0 and Duel.GetFlagEffect(tp,21579804)==0 and g:GetCount()>0 
end
function c11579804.negop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=eg:Filter(function(c,tp) return c:IsSummonPlayer(1-tp) and c:IsCanChangePosition() and not c:IsPosition(POS_FACEDOWN_DEFENSE) end,nil,tp)
	if c11579804.negcon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(11579804,1)) then  
		e:Reset()  
		Duel.RegisterFlagEffect(tp,21579804,RESET_PHASE+PHASE_END,0,2)
		Duel.ChangePosition(g,POS_FACEDOWN) 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		tc=g:GetNext() 
		end 
	end 
end
function c11579804.sbtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11579804)==0 and e:GetHandler():IsAbleToRemove() end 
	Duel.RegisterFlagEffect(tp,11579804,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0) 
end 
function c11579804.sbop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START) 
		e1:SetCountLimit(1) 
		e1:SetLabelObject(c) 
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		e:Reset() 
		if Duel.ReturnToField(e:GetLabelObject()) then 
			local g=Duel.GetMatchingGroup(function(c) return c:IsCanChangePosition() and not c:IsPosition(POS_FACEDOWN_DEFENSE) end,tp,0,LOCATION_MZONE,nil) 
			local dg=g:Select(tp,1,3,nil)  
			Duel.ChangePosition(dg,POS_FACEDOWN_DEFENSE) 
		end end) 
		Duel.RegisterEffect(e1,tp)
	end 
end



