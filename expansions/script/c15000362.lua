local m=15000362
local cm=_G["c"..m]
cm.name="泪水之城"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000351)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		local x=0
		if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,3,RACE_INSECT,ATTRIBUTE_FIRE) then x=1 end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,4,RACE_INSECT,ATTRIBUTE_FIRE) then x=1 end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,5,RACE_INSECT,ATTRIBUTE_FIRE) then x=1 end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,6,RACE_INSECT,ATTRIBUTE_FIRE) then x=1 end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,7,RACE_INSECT,ATTRIBUTE_FIRE) then x=1 end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,8,RACE_INSECT,ATTRIBUTE_FIRE) then x=1 end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,9,RACE_INSECT,ATTRIBUTE_FIRE) then x=1 end
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,ft,tp) and x==1
	end
	local list={}
	if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,3,RACE_INSECT,ATTRIBUTE_FIRE) then table.insert(list,3) end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,4,RACE_INSECT,ATTRIBUTE_FIRE) then table.insert(list,4) end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,5,RACE_INSECT,ATTRIBUTE_FIRE) then table.insert(list,5) end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,6,RACE_INSECT,ATTRIBUTE_FIRE) then table.insert(list,6) end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,7,RACE_INSECT,ATTRIBUTE_FIRE) then table.insert(list,7) end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,8,RACE_INSECT,ATTRIBUTE_FIRE) then table.insert(list,8) end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,15000363,nil,0x4011,0,1000,9,RACE_INSECT,ATTRIBUTE_FIRE) then table.insert(list,9) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LVRANK)
	local x,x1=Duel.AnnounceNumber(tp,table.unpack(list))
	e:SetLabel(x)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local lv=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local x=0
	if not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,ft,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,ft,tp):GetFirst()
	if not tc:IsCode(15000351) then x=1 end
	if Duel.SendtoGrave(tc,REASON_EFFECT) then
		local token=Duel.CreateToken(tp,15000363)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		token:RegisterEffect(e1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	if x~=0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,0)
		e2:SetValue(cm.aclimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_INSECT)
end