--重炼装勇士·熔融合贤者
local m=14090043
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	local e_f=Effect.CreateEffect(c)
	e_f:SetType(EFFECT_TYPE_SINGLE)
	e_f:SetCode(EFFECT_FUSION_MATERIAL)
	e_f:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_f:SetCondition(cm.con)
	e_f:SetOperation(cm.op)
	c:RegisterEffect(e_f)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.eqcon)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.immcon)
	e3:SetOperation(cm.immop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(cm.atkval)
	c:RegisterEffect(e4)
end
function cm.exfilter(c,fc)
	if c==fc then return false end
	return cm.allfilter(c,fc)
end
function cm.eblfilter(c)
	return c:IsFusionSetCard(0xe1) and c:IsFusionType(TYPE_FUSION)
end
function cm.allfilter(c,fc)
	return c:IsCanBeFusionMaterial(fc) and c:IsFusionType(TYPE_MONSTER)
		and (c:IsFusionSetCard(0xe1) or c:IsFusionType(TYPE_FUSION))
end
function cm.CheckRecursive(c,mg,sg,exg,tp,fc,chkf)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()==2 then
		res=(chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(chkf,tp,sg,fc)>0)
		local checknum1=0
		local checknum2=0
		local sc=sg:GetFirst()
		while sc do
			if cm.eblfilter(sc) then checknum2=1 end
			if exg:IsContains(sc) then checknum1=1 end
			sc=sg:GetNext()
		end
		if checknum1==1 and checknum2==0 then res=false end
		if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc) then res=false end
	else
		res=mg:IsExists(cm.CheckRecursive,1,sg,mg,sg,exg,tp,fc,chkf)
	end
	sg:RemoveCard(c)
	return res
end
function cm.con(e,g,gc,chkfnf)
	if g==nil then return true end
	local sg=Group.CreateGroup()
	local chkf=(chkfnf & 0xff)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local mg=g:Filter(cm.allfilter,nil,c)
	local exg=Duel.GetMatchingGroup(cm.exfilter,tp,LOCATION_EXTRA,0,mg,c)
	mg:Merge(exg)
	if gc then return cm.allfilter(gc,c)
		and cm.CheckRecursive(gc,mg,sg,exg,tp,c,chkf) end
	return mg:IsExists(cm.CheckRecursive,1,sg,mg,sg,exg,tp,c,chkf)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local c=e:GetHandler()
	local chkf=(chkfnf & 0xff)
	local mg=eg:Filter(cm.allfilter,nil,c)
	local exg=Duel.GetMatchingGroup(cm.exfilter,tp,LOCATION_EXTRA,0,mg,c)
	local exg1=exg:Filter(cm.eblfilter,mg)
	mg:Merge(exg)
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g=mg:FilterSelect(tp,cm.CheckRecursive,1,1,sg,mg,sg,exg,tp,c,chkf)
		if not g:IsExists(cm.eblfilter,1,nil) then
			mg:Sub(exg)
			mg:Merge(exg1)
		end
		sg:Merge(g)
	until sg:GetCount()==2
	Duel.SetFusionMaterial(sg)
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.eqfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
		and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.eqfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_EFFECT)) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.Equip(tp,tc,c)==0 then return end
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.BreakEffect()
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	else Duel.SendtoGrave(tc,REASON_RULE) end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsCode(39564736) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(Card.IsType,nil,TYPE_EFFECT)
	local tc=mg:GetFirst()
	while tc do
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		tc=mg:GetNext()
	end
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER and c:GetBaseAttack()>=0
end
function cm.atkval(e,c)
	local lg=c:GetEquipGroup():Filter(cm.atkfilter,nil)
	return lg:GetSum(Card.GetBaseAttack)
end