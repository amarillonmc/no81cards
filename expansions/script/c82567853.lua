--方舟骑士·教条庇护者 闪灵
function c82567853.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,c82567853.ovfilter,aux.Stringid(82567853,4),nil,c82567853.xyzop)
	c:EnableReviveLimit()
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetDescription(aux.Stringid(82567853,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_COUNTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END,TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1)
	e3:SetCost(c82567853.atkcost)
	e3:SetTarget(c82567853.atktg)
	e3:SetOperation(c82567853.atkop)
	c:RegisterEffect(e3)
	--change 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567853,2))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e5:SetCost(c82567853.ccost)
	e5:SetOperation(c82567853.coperation)
	c:RegisterEffect(e5)
	if not c82567853.global_check then
		c82567853.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c82567853.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c82567853.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then return
		Duel.RegisterFlagEffect(ep,82567853,RESET_PHASE+PHASE_END,0,1)
	end
end
function c82567853.ovfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x825) and c:GetRank()==4
end
function c82567853.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,82567853)~=0  end
	
end
function c82567853.sprfilter(c)
	return c:IsFaceup() and (c:IsLevel(4) or c:IsAttribute(ATTRIBUTE_LIGHT) or (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(4)) )
end
function c82567853.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c82567853.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>2
end
function c82567853.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c82567853.sprfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>-1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567853,4))
		g=mg:Select(tp,3,3,nil)
	end
				   local sg=Group.CreateGroup()
						local tc=g:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=g:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
	e:GetHandler():SetMaterial(g)
	 Duel.Overlay(e:GetHandler(),g)
end
function c82567853.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function c82567853.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAttackPos() and e:GetHandler():IsCanChangePosition() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c82567853.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c82567853.filter(c)
	return c:IsFaceup() 
end
function c82567853.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82567853.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82567853.filter,tp,LOCATION_MZONE,0,nil)
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567853.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
end
function c82567853.atkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82567853.filter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		tc=sg:GetNext()
	 end
	Duel.BreakEffect()
	if c:IsRelateToEffect(e)  
  then  c:AddCounter(0x5825,1)
   end
end
function c82567853.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()==0
	and Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil) < Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
						  and e:GetHandler():IsPosition(POS_FACEUP_DEFENSE) end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
end
function c82567853.coperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if not c:IsPosition(POS_FACEUP_ATTACK) then return false end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SWAP_BASE_AD)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	
end
