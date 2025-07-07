--绮奏终律·落英散歌
function c66620535.initial_effect(c)

	-- 把手卡1只怪兽给对方观看才能发动，和那只怪兽属性不同的1只「绮奏」怪兽从卡组守备表示特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66620535,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66620535)
	e1:SetCost(c66620535.cost)
	e1:SetTarget(c66620535.target)
	e1:SetOperation(c66620535.activate)
	c:RegisterEffect(e1)
	
	-- 以自己场上1只机械族怪兽为对象才能发动，和那只怪兽属性不同的1只「绮奏」怪兽从卡组守备表示特殊召唤，作为对象的怪兽回到手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66620535,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,66620535)
	e2:SetTarget(c66620535.target2)
	e2:SetOperation(c66620535.activate2)
	c:RegisterEffect(e2)
	
	-- 自己场上的表侧表示的融合怪兽因对方的效果从场上离开的场合或者被战斗破坏的场合，把墓地的这张卡除外才能发动，选场上1张卡破坏
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66620535,3))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,66620536)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c66620535.descon)
	e3:SetTarget(c66620535.destg)
	e3:SetOperation(c66620535.desop)
	c:RegisterEffect(e3)
	
	-- 这些效果发动的回合，自己不是融合怪兽不能从额外卡组特殊召唤
	Duel.AddCustomActivityCounter(66620535,ACTIVITY_SPSUMMON,c66620535.counterfilter)
	
	-- 自己是这次决斗中有把「绮奏」速攻魔法卡5次以上发动过的场合，可以把对方场上的卡全部破坏
	Duel.AddCustomActivityCounter(66620536, ACTIVITY_CHAIN,c66620535.chainfilter)	
end

-- 这些效果发动的回合，自己不是融合怪兽不能从额外卡组特殊召唤
function c66620535.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION)
end

function c66620535.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end

-- 把手卡1只怪兽给对方观看才能发动，和那只怪兽属性不同的1只「绮奏」怪兽从卡组守备表示特殊召唤
function c66620535.filter(c,e,tp)
	return not c:IsPublic() and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c66620535.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end

function c66620535.spfilter(c,e,tp,pc)
	return c:IsSetCard(0x666a) and not c:IsAttribute(pc:GetAttribute()) and not c:IsCode(pc:GetCode())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c66620535.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66620535.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c66620535.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end

function c66620535.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c66620535.activate(e,tp,eg,ep,ev,re,r,rp)
	local pc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or pc==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c66620535.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,pc):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c66620535.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

-- 以自己场上1只机械族怪兽为对象才能发动，和那只怪兽属性不同的1只「绮奏」怪兽从卡组守备表示特殊召唤，作为对象的怪兽回到手卡
function c66620535.filter2(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(c66620535.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttribute())
end

function c66620535.spfilter2(c,e,tp,attr)
	return not c:IsAttribute(attr) and c:IsSetCard(0x666a)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end

function c66620535.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66620535.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c66620535.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c66620535.filter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c66620535.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local attr=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c66620535.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,attr)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 and tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c66620535.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

-- 自己场上的表侧表示的融合怪兽因对方的效果从场上离开的场合或者被战斗破坏的场合，把墓地的这张卡除外才能发动，选场上1张卡破坏，自己是这次决斗中有把「绮奏」速攻魔法卡5次以上发动过的场合，可以把对方场上的卡全部破坏
function c66620535.chainfilter(re,tp,cid)
	if re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:GetHandler():IsSetCard(0x666a)
		and re:GetHandler():IsType(TYPE_QUICKPLAY) then
		Duel.RegisterFlagEffect(tp,66620536,0,0,1)
		return true
	end
	return true
end

function c66620535.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and bit.band(c:GetPreviousTypeOnField(),TYPE_FUSION)~=0
		and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end

function c66620535.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66620535.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end

function c66620535.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c66620535.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if Duel.GetFlagEffect(tp,66620536) >= 5 then
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if #dg > 0 and Duel.SelectYesNo(tp,aux.Stringid(66620535,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c66620535.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
