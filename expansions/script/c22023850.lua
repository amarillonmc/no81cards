--人理之基 瓦尔基里
function c22023850.initial_effect(c)
	aux.AddCodeList(c,22023851)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCost(c22023850.cost1)
	e0:SetDescription(aux.Stringid(22023850,2))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023850,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,22023850)
	e2:SetCondition(c22023850.spcon)
	e2:SetTarget(c22023850.sptg)
	e2:SetOperation(c22023850.spop)
	c:RegisterEffect(e2)
	--change effect tp 01
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023850,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,22023851)
	e3:SetCondition(c22023850.chcon01)
	e3:SetCost(c22023850.cost)
	e3:SetTarget(c22023850.chtg01)
	e3:SetOperation(c22023850.chop01)
	c:RegisterEffect(e3)
	--change effect tp 02
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023850,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,22023852)
	e4:SetCondition(c22023850.chcon02)
	e4:SetCost(c22023850.cost)
	e4:SetTarget(c22023850.chtg02)
	e4:SetOperation(c22023850.chop02)
	c:RegisterEffect(e4)
	--change effect tp 03
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22023850,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,22023853)
	e5:SetCondition(c22023850.chcon03)
	e5:SetCost(c22023850.cost)
	e5:SetTarget(c22023850.chtg03)
	e5:SetOperation(c22023850.chop03)
	c:RegisterEffect(e5)
	--change effect tp 11
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22023850,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,22023851)
	e6:SetCondition(c22023850.chcon11)
	e6:SetCost(c22023850.cost)
	e6:SetTarget(c22023850.chtg11)
	e6:SetOperation(c22023850.chop11)
	c:RegisterEffect(e6)
	--change effect tp 12
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22023850,1))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1,22023852)
	e7:SetCondition(c22023850.chcon12)
	e7:SetCost(c22023850.cost)
	e7:SetTarget(c22023850.chtg12)
	e7:SetOperation(c22023850.chop12)
	c:RegisterEffect(e7)
	--change effect tp 11
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(22023850,1))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_CHAINING)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1,22023853)
	e8:SetCondition(c22023850.chcon13)
	e8:SetCost(c22023850.cost)
	e8:SetTarget(c22023850.chtg13)
	e8:SetOperation(c22023850.chop13)
	c:RegisterEffect(e8)
end
function c22023850.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22023850.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,22023851)==0 end
	Duel.RegisterFlagEffect(tp,22023851,RESET_CHAIN,0,1)
end
function c22023850.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22023850.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsExistingMatchingCard(c22023850.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22023850.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22023850.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22023850.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c22023850.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22023850.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22023850.chcon01(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep==tp and Duel.GetFlagEffect(tp,22023850)==0
end
function c22023850.chtg01(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.RegisterFlagEffect(tp,22023850,RESET_PHASE+PHASE_END,0,1)
end
function c22023850.chop01(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22023850.repop01)
end
function c22023850.repop01(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,22023851)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c22023850.chcon02(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep==tp and Duel.GetFlagEffect(tp,22023850)>0
end
function c22023850.chtg02(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.RegisterFlagEffect(tp,22023850,RESET_PHASE+PHASE_END,0,1)
end
function c22023850.chop02(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22023850.repop02)
end
function c22023850.repop02(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,22023852)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c22023850.chcon03(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep==tp and Duel.GetFlagEffect(tp,22023850)>1
end
function c22023850.chtg03(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c22023850.chop03(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22023850.repop03)
end
function c22023850.repop03(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,22023853)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end

function c22023850.chcon11(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep~=tp and Duel.GetFlagEffect(tp,22023850)==0 and Duel.IsPlayerAffectedByEffect(tp,22023860)
end
function c22023850.chtg11(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.RegisterFlagEffect(tp,22023850,RESET_PHASE+PHASE_END,0,1)
end
function c22023850.chop11(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22023850.repop11)
end
function c22023850.repop11(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,22023851)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c22023850.chcon12(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep~=tp and Duel.GetFlagEffect(tp,22023850)>0 and Duel.IsPlayerAffectedByEffect(tp,22023860)
end
function c22023850.chtg12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.RegisterFlagEffect(tp,22023850,RESET_PHASE+PHASE_END,0,1)
end
function c22023850.chop12(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22023850.repop12)
end
function c22023850.repop12(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,22023852)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c22023850.chcon13(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep~=tp and Duel.GetFlagEffect(tp,22023850)>1 and Duel.IsPlayerAffectedByEffect(tp,22023860)
end
function c22023850.chtg13(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c22023850.chop13(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22023850.repop13)
end
function c22023850.repop13(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,22023853)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end