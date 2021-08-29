--方舟骑士·临爆点 煌
local m=82567814
local cm=_G["c"..m]
function c82567814.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	 aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetDescription(aux.Stringid(82567814,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c82567814.sprcon)
	e0:SetOperation(c82567814.sprop)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c82567814.atkcon)
	e1:SetValue(c82567814.atkval)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c82567814.condition)
	e2:SetCost(c82567814.cost)
	e2:SetOperation(c82567814.operation)
	c:RegisterEffect(e2)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567814,2))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c82567814.nacost)
	e4:SetTarget(c82567814.natarget)
	e4:SetOperation(c82567814.naoperation)
	c:RegisterEffect(e4)
end
function c82567814.sprfilter(c)
	return c:IsFaceup() and (c:IsLevel(4) or c:IsRace(RACE_BEASTWARRIOR) or (c:IsRace(RACE_BEASTWARRIOR) and c:IsLevel(4)) )
end
function c82567814.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c82567814.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>2
end
function c82567814.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c82567814.sprfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>-1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567853,4))
		g=mg:Select(tp,2,99,nil)
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
function c82567814.XYZfilter(c)
	return (c:IsSetCard(0x825) and c:IsLevel(4)) or c:IsRace(RACE_BEASTWARRIOR) or (c:IsSetCard(0x825) and c:IsLevel(4) and c:IsRace(RACE_BEASTWARRIOR) )
end
function c82567814.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetMaterialCount()>=3
end
function c82567814.atkval(e,c)
	local c=e:GetHandler()
	return c:GetOverlayCount()*300
end
function c82567814.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(EFFECT_ATTACK_ALL) and Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)>=2 and Duel.GetTurnPlayer()==tp
end
function c82567814.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82567814.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(500)
	c:RegisterEffect(e2)
		local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(c82567814.damcon)
	e5:SetOperation(c82567814.damop)
	c:RegisterEffect(e5)
	end
end
function c82567814.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c82567814.damop(e,tp,eg,ep,ev,re,r,rp)
		 Duel.Damage(1-tp,800,REASON_EFFECT)
		 Duel.Damage(tp,800,REASON_EFFECT)
end
function c82567814.damcondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetAttack()>=3000 and Duel.GetTurnPlayer()==tp
end
function c82567814.damoperation(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	local val=c:GetAttack()/5 
	Duel.Damage(tp,val,REASON_EFFECT)
end
function c82567814.filter(c,e,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and (not e or c:IsRelateToEffect(e))
end
function c82567814.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82567814.natarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c82567814.filter,1,nil,nil,tp) and eg:GetCount()<=1  end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,eg:GetCount(),0,0)
end
function c82567814.naoperation(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	local g=eg:Filter(c82567814.filter,nil,e,tp)
	local vg=g:GetFirst()
	 local e3=Effect.CreateEffect(c)
				  e3:SetType(EFFECT_TYPE_SINGLE)
				  e3:SetCode(EFFECT_DISABLE)
				  e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				  vg:RegisterEffect(e3)
				  local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		vg:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e5:SetValue(RESET_TURN_SET)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		vg:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e6:SetValue(RESET_TURN_SET)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		vg:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e7:SetValue(RESET_TURN_SET)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		vg:RegisterEffect(e7)
		 local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e8:SetValue(RESET_TURN_SET)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		vg:RegisterEffect(e8)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e9:SetRange(LOCATION_MZONE)
		e9:SetCode(EFFECT_UNRELEASABLE_SUM)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD)
		e9:SetValue(1)
		vg:RegisterEffect(e9)
		local e10=e9:Clone()
		e10:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e10:SetReset(RESET_EVENT+RESETS_STANDARD)
		vg:RegisterEffect(e10)
end
