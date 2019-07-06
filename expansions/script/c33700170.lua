--盖亚圣女 Proto-Summoner 加岛樱
function c33700170.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700170,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,33700170)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c33700170.cost)
	e1:SetTarget(c33700170.damtg)
	e1:SetOperation(c33700170.damop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c33700170.splimcon)
	e2:SetTarget(c33700170.splimit)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700170,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c33700170.tg)
	e3:SetOperation(c33700170.op)
	c:RegisterEffect(e3) 
	--change effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33700170,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,33700169)
	e4:SetCondition(c33700170.chcon)
	e4:SetTarget(c33700170.chtg)
	e4:SetOperation(c33700170.chop)
	c:RegisterEffect(e4)
end
function c33700170.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
 and c:IsSetCard(0x6440) and c:GetAttack()>0
end
function c33700170.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700170.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
   local g=Duel.SelectMatchingCard(tp,c33700170.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	e:SetLabel(g:GetFirst():GetAttack())
end
function c33700170.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,PLAYER_ALL,e:GetLabel())
end
function c33700170.damop(e,tp,eg,ep,ev,re,r,rp)
   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT,true)
	 Duel.Damage(1-p,d,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c33700170.splimcon(e)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return not pc or not pc:IsSetCard(0x3440)
end
function c33700170.splimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c33700170.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return   (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))  and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetTargetPlayer(tp)
end
function c33700170.filter(c)
	return c:IsSetCard(0x3440) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()IsAbleToHand()
end
function c33700170.damfilter(c)
	return not c:IsSetCard(0x3440) 
end
function c33700170.op(e,tp,eg,ep,ev,re,r,rp).op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	local tg=g:FilterCount(c33700170.damfilter,nil)
	if g:GetCount()>0 and g:IsExists(c33700170.filter) and  (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))  then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TARGET)
		local sg=g:FilterSelect(p,c33700170.filter,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.DisableShuffleCheck()
		Duel.SortDecktop(tp,tp,4)
		if tg>0 then 
		Duel.Damage(tp,tg*400,REASON_EFFECT)	   
	end
end
end
function c33700170.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_HAND and rc:IsSetCard(0x6440)	   
end
function c33700170.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700170.sefilter,rp,LOCATION_DECK,0,1,nil) end
end
function c33700170.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c33700170.repop)
end
function c33700170.sefilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6440) and c:IsAbleToHand()
end
function c33700170.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700170.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end