--落日残响·彩梦·Awaken
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,6100318,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,true,true)
	
	--①：调度陷阱
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE) -- 包含从卡组解放
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tfcon)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
	
	--②：获得效果（无效并解放）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(s.effcon)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	e0:SetLabelObject(e2)
	c:RegisterEffect(e0)
	
	--③：遗言
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e4)
end

-- === 效果① ===
function s.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.tffilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP)
end

function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK,0,2,nil) end
end

function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	
	-- 从卡组选2张
	local g=Duel.GetMatchingGroup(s.tffilter,tp,LOCATION_DECK,0,nil)
	if #g<2 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,2,2,nil)
	
	if #sg==2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3)) -- 选1张放置
		local tc1=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc1)
		local tc2=sg:GetFirst() -- 剩下那张解放
		
		-- 处理tc1：盖放或表侧放置
		local b1=tc1:IsSSetable()
		local b2=not tc1:IsForbidden() -- 表侧放置仅需不被禁止且有格子
		
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5)) -- 盖放, 表侧放置
		elseif b1 then
			op=0
		elseif b2 then
			op=1
		else
			return -- 无法操作
		end
		
		if op==0 then
			Duel.SSet(tp,tc1,tp,true)
		else
			Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		
		-- 处理tc2：解放
		if tc2 then
			Duel.BreakEffect()
			Duel.SendtoGrave(tc2,REASON_EFFECT+REASON_RELEASE)
		end
	end
end

-- === 效果② ===
function s.mfilter(c)
	return not c:IsSetCard(0x614)
end
function s.valcheck(e,c)
	local mg=c:GetMaterial()
	if mg:GetCount()>0 and not mg:IsExists(s.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1 and 
		rc:IsType(TYPE_TRAP) and rc:IsType(TYPE_CONTINUOUS)
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		-- 无效效果
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		
		-- 解放
		Duel.AdjustInstantly(tc)
		Duel.Release(tc,REASON_EFFECT)
	end
end

-- === 效果③ ===
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (rp==1-tp and e:GetHandler():IsPreviousControler(tp)) or (e:GetHandler():IsReason(REASON_EFFECT) and re and re:GetHandler()~=e:GetHandler())
end

function s.spfilter(c,e,tp)
	return c:IsCode(6100318) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end