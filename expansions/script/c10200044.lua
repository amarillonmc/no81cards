--午夜战栗·月下狼影
function c10200044.initial_effect(c)
	--①：自己场上没有怪兽存在的场合从手卡特殊召唤并检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200044,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10200044)
	e1:SetCondition(c10200044.spcon1)
	e1:SetTarget(c10200044.sptg1)
	e1:SetOperation(c10200044.spop1)
	c:RegisterEffect(e1)
	--②：向相邻区域移动并在原区域特招深红舞王
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200044,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10200045)
	e2:SetTarget(c10200044.mvtg)
	e2:SetOperation(c10200044.mvop)
	c:RegisterEffect(e2)
	--全局监测：用于处理"向其他怪兽区域移动"的自定义事件
	if not c10200044.global_check then
		c10200044.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(c10200044.movecheckop)
		Duel.RegisterEffect(ge1,0)
	end
end
--全局移动事件检测
function c10200044.movecheckfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetPreviousSequence()~=c:GetSequence()
end
function c10200044.movecheckop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c10200044.movecheckfilter,nil)
	if #g>0 then
		Duel.RaiseEvent(g,EVENT_CUSTOM+0xe25,re,r,rp,ep,ev)
	end
end
--①效果
function c10200044.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c10200044.thfilter(c)
	return c:IsSetCard(0xe25) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10200044.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c10200044.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10200044.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10200044.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	--自肃：这个回合只能特殊召唤不死族
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(10200044,2))
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10200044.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10200044.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
--②效果
function c10200044.spfilter2(c,e,tp)
	return c:IsCode(10200046) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200044.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if chk==0 then
		if seq>4 then return false end
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
		return flag~=0 and Duel.IsExistingMatchingCard(c10200044.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c10200044.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local seq=c:GetSequence()
	if seq>4 then return end
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
	if flag==0 then return end
	--记录原始区域
	local prev_zone=1<<seq
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(zone,2)
	Duel.MoveSequence(c,nseq)
	if c:GetSequence()~=nseq then return end
	--在原区域特招深红舞王
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10200044.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,prev_zone)>0 then
		--这张卡回到手卡
		Duel.BreakEffect()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
