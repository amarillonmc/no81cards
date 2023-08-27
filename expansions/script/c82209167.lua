--炽之域
local m=82209167
local cm=c82209167
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.thcost)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end

--activate
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function cm.cfilter(c)
	return c:IsSetCard(0x5294) and c:IsDiscardable()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) 
	and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetOperation(cm.thop)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--damage
function cm.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x5294)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.check1(e,tp,eg,ep,ev,re,r,rp) or cm.check2(e,tp,eg,ep,ev,re,r,rp) or cm.check3(e,tp,eg,ep,ev,re,r,rp) end
end
--check for atkchange
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5294)
end
function cm.check1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m+10000)==0 
	and Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil) 
end
--check for destroy
function cm.check2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m+20000)==0 
	and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) 
end
--check for damage
function cm.check3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m+30000)==0 
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local effects={}
	local options={}
	if cm.check1(e,tp,eg,ep,ev,re,r,rp) then
		table.insert(effects,1)
		table.insert(options,aux.Stringid(m,1))
	end
	if cm.check2(e,tp,eg,ep,ev,re,r,rp) then
		table.insert(effects,2)
		table.insert(options,aux.Stringid(m,2))
	end
	if cm.check3(e,tp,eg,ep,ev,re,r,rp) then
		table.insert(effects,3)
		table.insert(options,aux.Stringid(m,3))
	end
	if #options==0 then return end
	local option=Duel.SelectOption(tp,table.unpack(options))+1
	local effect=effects[option]

	if effect==1 then 
		Duel.RegisterFlagEffect(tp,m+10000,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.SelectMatchingCard(tp,cm.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then  
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,5))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DIRECT_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	
	if effect==2 then
		Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
	
	if effect==3 then
		Duel.RegisterFlagEffect(tp,m+30000,RESET_PHASE+PHASE_END,0,1)   
		Duel.Damage(1-tp,1500,REASON_EFFECT)
	end
end