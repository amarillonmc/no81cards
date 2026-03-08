--古神话之魂
function c98500300.initial_effect(c)
	aux.AddCodeList(c,10000000,10000010,10000020)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c98500300.splimit)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500300,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,98500300)
	e3:SetTarget(c98500300.thtg)
	e3:SetOperation(c98500300.thop)
	c:RegisterEffect(e3)
	--tohand
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c98500300.rmlimit)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--destroy
	--cannot trigger
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_TRIGGER)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetCondition(c98500300.actlimcon)
	e7:SetTarget(c98500300.rmlimit)
	c:RegisterEffect(e7)
	--change effect type
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(98500300)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(1,0)
	c:RegisterEffect(e8)
end
function c98500300.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return  c:IsLevel(12) and c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsLocation(LOCATION_HAND)
end
function c98500300.spfilter(c,e,tp)
	return c:IsCode(10000000,10000010,10000020) and c:GetOriginalLevel()==10
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98500300.fusionfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DIVINE) and c:IsType(TYPE_FUSION)
end
function c98500300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98500300.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c98500300.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98500300.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if sc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c98500300.thfilter(c)
	return c:IsCode(42469671,79339613,79868386,4059313,98500316) and c:IsAbleToHand()
end
function c98500300.thfilter2(c)
	return c:IsRace(RACE_DIVINE) and c:IsType(TYPE_FUSION)
end
function c98500300.thfilter3(c)
	return c:IsCode(98500345) and c:IsAbleToHand()
end
function c98500300.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查选项1：手卡或墓地存在符合条件的怪兽
		local opt1 = Duel.IsExistingMatchingCard(c98500300.spfilter, tp, LOCATION_HAND+LOCATION_GRAVE, 0, 1, nil,e,tp)
		-- 检查选项2：墓地或除外区存在符合条件的卡片（考虑神力解放的额外条件）
		local has_fusion = Duel.IsExistingMatchingCard(c98500300.fusionfilter, tp, LOCATION_MZONE, 0, 1, nil)
		local function th_filter(c)
			if c:IsCode(42469671,79339613,79868386,4059313,98500316) then
				return true
			end
			if has_fusion and c:IsCode(98500345) then
				return true
			end
			return false
		end
		local opt2 = Duel.IsExistingMatchingCard(th_filter, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, 1, nil)
		return opt1 or opt2
	end

	-- 构建选项菜单
	local opts = {}
	if Duel.IsExistingMatchingCard(c98500300.spfilter, tp, LOCATION_HAND+LOCATION_GRAVE, 0, 1, nil,e,tp) then
		table.insert(opts,aux.Stringid(98500300,0))
	end
	local has_fusion_now = Duel.IsExistingMatchingCard(c98500300.fusionfilter, tp, LOCATION_MZONE, 0, 1, nil)
	local function th_filter2(c)
		if c:IsCode(42469671,79339613,79868386,4059313,98500316) then
			return true
		end
		if has_fusion_now and c:IsCode(98500345) then
			return true
		end
		return false
	end
	if Duel.IsExistingMatchingCard(th_filter2, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, 1, nil) then
		table.insert(opts,aux.Stringid(98500300,1))
	end

	-- 玩家选择分支
	local sel = Duel.SelectOption(tp, table.unpack(opts))
	if opts[sel+1] == aux.Stringid(98500300,0) then
		e:SetLabel(0)
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND+LOCATION_GRAVE)
	else
		e:SetLabel(1)
		Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE+LOCATION_REMOVED)
	end
end
function c98500300.thop(e,tp,eg,ep,ev,re,r,rp)
	local label = e:GetLabel()
	if label == 0 then
		-- 特殊召唤效果：无视召唤条件
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(c98500300.spfilter), tp, LOCATION_HAND+LOCATION_GRAVE, 0, 1, 1, nil,e,tp)
		if #g > 0 then
			local tc = g:GetFirst()
			if tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	else
		-- 回收效果
		local has_fusion = Duel.IsExistingMatchingCard(c98500300.fusionfilter, tp, LOCATION_MZONE, 0, 1, nil)
		local function th_filter(c)
			if c:IsCode(42469671,79339613,79868386,4059313,98500316) then
				return true
			end
			if has_fusion and c:IsCode(98500345) then
				return true
			end
			return false
		end
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local g = Duel.SelectMatchingCard(tp, th_filter, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, 1, 1, nil)
		if #g > 0 then
			Duel.SendtoHand(g, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, g)
		end
	end
end
function c98500300.rmlimit(e,c,tp,r,re,te)
	return c:GetOriginalRace()==RACE_DIVINE 
end
function c98500300.actlimcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_END 
end
function c98500300.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c98500300.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98500300.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
