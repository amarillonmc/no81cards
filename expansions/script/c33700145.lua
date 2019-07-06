--飞来恶兆
function c33700145.initial_effect(c)
	c:SetUniqueOnField(1,0,33700145) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c33700145.con)
	e1:SetTarget(c33700145.target)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c33700145.con2)
	c:RegisterEffect(e0)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c33700145.aclimit)
	c:RegisterEffect(e2)
  --negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(33700145,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c33700145.discost)
	e3:SetTarget(c33700145.distg)
	e3:SetOperation(c33700145.disop)
	c:RegisterEffect(e3)
   local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(33700145,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)  
	e4:SetCondition(c33700145.discon)
	e4:SetCost(c33700145.discost2)
	e4:SetTarget(c33700145.distg2)
	e4:SetOperation(c33700145.disop2)
	c:RegisterEffect(e4)
end
function c33700145.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c33700145.con(e,tp,eg,ep,ev,re,r,rp)
	return   Duel.GetCurrentChain()>0 
end
function c33700145.con2(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetCurrentChain()==0 
end
function c33700145.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end  
	  local b1= c33700145.discost(e,tp,eg,ep,ev,re,r,rp,0) and c33700145.distg(e,tp,eg,ep,ev,re,r,rp,0)
	  local b2=c33700145.discon(e,tp,eg,ep,ev,re,r,rp) and c33700145.discost2(e,tp,eg,ep,ev,re,r,rp,0)
		and c33700145.distg2(e,tp,eg,ep,ev,re,r,rp,0)
	if  (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(33700145,0),aux.Stringid(33700145,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(33700145,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(33700145,1))+1
		end
		if op==0 then
			c33700145.discost(e,tp,eg,ep,ev,re,r,rp,1)
			c33700145.distg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetCategory(CATEGORY_DESTROY)
			e:SetProperty(0)
			e:SetOperation(c33700145.disop)
		else
			 c33700145.discost2(e,tp,eg,ep,ev,re,r,rp,1)
			c33700145.distg2(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
			e:SetOperation(c33700145.disop2)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c33700145.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_TOKEN) end
	 Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_TOKEN)
   Duel.Release(g,REASON_COST)
  e:GetHandler():RegisterFlagEffect(33700145,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c33700145.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(33700145)==0 and re:GetHandler():IsDestructable()  end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c33700145.disop(e,tp,eg,ep,ev,re,r,rp)
	 if not e:GetHandler():IsRelateToEffect(e) then return end
	if re:GetHandler():IsRelateToEffect(re) then Duel.Destroy(eg,REASON_EFFECT)
 end
end
function c33700145.discon(e,tp,eg,ep,ev,re,r,rp)
	return   Duel.IsChainNegatable(ev)
end
function c33700145.discost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,2,nil,TYPE_TOKEN) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,2,2,nil,TYPE_TOKEN)
   Duel.Release(g,REASON_COST)
   e:GetHandler():RegisterFlagEffect(33700145,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c33700145.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(33700145)==0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c33700145.disop2(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end