-- 龗龘怪兽
local s,id=GetID()

function s.initial_effect(c)
	-- 效果①：特召+除外+苏生
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 效果②：送墓时保护
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.protcon)
	e2:SetOperation(s.protop)
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

-- 效果①目标：特召+除外+苏生
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

-- 效果①操作：特召+除外+苏生
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 选卡除外
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		if #g>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if #dg>0 and Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)>0 then
				-- 特召墓地/除外的龗龘怪兽
				local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
				if #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=sg:Select(tp,1,1,nil)
					if #tg>0 then
						Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
					end
				end
			end
		end
		-- 限制除外区召唤
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e2,tp)
	end
end

-- 效果①特召目标筛选
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x5450) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 效果①限制：不能召唤/特召除外区的非龗龘怪兽
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsSetCard(0x5450)
end

-- 效果②条件：被对方或龗龘卡效果送墓
function s.protcon(e,tp,eg,ep,ev,re,r,rp)
	return (re and re:GetHandler():IsSetCard(0x5450)) or rp==1-tp
end

-- 效果②操作：保护场上的龗龘卡
function s.protfilter(c)
	return c:IsSetCard(0x5450) and c:IsFaceup()
end
function s.protop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.protfilter,tp,LOCATION_ONFIELD,0,nil)
	if #g>0 then
		-- 不被效果破坏
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(s.indtg)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		
		-- 不能成为效果对象
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(s.indtg)
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end

-- 效果②保护对象筛选
function s.indtg(e,c)
	return c:IsSetCard(0x5450)
end
