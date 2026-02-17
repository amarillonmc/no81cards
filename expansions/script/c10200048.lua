--午夜战栗·腐朽伴舞
function c10200048.initial_effect(c)
	--①：午夜战栗怪兽移动或表示形式变更时从手卡·墓地特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200048,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+0xe25)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10200048)
	e1:SetCondition(c10200048.spcon)
	e1:SetTarget(c10200048.sptg)
	e1:SetOperation(c10200048.spop)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_CHANGE_POS)
	e1b:SetCondition(c10200048.spcon2)
	c:RegisterEffect(e1b)
	--②：特殊召唤时移动午夜战栗怪兽或变成里侧守备
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200048,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10200049)
	e2:SetTarget(c10200048.mvtg)
	e2:SetOperation(c10200048.mvop)
	c:RegisterEffect(e2)
end
--①效果
function c10200048.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe25)
end
function c10200048.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200048.cfilter,1,nil) and eg:IsExists(Card.IsControler,1,nil,tp)
end
function c10200048.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c,tp) return c:IsFaceup() and c:IsSetCard(0xe25) and c:IsControler(tp) end,1,nil,tp)
end
function c10200048.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10200048.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		--离场时除外
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
--②效果
function c10200048.mvfilter(c,tp)
	if not c:IsFaceup() or not c:IsSetCard(0xe25) then return false end
	if c:IsCanTurnSet() then return true end
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c10200048.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10200048.mvfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10200048.mvfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10200048.mvfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c10200048.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local seq=tc:GetSequence()
	local b1=false
	local flag=0
	if seq<=4 then
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
		b1=flag~=0
	end
	local b2=tc:IsCanTurnSet()
	if not b1 and not b2 then return end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(10200048,2),aux.Stringid(10200048,3))
	elseif b1 then
		op=0
	else
		op=1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
		local nseq=math.log(zone,2)
		Duel.MoveSequence(tc,nseq)
	else
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
