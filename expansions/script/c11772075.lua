local s,id=GetID()
function s.initial_effect(c)
	-- 仪式怪兽标准限制
	c:EnableReviveLimit()
	aux.AddCodeList(c,11772095,11772070,11772075)
	
	-- ①：仪式召唤的场合，从卡组把1张「11772095」在魔陷区表侧表示放置
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tfcon)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
	
	-- ②：对方把卡的效果发动时（二速诱发即时效果，效果解放并无效）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.negcon)
	-- 移除了 SetCost，因为解放是效果的一部分
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end

-- ==================== ① 效果相关 ====================
function s.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.tffilter(c,tp)
	-- 严格判定魔陷区（LOCATION_SZONE）是否有空位，不再做场地区域（FZONE）的特殊判断
	return c:IsCode(11772095) and not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		-- 严格放置到 LOCATION_SZONE
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

-- ==================== ② 效果相关 ====================
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.cfilter(c)
	return c:IsLevelAbove(5) and c:IsReleasableByEffect()
end
function s.codefilter(c)
	return c:IsFaceup() and c:IsCode(11772070)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		-- 发动前提：当前场上必须有能够被效果解放的5星以上怪兽
		return Duel.CheckReleaseGroup(tp,s.cfilter,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local rc=re:GetHandler()
	if Duel.IsExistingMatchingCard(s.codefilter,tp,LOCATION_ONFIELD,0,1,nil) 
		and rc:IsRelateToEffect(re) and rc:IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	-- 在效果处理时进行解放动作 (REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectReleaseGroup(tp,s.cfilter,1,1,nil)
	if #rg>0 and Duel.Release(rg,REASON_EFFECT)>0 then
		-- 解放成功后，执行无效处理
		if Duel.NegateEffect(ev) then
			local rc=re:GetHandler()
			if rc:IsRelateToEffect(re) and Duel.IsExistingMatchingCard(s.codefilter,tp,LOCATION_ONFIELD,0,1,nil) and rc:IsAbleToRemove() then
				if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.BreakEffect()
					Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
				end
			end
		end
	end
end