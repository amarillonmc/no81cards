--圣战残阳· 雷纳德
local m=11579812
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.TRUE,2,99,c11579812.lcheck)
	aux.AddLinkProcedure(c,aux.TRUE,2,99,nil)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11579812.imcon)
	e1:SetValue(c11579812.efilter)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c11579812.atcon)
	e2:SetValue(c11579812.val)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c11579812.reptg)
	e3:SetValue(c11579812.repval)
	e3:SetOperation(c11579812.repop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
  --  e4:SetCost(c11579812.descost)
	e4:SetTarget(c11579812.destg)
	e4:SetOperation(c11579812.desop)
	c:RegisterEffect(e4)
	
end
function c11579812.lcheck(g)
	return g:IsExists(Card.IsSummonLocation,1,nil,LOCATION_EXTRA)
end
function c11579812.filter(c)
	return c:IsFaceup()
end
function c11579812.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c11579812.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11579812.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,11579813)<1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11579812.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local atk=math.ceil(g:GetFirst():GetAttack()/2)
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,atk)
end
function c11579812.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local aaa=math.ceil(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))/2)
		if tc:GetAttack()<aaa or Duel.GetFlagEffect(tp,11580812)>1 then
		Duel.Remove(tc,POS_FACEDOWN,REASON_RULE,1-tp)
		else 
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.RegisterFlagEffect(tp,11579813,RESET_PHASE+PHASE_END,0,1) end
		end
	end
	if Duel.GetFlagEffect(tp,11579812)==0 then Duel.RegisterFlagEffect(tp,11579812,0,0,1) end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(c11579812.damval1)
	Duel.RegisterEffect(e2,tp)
end
function c11579812.drfilter(c)
	return c:IsOnField() and c:IsFaceup() and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c:GetBaseAttack()~=0
end
function c11579812.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c11579812.drfilter,1,nil) end
	local tg=eg:Filter(c11579812.drfilter,nil)
	local tc=tg:GetFirst()
	local dam=0
	while tc do
		dam=dam+tc:GetBaseAttack()
		tc=tg:GetNext()
	end
		e:SetLabel(dam)
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c11579812.repval(e,c)
	return c:IsOnField() and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c:IsFaceup() and c:GetBaseAttack()~=0
end
function c11579812.repop(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetLabel()
	Duel.Damage(tp,dam,REASON_EFFECT)
end
function c11579812.damval1(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,11580812,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetFlagEffect(tp,11579812)~=0 then
		Duel.ResetFlagEffect(tp,11579812)
		return val*2
	end
	return val
end

   

function c11579812.imcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11579812.atcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp)
end
function c11579812.val(e,c)
	return Duel.GetLP(1-c:GetControler())-Duel.GetLP(c:GetControler())
end
function c11579812.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
