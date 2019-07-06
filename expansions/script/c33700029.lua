--Proto-Summoner 朱音
function c33700029.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51028231,2))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c33700029.secon)
	e1:SetCost(c33700029.cost)
	e1:SetTarget(c33700029.setg)
	e1:SetOperation(c33700029.seop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(33700029,ACTIVITY_SPSUMMON,c33700029.counterfilter)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c33700029.desreptg)
	c:RegisterEffect(e2)
	--Release
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetTarget(c33700029.retg)
	e3:SetOperation(c33700029.reop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--damage/recover
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33700029,3))
	e5:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_RELEASE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c33700029.recon)
	e5:SetTarget(c33700029.lftg)
	e5:SetOperation(c33700029.lfop)
	c:RegisterEffect(e5)
end
function c33700029.counterfilter(c)
	return c:IsSetCard(0x6440)
end
function c33700029.secon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_PZONE) and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function c33700029.sefilter(c)
	return c:IsSetCard(0x6440) and c:IsAbleToHand()
end
function c33700029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil)
   and Duel.GetCustomActivityCount(33700029,tp,ACTIVITY_SPSUMMON)==0 end
	local dg=Duel.GetMatchingGroupCount(c33700029.sefilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,dg,nil)
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabel(cg:GetCount())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33700029.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33700029.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x6440)
end
function c33700029.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c33700029.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,cg,tp,LOCATION_DECK)
end
function c33700029.seop(e,tp,eg,ep,ev,re,r,rp)
	local cg=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700029.sefilter,tp,LOCATION_DECK,0,cg,cg,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
end
function c33700029.filter(c)
	return  c:IsFaceup() and  c:IsSetCard(0x6440) and c:IsReleasableByEffect() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c33700029.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.CheckReleaseGroup(tp,c33700029.filter,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(33700029,0)) then
		local g=Duel.SelectReleaseGroup(tp,c33700029.filter,1,1,c)
		Duel.Release(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c33700029.refilter(c)
	return  c:IsFaceup() and  c:IsSetCard(0x6440) and c:IsType(TYPE_MONSTER)
end
function c33700029.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c33700029.refilter,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
end
function c33700029.reop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.SelectReleaseGroup(tp,c33700029.refilter,1,1,nil)
	if rg:GetCount()>0 and Duel.Release(rg,REASON_EFFECT)>0 then
	e:GetHandler():RegisterFlagEffect(33700029,RESET_EVENT+0x1fe0000,0,1)
end
end
function c33700029.lffilter(c)
	return c:IsSetCard(0x6440) and c:IsType(TYPE_MONSTER)
end
function c33700029.recon(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(c33700029.lffilter,1,nil) and eg:GetCount()==1 and e:GetHandler():GetFlagEffect(33700029)~=0
end
function c33700029.lftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():GetDefense()>0 
	or eg:GetFirst():GetAttack()>0 end
	local op=0
	if eg:GetFirst():GetDefense()>0 and eg:GetFirst():GetAttack()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(33700029,1),aux.Stringid(33700029,2))
	elseif eg:GetFirst():GetAttack()<=0 then
		op=Duel.SelectOption(tp,aux.Stringid(33700029,1))
	else
	op=Duel.SelectOption(tp,aux.Stringid(33700029,2))
	end
	e:SetLabel(op)
	if op==0 then
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(eg:GetFirst():GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,eg:GetFirst():GetDefense())
	else
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(eg:GetFirst():GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,eg:GetFirst():GetAttack())
end
end
function c33700029.lfop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	else
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
end