-- 龗龘怪兽
local s,id=GetID()

function s.initial_effect(c)
	-- 效果①：特召+检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 效果②：除外时回收
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 效果①条件：场上无怪或只有龗龘怪兽
function s.spfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x5450)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g==0 or not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
end

-- 效果①目标：特召+破坏+检索
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.fit1(c)
	return c:IsSetCard(0x5450) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
-- 效果①操作：特召+破坏+检索
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 破坏选卡
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		if #g>0 and Duel.IsExistingMatchingCard(s.fit1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if #dg>0 and Duel.Destroy(dg,REASON_EFFECT)>0 then
				-- 检索龗龘魔陷
				local sg=Duel.SelectMatchingCard(tp,s.fit1,tp,LOCATION_DECK,0,1,1,nil)
				if #sg>0 then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
					-- 限制召唤
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_CANNOT_SUMMON)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetTargetRange(1,0)
					e1:SetTarget(s.sumlimit)
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					Duel.RegisterEffect(e2,tp)
				end
			end
		end
	end
end

-- 效果①限制：只能召唤龗龘怪兽
function s.sumlimit(e,c)
	return not c:IsSetCard(0x5450)
end

-- 效果②条件：场上有龗龘䨻且被除外
function s.thfilter(c)
	return c:IsCode(11185036) -- 假设龗龘䨻的ID是当前ID+1
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (re and re:GetHandler():IsSetCard(0x5450)) or rp==1-tp
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

-- 效果②目标：回收龗龘怪兽
function s.thfilter2(c)
	return c:IsSetCard(0x5450) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

-- 效果②操作：回收
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
