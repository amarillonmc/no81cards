--森罗万象第十三乐章「摘要渊源」
local m=33403504
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	XY.REZS(c)
   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
local ss=Duel.GetTurnCount()
local ck=0
  local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if  te:GetHandler():IsSetCard(0x5349) or ( tg and (tg:IsExists(Card.IsOnField,1,nil)) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET))  then
			ck=1
		end
	end
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			return Duel.GetFlagEffect(tp,33413501)<ss and Duel.GetFlagEffect(tp,m+30000)==0   and ck==1 and Duel.GetFlagEffect(tp,33443500)==0
		end
	end
	return false
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
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
		end
	end
	Duel.SetTargetCard(ng)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ng,ng:GetCount(),0,0)
	 if e:GetLabel()==1 then 
	Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1) --t1
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1) --t1+t2
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)  
	e:SetLabel(2)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
   local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.NegateActivation(i) then
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te)  then
				tc:CancelToGrave()
				dg:AddCard(tc)
			end
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
   local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
	   if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		  local tg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,99,nil)
		  local tc1=tg:GetFirst() 
		  while tc1 do
		  local atk=tc1:GetBaseAttack()
		  local def=tc1:GetBaseDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(def)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterEffect(e2)
			tc1=tg:GetNext()
		  end 
	   end
	end
end
