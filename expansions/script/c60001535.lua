--终焉的白骨圣堂之主
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	byd.CountdownSP(c,3)
	--eup
	local ee1=Effect.CreateEffect(c)
	ee1:SetType(EFFECT_TYPE_SINGLE)
	ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee1:SetRange(LOCATION_MZONE)
	ee1:SetCode(EFFECT_UPDATE_ATTACK)
	ee1:SetCondition(cm.incon)
	ee1:SetValue(800)
	c:RegisterEffect(ee1)
	local ee2=ee1:Clone()
	ee2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ee2)
	
	local ee3=Effect.CreateEffect(c)
	ee3:SetDescription(aux.Stringid(m,0))
	ee3:SetCategory(CATEGORY_COUNTER)
	ee3:SetType(EFFECT_TYPE_QUICK_O)
	ee3:SetCode(EVENT_FREE_CHAIN)
	ee3:SetRange(LOCATION_MZONE)
	ee3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	ee3:SetCountLimit(1)
	ee3:SetCondition(cm.incon)
	ee3:SetTarget(cm.etg)
	ee3:SetOperation(cm.eop)
	c:RegisterEffect(ee3)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.cfil(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x625,1)
end
function cm.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(cm.cfil,tp,LOCATION_ONFIELD,0,1,nil) then b1=true end
	if Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT) then b2=true end
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x625)
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(cm.cfil,tp,LOCATION_ONFIELD,0,1,nil) then b1=true end
	if Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT) then b2=true end
	if not b1 and not b2 then return end
	local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(m,1)},
				{b2,aux.Stringid(m,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,cm.cfil,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
		if tc then tc:AddCounter(0x625,1) end
	elseif op==2 then
		Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT)
	end
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if Duel.Destroy(sg,REASON_EFFECT)~=0 then
		local dmg=#Duel.GetOperatedGroup()*400
		if Duel.Damage(1-tp,dmg,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
			local dg=Group.CreateGroup()
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-dmg)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)  
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)  
				if tc:GetAttack()==0 or (tc:GetDefense()==0 and not tc:IsType(TYPE_LINK)) then
					dg:AddCard(tc)
				end
			end 
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end