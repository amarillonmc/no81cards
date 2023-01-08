--世界树乐队·铜钹仓鼠
local m=40010598
local cm=_G["c"..m]
cm.named_with_WorldTreemarchingband=1
function cm.WorldTreemarchingband(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_WorldTreemarchingband
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
   -- e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_MOVE)
		ge2:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge2,0)
	end
	
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_END and eg:Filter(cm.chfliter,nil):GetCount()>0 then
		eg:Filter(cm.chfliter,nil):ForEach(function(c) Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_STANDBY,0,1) end)
		--local ct=Duel.GetFlagEffect(rp,m)

		--Debug.Message("check:")
		--Debug.Message(ct)

	end
end
function cm.chfliter(c) 
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_MZONE)
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,300,300,1,RACE_PLANT,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.setfilter(c)
	return cm.WorldTreemarchingband(c) and c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS and c:IsSSetable() and not c:IsCode(m)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,300,300,1,RACE_PLANT,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then 
			Duel.SSet(tp,tc)
		end
	end
end
function cm.thfilter(c)
	return  c:IsAbleToRemove()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local seq=c:GetSequence()
	--local g=Duel.GetMatchingGroup(cm.thfilter,tp,0,LOCATION_GRAVE,nil)
	local ct=Duel.GetFlagEffect(tp,m)
	local g=Duel.GetDecktopGroup(1-tp,ct)
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then
		Duel.MoveSequence(c,seq+1)

		--Debug.Message("OP:")
		--Debug.Message(ct)

		if ct>0 and g:GetCount()>0 then
			--cm.athop(ct,tp,g)
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	else
		if Duel.IsPlayerAffectedByEffect(tp,40010592) and seq<3 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+2) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.MoveSequence(c,seq+2)
			if ct>0 and g:GetCount()>0 then
				Duel.DisableShuffleCheck()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		else
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
function cm.athop(ct,tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,ct,nil)
	if sg:GetCount()>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
