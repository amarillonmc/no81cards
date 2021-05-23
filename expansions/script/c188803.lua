--永恒不灭之王-亚瑟·潘德拉贡
local m=188803
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddMaterialCodeList(c,188802)
   --synchro summon
	aux.AddSynchroProcedure(c,cm.tfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--spsummon
	local e02=Effect.CreateEffect(c)
	e02:SetDescription(aux.Stringid(m,1))
	e02:SetType(EFFECT_TYPE_FIELD)
	e02:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e02:SetCode(EFFECT_SPSUMMON_PROC)
	e02:SetRange(LOCATION_EXTRA)
	e02:SetCondition(cm.hspcon)
	e02:SetOperation(cm.hspop)
	c:RegisterEffect(e02)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--attack twice
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetCondition(cm.excon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m)
	e5:SetTarget(cm.eqtg)
	e5:SetOperation(cm.eqop)
	c:RegisterEffect(e5)
end
function cm.hspfilter(c,tp,sc)
	return c:IsCode(m-1) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and (c:IsAttackAbove(5000) or c:GetEquipCount()>2)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),cm.hspfilter,1,nil,c:GetControler(),c)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function cm.val(e,c)
	return c:GetEquipCount()*500
end
function cm.tfilter(c)
	return c:IsCode(188802) 
end
function cm.excon(e,tp)
	return e:GetHandler():GetEquipCount()>0
end
function cm.eqfilter(c,tp,ec)
	return c:IsSetCard(0x207a) and not c:IsForbidden() and c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function cm.eqfilter(c,tp,ec)
	return not c:IsForbidden() and c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function cm.atfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK,0,1,nil,tp,e:GetHandler()) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.eqfilter1),tp,LOCATION_DECK,0,1,nil,tp,e:GetHandler()) end
	if Duel.GetMatchingGroupCount(cm.atfilter,tp,LOCATION_MZONE,0,nil)==#g then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,2,0,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=0
	if not (Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK,0,1,nil,tp,e:GetHandler()) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.eqfilter1),tp,LOCATION_DECK,0,1,nil,tp,e:GetHandler())) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)  
	local eg1=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eg2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.eqfilter1),tp,LOCATION_DECK,0,1,1,nil,tp,e:GetHandler())
	eg1:Merge(eg2)
	local tc=eg1:GetFirst()
	while tc do
		if Duel.Equip(tp,tc,c,true,true) then
			num=num+1
		end
		tc=eg1:GetNext()
	end
	Duel.EquipComplete()
	if num==2 and e:GetLabel()==1 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(cm.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		e2:SetOwnerPlayer(tp)
		c:RegisterEffect(e2)
	end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end