--虚毒SPINE
local m=33700701
local cm=_G["c"..m]
if not RSVeVal then
   RSVeVal=RSVeVal or {}
   rsve=RSVeVal
function rsve.addcounter(tp,ct,chk,rc)
   local g=Duel.GetMatchingGroup(rsve.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,rc)
   if chk then return g:GetCount()>0 end
   if g:GetCount()<=0 then return end
   local ct2=ct
   local eg=Group.CreateGroup()
   repeat
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	  local tg=g:Select(tp,1,1,nil)
	  Duel.HintSelection(tg)
	  eg:Merge(tg)
	  local tc=tg:GetFirst()
	  local tbl={}
	  for i=1,ct2 do
		  tbl[i]=i
	  end
	  local ct3=Duel.AnnounceNumber(tp,table.unpack(tbl))
	  tc:AddCounter(0x144b,ct3)
	  ct2=ct2-ct3
   until ct2==0 
   Duel.RaiseEvent(eg,EVENT_CUSTOM+33700711,e,REASON_EFFECT,tp,tp,ct)
end
function rsve.ctfilter(c)
   return c:IsFaceup() and c:IsCanAddCounter(0x144b,1)
end
function rsve.BattleFunction(c,atk)
	--no battle damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_DAMAGE_STEP_END)
	e7:SetCondition(rsve.rmcon)
	e7:SetOperation(rsve.rmop)
	e7:SetLabel(atk)
	c:RegisterEffect(e7)	
end
function rsve.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsOnField() and bc:IsRelateToBattle() and (bc:IsAttackAbove(0) or bc:IsDefenseAbove(0))
end
function rsve.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:IsOnField() and bc:IsRelateToBattle() and (bc:IsAttackAbove(0) or bc:IsDefenseAbove(0)) then
		local val=e:GetLabel()
		local patk,pdef=bc:GetAttack(),bc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)   
		bc:RegisterEffect(e2)   
		if (bc:IsAttack(0) and patk>0) or (bc:IsDefense(0) and pdef>0) then Duel.Remove(bc,POS_FACEUP,REASON_EFFECT) end
	end
end
function rsve.DirectAttackFunction(c,ct)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(rsve.ctcon)
	e1:SetOperation(rsve.ctop)
	c:RegisterEffect(e1)
end
function rsve.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil
end
function rsve.ctop(e,tp,eg,ep,ev,re,r,rp)
	rsve.addcounter(tp,4)
end
function rsve.NormalSummonFunction(c,ct)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetLabel(ct)
	e1:SetCondition(rsve.otcon)
	e1:SetOperation(rsve.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
end
function rsve.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:IsLevelAbove(5) and minc<=1 and Duel.IsCanRemoveCounter(tp,1,1,0x144b,e:GetLabel(),REASON_RULE)
end
function rsve.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,1,0x144b,e:GetLabel(),REASON_RULE)
end
function rsve.ToGraveFunction(c,ct,con,cost)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	if con then e1:SetCondition(con) end
	if cost then e1:SetCost(cost) end
	e1:SetOperation(rsve.ctop2)
	e1:SetLabel(ct)
	c:RegisterEffect(e1)
end
function rsve.ctop2(e,tp,eg,ep,ev,re,r,rp)
	rsve.addcounter(tp,e:GetLabel())
end
function rsve.AttackUpFunction(c,ct)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(rsve.atkval)
	e2:SetLabel(ct)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)   
	c:RegisterEffect(e3)
end
function rsve.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x144b)*e:GetLabel()
end
function rsve.FusionMaterialFunction(c,ct)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x144b),ct,ct,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(rsve.splimit)
	c:RegisterEffect(e1)
end
function rsve.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x144b)
end

-------------------------------------------
end

if cm then
function cm.initial_effect(c)
	rsve.BattleFunction(c,800)
	rsve.DirectAttackFunction(c,4)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)  
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	rsve.addcounter(tp,4)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsCanRemoveCounter(c:GetControler(),1,1,0x144b,4,REASON_COST)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,1,0x144b,4,REASON_RULE)
end

end