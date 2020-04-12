--森罗万象第二十三乐章 「因果再筑」
local m=33403507
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	XY.REZS(c)
   --
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)   
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return  ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.GetFlagEffect(tp,33413501)<(Duel.GetFlagEffect(tp,33403501)/2+1)and Duel.GetFlagEffect(tp,m+30000)==0 and Duel.GetFlagEffect(tp,33443500)==0
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
	if chk==0 then return true end  
	 local ct=500*Duel.GetFlagEffect(tp,33403501) 
	 if ct>=4000 then ct=4000 end 
	 Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct)
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
	local cp=Duel.GetTurnPlayer()
   if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
	 Duel.SkipPhase(cp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
   end 
	 local ct=500*Duel.GetFlagEffect(tp,33403501) 
	 if ct>=4000 then ct=4000 end 
	 Duel.Recover(tp,ct,REASON_EFFECT)
	if Duel.GetLP(tp)>=Duel.GetLP(1-tp)*4 and Duel.GetFlagEffect(tp,33403501)>=23 then
		 if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0x7e,0x7e,aux.ExceptThisCard(e))
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
				Duel.SetLP(1-tp,4000)
				Duel.SetLP(tp,4000)
			   if Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_DECK,1,nil,e,tp) and Duel.SelectYesNo(1-tp,aux.Stringid(m,1))  then 
				 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				 local g=Duel.SelectMatchingCard(1-tp,cm.filter,1-tp,LOCATION_DECK,0,1,1,nil,e,tp)
				 Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP) 
				 local tc1=g:GetFirst()
				  local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc1:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc1:RegisterEffect(e2)
			   end
			   if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1))  then 
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			   local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				 local tc1=g:GetFirst()
				  local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc1:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc1:RegisterEffect(e2)
			   end
		 end
	end 
end
function cm.tdfilter(c)
	return (c:IsLocation(0x1e) or c:IsLocation(LOCATION_REMOVED) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsAbleToDeck()
end
function cm.filter(c,e,tp)
	return  c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end