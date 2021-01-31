--杰作拼图9999-「命运之轮」
local m=64800016
local cm=_G["c"..m]
function cm.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_NEGATE+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.GetMatchingGroupCount(cm.bkfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,rc)~=0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.CheckLPCost(tp,3000) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(lp/1000)
	local t={}
	for i=1,m-2 do
		t[i]=(i+2)*1000
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 local da=e:GetLabel()
	 if chk==0 then return re:GetHandler():IsAbleToRemove() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,da,da,10,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end  
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
   if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	   if  Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)~=0	 then 
		 local c=e:GetHandler()
	   if not c:IsRelateToEffect(e) then return end
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not  Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,da,da,10,RACE_FIEND,ATTRIBUTE_DARK) then return end
		c:AddMonsterAttribute(TYPE_TRAP)
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
		local da=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(da)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(da)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
			local opt=Duel.AnnounceType(tp)
			Duel.ConfirmDecktop(1-tp,da/1000)
			local g=Duel.GetDecktopGroup(1-tp,da/1000)
			local tc1=g:Filter(Card.IsType,nil,TYPE_MONSTER):GetCount()
			local tc2=g:Filter(Card.IsType,nil,TYPE_SPELL):GetCount()
			local tc3=g:Filter(Card.IsType,nil,TYPE_TRAP):GetCount()
			if (opt==0 and tc1>3) or (opt==1 and tc2>3) or (opt==2 and tc3>3) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(0,1)
				if opt==0 then
					e1:SetDescription(aux.Stringid(m,2))
					e1:SetValue(cm.aclimit1)
				elseif opt==1 then
					e1:SetDescription(aux.Stringid(m,3))
					e1:SetValue(cm.aclimit2)
				else
					e1:SetDescription(aux.Stringid(m,4))
					e1:SetValue(cm.aclimit3)
				end
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			else
			Duel.Damage(tp,c:GetAttack(),REASON_EFFECT)
			end
		end
	   end
	end
end
function cm.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function cm.aclimit3(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end