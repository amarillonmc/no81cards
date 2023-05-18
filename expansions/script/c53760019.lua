local m=53760019
local cm=_G["c"..m]
cm.name="奇美拉的恶梦"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddCodeList(c,53760000)
	aux.AddSetNameMonsterList(c,0x9538)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.tkcon)
	e3:SetTarget(cm.tktg)
	e3:SetOperation(cm.tkop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function cm.rfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function cm.fselect(g,tp)
	if Duel.GetMZoneCount(tp,g)<=0 then return false end
	local att=0
	for tc in aux.Next(g) do att=att|tc:GetAttribute() end
	return Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_NORMAL_TRAP_MONSTER,3000,2500,8,RACE_BEAST,att)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return rg:CheckSubGroup(aux.mzctcheck,2,#rg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,aux.mzctcheck,true,2,#rg,tp)
	local att=0
	for tc in aux.Next(g) do att=att|tc:GetAttribute() end
	Duel.Release(g,REASON_COST)
	e:SetLabel(att)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local att=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_NORMAL_TRAP_MONSTER,3000,2500,8,RACE_BEAST,att) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP,att,0,0,0,0)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	e1:SetValue(cm.val1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_EFFECT))
	e3:SetValue(cm.val2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(att)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e5,true)
	Duel.SpecialSummonComplete()
end
function cm.filter1(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function cm.val1(e,c)
	return Duel.GetMatchingGroupCount(cm.filter1,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)*500
end
function cm.filter2(c)
	return c:IsType(TYPE_NORMAL) and c:IsFaceup()
end
function cm.val2(e,c)
	return -Duel.GetMatchingGroupCount(cm.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*500
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetAttribute())
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	e:SetLabel(ct)
	return ct>0
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a,ct=1,0
	while a<=e:GetLabel() do
		if a&e:GetLabel()==a then ct=ct+1 end
		a=a<<1
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,PLAYER_ALL,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local a,p=e:GetLabel(),1-tp
	while p>=0 do
		if a<=0 then break end
		if not SNNM.DressamLocCheck(p,p,0xff) then break end
		local ct,att=1,0
		while ct<=a do
			if ct&a==ct and Duel.IsPlayerCanSpecialSummonMonster(p,53760000,0x9538,TYPES_TOKEN_MONSTER,0,3000,1,RACE_FIEND,a,POS_FACEUP,p) then att=att|ct end
			ct=ct<<1
		end
		if att<=0 then break end
		local attr=Duel.AnnounceAttribute(p,1,att)
		local token=Duel.CreateToken(p,53760000)
		if not SNNM.DressamSPStep(token,p,p,POS_FACEUP,0xff) then break end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(attr)
		token:RegisterEffect(e1,true)
		a=a&(~attr)
		p=math.abs(p-1)
	end
	Duel.SpecialSummonComplete()
end
function cm.spcheck(tp)
	local a,attr=1,0
	while a<ATTRIBUTE_ALL do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,53760000,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,a,POS_FACEUP_DEFENSE,tp) then attr=attr|a end
		a=a<<1
	end
	return attr
end
function cm.spcheck(c,e,tp)
	local a,ct=1,0
	while a<ATTRIBUTE_ALL do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,53760000,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_FIEND,a,POS_FACEUP_DEFENSE,tp) then attr=attr|a end
		a=a<<1
	end
	return attr
end
