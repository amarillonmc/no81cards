--星空之骑士 阿兰娜
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	--①：不会被战斗破坏
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--②：伤算后送装备弹卡 (玩家强行行为)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.batcon)
	e2:SetCost(s.batcost)
	e2:SetTarget(s.battg)
	e2:SetOperation(s.batop)
	c:RegisterEffect(e2)

	--③：手卡/墓地效果发动时 (二选一)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.effcon)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
end

-- === 效果② ===
function s.batcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if a:IsControler(1-tp) then a,d=d,a end
	-- 自己怪兽和对方怪兽进行战斗
	return a:IsControler(tp) and d:IsControler(1-tp)
end

function s.costfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end

function s.batcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function s.battg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
end

function s.batop(e,tp,eg,ep,ev,re,r,rp)
	-- 选对方场上1张卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		-- 对方必须让那张卡回到卡组 (Rule规则移除，无视抗性)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
end

-- === 效果③ ===
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	-- 手卡·墓地的怪兽的效果发动时
	return re:IsActiveType(TYPE_MONSTER) and (re:GetActivateLocation()&(LOCATION_HAND+LOCATION_GRAVE))~=0
end

-- 选项1的过滤器：检查发动效果的怪兽能否被装备
function s.eqcheck(c,tp)
	return  (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) and not c:IsForbidden()
end

-- 选项2的过滤器：墓地、是此卡的素材、是调整、能特召
function s.matspfilter(c,e,tp,sync)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_TUNER) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and sync:GetMaterial():IsContains(c) and (c:GetReason()&0x80008)==0x80008 and c:GetReasonCard()==sync
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	
	-- 选项1：降攻装备
	local b1 = c:GetAttack()>=500 and s.eqcheck(rc,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	
	-- 选项2：苏生素材调整
	-- 必须是同调召唤状态才能读取GetMaterial
	local b2 = c:IsSummonType(SUMMON_TYPE_SYNCHRO) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:GetMaterial():IsExists(s.matspfilter,1,nil,e,tp,c)
	
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	end
	e:SetLabel(op)
	
	if op==0 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_EQUIP)
		-- 装备通常不取对象，特别是这种针对Chain来源的
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	
	if op==0 then
		-- 降攻1000并装备
		if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetAttack()>=500 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			
			local rc=re:GetHandler()
			if c:IsImmuneToEffect(e1) or not rc:IsRelateToEffect(re) then return end
			
			-- 再次检查rc位置，防止离场
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (rc:IsLocation(LOCATION_HAND) or rc:IsLocation(LOCATION_GRAVE)) then
				if Duel.Equip(tp,rc,c) then
					-- 装备限制
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_EQUIP_LIMIT)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetValue(s.eqlimit)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					rc:RegisterEffect(e2)
					-- 标记：当作装备卡使用
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_EQUIP_LIMIT)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetValue(s.eqlimit)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					rc:RegisterEffect(e3)
				end
			end
		end
	else
		-- 苏生素材调整
		if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		-- 再次筛选符合条件的素材 (在墓地且是调整)
		local g=c:GetMaterial():FilterSelect(tp,s.matspfilter,1,1,nil,e,tp,c)
		local tc=g:GetFirst()
		if tc then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
				-- 效果无效
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
			end
		end
	end
end

function s.eqlimit(e,c)
	return e:GetOwner()==c
end