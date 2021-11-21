if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
function c16160004.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false) 
--------------"Pendulum EFFECT"----------------
	--cannot sendtohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16160004,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,16160004)
	e1:SetCondition(c16160004.condition)
	e1:SetTarget(c16160004.cstarget)
	e1:SetOperation(c16160004.csoperation)
	c:RegisterEffect(e1)
	--Token im
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c16160004.eftg)
	e2:SetValue(c16160004.efilter)
	c:RegisterEffect(e2)
--------------"Monster EFFECT"----------------
	--Removed Card Cannot Effect
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetTargetRange(1,1)
	e1_1:SetValue(c16160004.aclimit)
	c:RegisterEffect(e1_1)
	--SpecialSummon Gensyonohoto Token
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetDescription(aux.Stringid(16160001,1))
	e2_1:SetCategory(CATEGORY_DESTROY)
	e2_1:SetType(EFFECT_TYPE_QUICK_O)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetCode(EVENT_FREE_CHAIN)
	e2_1:SetCountLimit(1)
	e2_1:SetCost(c16160004.tkcost)
	e2_1:SetTarget(c16160004.tktg)
	e2_1:SetOperation(c16160004.tkop)
	c:RegisterEffect(e2_1)
	--equip
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetDescription(aux.Stringid(16160004,2))
	e3_1:SetCategory(CATEGORY_EQUIP)
	e3_1:SetCode(EVENT_DESTROYED)
	e3_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3_1:SetRange(LOCATION_MZONE)
	e3_1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3_1:SetCondition(c16160004.eqcon)
	e3_1:SetTarget(c16160004.eqtg)
	e3_1:SetOperation(c16160004.eqop)
	c:RegisterEffect(e3_1)
end
function c16160004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c16160004.cstarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c16160004.csoperation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)~=0 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetTargetRange(0,1)
			e2:SetCondition(c16160004.condition1)
			e2:SetValue(c16160004.aclimit1)
			e2:SetReset(RESET_PHASE+PHASE_END,1)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c16160004.condition1(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
--
function c16160004.aclimit1(e,re,tp)
	return true
end
function c16160004.thtarget()
	return true
end
function c16160004.eftg(e,c)
	return true
end
function c16160004.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and (Duel.GetCurrentPhase()>PHASE_BATTLE or Duel.GetCurrentPhase()<PHASE_BATTLE_START)
end
function c16160004.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsStatus(STATUS_BATTLE_DESTROYED) or rc:IsComplexReason(REASON_DESTROY,true,REASON_EFFECT,REASON_BATTLE)
end
function c16160004.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function c16160004.desfilter1(c,g)
	return g:IsContains(c)
end
function c16160004.desfilter(c,sc)
	local sg=sc:GetEquipGroup()
	local gg=Group.CreateGroup()
	gg:Merge(sg)
	gg:AddCard(sc)
	for tc in aux.Next(sg) do
		local cg=tc:GetColumnGroup()
		local num=Duel.GetMatchingGroupCount(c16160004.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,gg,cg)
		if num>0 then
			return true end
	end
end
function c16160004.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipCount()>0 and Duel.IsExistingMatchingCard(c16160004.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,nil,0,0)
end
function c16160004.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=c:GetEquipGroup()
	local deg=Group.CreateGroup()
	local gg=Group.FromCards(c)
	gg:Merge(sg)
	if c:IsRelateToEffect(e) and sg:GetCount()>0 then
		for tc in aux.Next(sg) do
			local cg=tc:GetColumnGroup()
			local g1=Duel.GetMatchingGroup(c16160004.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,gg,cg)
			if g1 then
				deg:Merge(g1)
			end
		end
		Duel.Destroy(deg,REASON_EFFECT)
	end
end
function c16160004.eqfilter(c,sc)
	if c:GetControler()==tp then return end
	if c:IsType(TYPE_TOKEN) then return end
	if c:GetReasonCard() and sc then
		return c:GetReasonCard()==sc
	elseif c:GetReasonEffect():GetHandler() and sc then
		return c:GetReasonEffect():GetHandler()==sc 
	else
		return false
	end
end
function c16160004.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c16160004.eqfilter,nil,e:GetHandler())>0
end
function c16160004.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c16160004.eqfilter,1,nil,e:GetHandler()) end
	local sg=eg:Filter(c16160004.eqfilter,nil,e:GetHandler())
	Duel.SetTargetCard(sg)
end
function c16160004.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(g) do
		if tc:IsRelateToEffect(e) then
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c16160004.eqlimit)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(1000)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e3)
		end
	end
end
function c16160004.eqlimit(e,c)
	return e:GetOwner()==c
end



