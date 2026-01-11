--朦雨的箱庭-临界的雨境
local s,id,o=GetID()
function s.initial_effect(c)
	--场地魔法通用注册
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	--disable spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(s.splimit)
	c:RegisterEffect(e4)

	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(LOCATION_FZONE,0)
	e9:SetValue(aux.indoval)
	c:RegisterEffect(e9)

	--①：召唤/特召诱发 (连接召唤 或 变星)
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_SPSUMMON_SUCCESS)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(custom_code)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.effcon)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)

	--③：离场遗言 (检索或特召)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

function s.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK))
end

-- === 效果① ===
function s.spfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSummonPlayer(tp) and c:IsFaceup()
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil,tp)
end
-- 过滤eg：属于自己的水属性怪兽
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsLevelAbove(1)
end

-- 触发过滤
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end

-- 选项1：连接召唤
function s.lkfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLinkSummonable(nil)
end

-- 选项2：变星
function s.lvfilter(c,e,tp)
	return s.cfilter(c,tp)
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	-- 如果chkc存在，说明是变星逻辑的回调
	if chkc then return eg:IsContains(chkc) and s.lvfilter(chkc,e,tp) end
	
	local g=eg:Filter(s.cfilter,nil,tp)
	if #g==0 then return false end
	
	-- 检查各选项是否可用 (FlagEffect记录是否已使用)
	-- 选项1: 连接召唤
	local b1=Duel.GetFlagEffect(tp,id+100)==0 
		and Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
	-- 选项3: 生Token
	local b3=Duel.GetFlagEffect(tp,id+200)==0 
		and Duel.CheckLPCost(tp,500) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x613,TYPE_MONSTER+TYPE_TUNER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER)

	if chk==0 then return b1 or b2 or b3 end
	
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(id,2) -- "连接召唤"
		opval[off]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,3) -- "特殊召唤衍生物"
		opval[off]=3
		off=off+1
	end
	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	e:SetLabel(sel)
	
	if sel==1 then
		-- 记录使用
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		
	elseif sel==3 then
		Duel.RegisterFlagEffect(tp,id+300,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sel=e:GetLabel()
	
	if sel==1 then
		-- 连接召唤
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end
		
	elseif sel==3 then
		-- 生Token
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,6100239,0x613,TYPE_MONSTER+TYPE_TUNER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER) then
			Duel.PayLPCost(tp,500)
			local token=Duel.CreateToken(tp,6100239)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

-- === 效果③ ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 场上的表侧表示的这张卡被效果送去墓地
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT)
end

function s.thfilter(c,e,tp)
	-- 4星以外的「朦雨」怪兽
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) and not c:IsLevel(4)
		-- 至少满足加入手卡或特殊召唤中的一项
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		
		if b1 and b2 then 
			op=Duel.SelectOption(tp,1190,1152) -- "加入手卡", "特殊召唤"
		elseif b1 then 
			op=0 
		else 
			op=1 
		end
		
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end