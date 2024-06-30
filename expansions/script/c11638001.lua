local m=11638001
local cm=_G["c"..m]
cm.name="忍者杀手"
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(cm.atkfilter)
	c:RegisterEffect(e3)
	--ninja all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e4:SetValue(0x2b)
	c:RegisterEffect(e4)
	--activate from hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(cm.ninjatg)
	e5:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(cm.sumsayop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge3:SetOperation(cm.atksayop)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_TO_GRAVE)
		ge4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge4:SetOperation(cm.leavesayop)
		Duel.RegisterEffect(ge4,0)
	end
end
function cm.ninjafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2b)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.ninjafilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.ninjafilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.atkfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x2b)
end
function cm.ninjatg(e,c)
	return aux.IsCodeListed(c,11638001)
end
function cm.exninjafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2b) and not c:IsCode(11638001) and not c:IsCode(11638004) and not c:IsCode(11638003)
end
function cm.ninjaSfilter(c)
	return c:IsFaceup() and c:IsCode(11638001)
end
function cm.Yexninjafilter(c)
	return Duel.IsExistingMatchingCard(cm.ninjaSfilter,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function cm.Nexninjafilter(c)
	return not Duel.IsExistingMatchingCard(cm.ninjaSfilter,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function cm.sumsayop(e,tp,eg,ep,ev,re,r,rp)
	local b1=eg:IsExists(Card.IsCode,1,nil,11638001)
	local b2=eg:IsExists(Card.IsCode,1,nil,11638003)
	local b3=eg:IsExists(Card.IsCode,1,nil,11638004)
	--
	local b4=eg:IsExists(cm.exninjafilter,1,nil)
	--
	if b1 then
		if Duel.GetFlagEffect(0,11638001)==0 then
			Debug.Message("Domo，初次见面，忍者杀手desu")
		else
			Debug.Message("Domo，忍者杀手desu")
		end
		Duel.RegisterFlagEffect(0,11638001,0,0,1)
	end
	if b2 then
		Debug.Message("开始骇入。")
	end
	if b3 then
		if Duel.GetFlagEffect(0,11638004)==0 then
			Debug.Message("Domo，初次见面，矢本·小姬desu")
		else
			Debug.Message("Domo，矢本·小姬desu")
		end
		Duel.RegisterFlagEffect(0,11638004,0,0,1)
	end
	if b4 then
		local tg=eg:Filter(cm.exninjafilter,nil)
		local noninjia=tg:Filter(cm.Nexninjafilter,nil)
		local noc=noninjia:GetFirst()
		while noc do
			if noc:IsAttribute(ATTRIBUTE_LIGHT) then Debug.Message("Domo，初次见面，代达罗斯desu")
			elseif noc:IsAttribute(ATTRIBUTE_DARK) then Debug.Message("Domo，初次见面，暗黑忍者desu")
			elseif noc:IsAttribute(ATTRIBUTE_EARTH) then Debug.Message("Domo，初次见面，地震desu")
			elseif noc:IsAttribute(ATTRIBUTE_WATER) then Debug.Message("Domo，初次见面，水刑desu")
			elseif noc:IsAttribute(ATTRIBUTE_FIRE) then Debug.Message("Domo，初次见面，纵火desu")
			elseif noc:IsAttribute(ATTRIBUTE_WIND) then Debug.Message("Domo，初次见面，地狱风筝desu")
			end
			noc=noninjia:GetNext()
		end
		local yesninjia=tg:Filter(cm.Yexninjafilter,nil)
		local yesc=yesninjia:GetFirst()
		while yesc do
			if yesc:IsAttribute(ATTRIBUTE_LIGHT) then Debug.Message("Domo，忍者杀手＝san，代达罗斯desu")
			elseif yesc:IsAttribute(ATTRIBUTE_DARK) then Debug.Message("Domo，忍者杀手＝san，暗黑忍者desu")
			elseif yesc:IsAttribute(ATTRIBUTE_EARTH) then Debug.Message("Domo，忍者杀手＝san，地震desu")
			elseif yesc:IsAttribute(ATTRIBUTE_WATER) then Debug.Message("Domo，忍者杀手＝san，水刑desu")
			elseif yesc:IsAttribute(ATTRIBUTE_FIRE) then Debug.Message("Domo，忍者杀手＝san，纵火desu")
			elseif yesc:IsAttribute(ATTRIBUTE_WIND) then Debug.Message("Domo，忍者杀手＝san，地狱风筝desu")
			end
			yesc=yesninjia:GetNext()
		end
		local sg=tg:Filter(Card.IsAttribute,nil,ATTRIBUTE_DIVINE)
		local sc=sg:GetFirst()
		while sc do
			Debug.Message("盛·万松是无敌！无敌！")
			sc=sg:GetNext()
		end
	end
end
function cm.atksayop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	local ap=ac:GetControler()
	local bp=1-ap
	local b1=(ac:GetAttack()>=Duel.GetLP(bp) and not bc)
	local b2=(bc and bc:IsAttackPos() and ac:GetAttack()-bc:GetAttack()>=Duel.GetLP(bp))
	if ac:IsCode(11638001) and not (b1 or b2) then
		Debug.Message("咿呀！")
	end
	if ac:IsCode(11638001) and (b1 or b2) then
		Debug.Message("我想要的，是汝的命！")
		Debug.Message("Washoii！忍者杀无赦！")
		Debug.Message("咿咿咿呀呀呀！")
	end
	if ac:IsCode(11638004) then
		Debug.Message("咿呀！")
	end
	if ac:IsCode(11638003) then
		Debug.Message("Take·This！")
	end
	if ac:IsSetCard(0x2b) and not ac:IsCode(11638001) and not ac:IsCode(11638004) and not ac:IsCode(11638003) then
		Debug.Message("咿呀！")
	end
end
function cm.leavesayfilter(c,code)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsCode(code)
end
function cm.lexninjafilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousSetCard(0x2b) and not c:IsCode(11638001) and not c:IsCode(11638004) and not c:IsCode(11638003)
end
function cm.leavesayop(e,tp,eg,ep,ev,re,r,rp)
	local b1=eg:IsExists(cm.leavesayfilter,1,nil,11638001)
	local b2=eg:IsExists(cm.leavesayfilter,1,nil,11638003)
	local b3=eg:IsExists(cm.leavesayfilter,1,nil,11638004)
	if b1 then
		Debug.Message("咕哇！")
	end
	if b2 then
		Debug.Message("AIeeee！")
	end
	if b3 then
		Debug.Message("咕哇！")
	end
	local b4=eg:IsExists(cm.lexninjafilter,1,nil)
	if b4 then
		Debug.Message("撒由那拉！")
	end
end