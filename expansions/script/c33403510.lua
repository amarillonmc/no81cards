--森罗万象 万界之眼
local m=33403510
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	XY.REZS(c)
   --
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)  
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetFlagEffect(tp,33413501)<(Duel.GetFlagEffect(tp,33403501)/2+1)and Duel.GetFlagEffect(tp,m+30000)==0 and Duel.GetFlagEffect(tp,33443500)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
 if chk==0 then return true end
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
e:SetLabel(1)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x5349)and  not c:IsCode(33403500)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
 local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
   local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
   local g3=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
   local g4=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chkc then return true end
	if chk==0 then return g1:GetCount()>0 or g2:GetCount()>0 or g3:GetCount()>0 or g4:GetCount()>0 end  
if e:GetLabel()==1 then 
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop2)
	e2:SetReset(RESET_EVENT+RESET_CHAIN+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1)   --t2
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1) --t1
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)   --duel 1
	e:SetLabel(2)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x5349) and rp==tp
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local n1=Duel.GetFlagEffect(tp,33413501)
	local n2=Duel.GetFlagEffect(tp,33403501)
	local n3=Duel.GetFlagEffect(tp,m+20000)
	Duel.ResetFlagEffect(tp,33413501)
	Duel.ResetFlagEffect(tp,33403501)
	Duel.ResetFlagEffect(tp,m+20000)
	if n1>=2 then 
		for i=1,n1-1 do
		Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1)
		end 
	end
	if n2>=2 then
		for i=1,n2-1 do
		 Duel.RegisterFlagEffect(tp,33403501,0,0,0)
		end 
	end
	if n3>=2 then 
		for i=1,n3 do
		  Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1)
		end 
	end 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
   local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
   local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
   local g3=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
   local g4=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local off=1
	local ops={}
	local opval={}
	if g1:GetCount()~=0 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if g2:GetCount()~=0 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if g3:GetCount()~=0 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=3
		off=off+1
	end
	if g4:GetCount()~=0 then
		ops[off]=aux.Stringid(m,4)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		 Duel.ConfirmCards(tp,g1)
		 Duel.ShuffleHand(1-tp)
	elseif opval[op]==2 then
	   Duel.ConfirmCards(tp,g2)
	elseif opval[op]==3 then
		Duel.ConfirmCards(tp,g3)
	elseif opval[op]==4 then
	  Duel.ConfirmCards(tp,g4) 
	end
	if Duel.IsExistingMatchingCard(cm.tfilter2,tp,LOCATION_HAND,0,1,nil) then 
		if Duel.SelectYesNo(tp,aux.Stringid(m,5)) then 
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,6))
			local g=Duel.SelectMatchingCard(tp,cm.tfilter2,tp,LOCATION_HAND,0,1,1,nil)
			local tc=g:GetFirst()
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_PUBLIC)
			e2_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2_1)
			tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,0,0,66)
			 local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(0,1)
			if tc:IsType(TYPE_MONSTER) then
				e1:SetDescription(aux.Stringid(m,7))
				e1:SetValue(cm.aclimit1)
			elseif tc:IsType(TYPE_SPELL) then
				e1:SetDescription(aux.Stringid(m,8))
				e1:SetValue(cm.aclimit2)
			else
				e1:SetDescription(aux.Stringid(m,9))
				e1:SetValue(cm.aclimit3)
			end
			e1:SetReset(RESET_PHASE+PHASE_END,1)
			Duel.RegisterEffect(e1,tp)
		end
	end 
end
function cm.tfilter2(c)
	return not c:IsPublic()
end
function cm.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function cm.aclimit3(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
