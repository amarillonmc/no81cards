--方舟骑士-桃金娘
c29065523.named_with_Arknight=1
function c29065523.initial_effect(c)
	c:EnableCounterPermit(0x10ae)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c29065523.btcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Effect 2  
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(29065523,2))
	e51:SetCategory(CATEGORY_COUNTER+CATEGORY_RECOVER)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_MZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1)
	e51:SetTarget(c29065523.cttg)
	e51:SetOperation(c29065523.ctop)
	c:RegisterEffect(e51)   
	--all
	if not c29065523.global_check then
		c29065523.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c29065523.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--all
function c29065523.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) then return end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE and rc:IsCode(29065523) then
		rc:RegisterFlagEffect(rc:GetOriginalCodeRule()+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(rc:GetOriginalCodeRule(),0))
	end
end
--Effect 1
function c29065523.btcon(e)
	local ec=e:GetHandler()
	return ec:GetFlagEffect(ec:GetOriginalCodeRule()+100)>0
end
--Effect 2
function c29065523.stf(c) 
	local b1=c:IsSetCard(0x87af)
	local b2=(_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)
	return b1 or b2
end
function c29065523.f(c) 
	return c29065523.stf(c) and c:IsFaceup() and c:GetAttack()>0
end
function c29065523.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x10ae,2) end
end
function c29065523.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if not ec:IsRelateToEffect(e) then return end
	ec:AddCounter(0x10ae,2)
	if ec:GetCounter(0x10ae)<2 then return false end
	local g=Duel.GetMatchingGroup(c29065523.f,tp,LOCATION_MZONE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(29065523,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tag=g:Select(tp,1,1,nil)
		if #tag==0 then return false end
		Duel.BreakEffect()
		Duel.HintSelection(tag)
		local tc=tag:GetFirst()
		local atk=tc:GetAttack()
		Duel.Recover(tp,atk/2,REASON_EFFECT)
	end
end 