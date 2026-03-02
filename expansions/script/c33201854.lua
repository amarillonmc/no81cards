-- 魁杓七圣-文曲天权
local s,id=GetID()

function s.initial_effect(c)
	-- ①：对方战阶发场上的效果时，无效并特召自身
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)

	-- ②：从场上以外送墓时，特召手卡·墓地本家，之后可解放手卡，下个战阶开始时回收墓地
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY) -- 场合效果，不会错过时点
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end

-- ==================== ①效果：战阶手坑无效并特召 ====================
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	-- 必须是对方发动，且在战斗阶段
	local ph=Duel.GetCurrentPhase()
	if ep==tp or ph<PHASE_BATTLE_START or ph>PHASE_BATTLE then return false end
	
	-- 必须是场上的卡的效果，且可以被无效
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc & LOCATION_ONFIELD)~=0 and Duel.IsChainDisablable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- ==================== ②效果：非场上送墓特召+延迟回收 ====================
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	-- 必须从场上以外被送去墓地（例如手卡、卡组、超量素材被拔除等）
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x3328) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.relfilter(c)
	-- 用于效果解放的怪兽（7星以上）
	return c:IsLevelAbove(7) and c:IsReleasableByEffect()
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	
	-- 注意墓地特召可能受到王家谷限制，所以加上 aux.NecroValleyFilter
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		
		-- 那之后，判断手卡是否有可以解放的7星怪兽
		local rg=Duel.GetMatchingGroup(s.relfilter,tp,LOCATION_HAND,0,nil)
		if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then -- aux.Stringid(id,2) 需在cdb填入 "是否解放手卡的怪兽发动后续效果？"
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local sg=rg:Select(tp,1,1,nil)
			if Duel.Release(sg,REASON_EFFECT)>0 then
				-- 注册一个“下个战斗阶段开始时”的延迟效果
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
				e1:SetCountLimit(1)
				e1:SetCondition(s.thcon)
				e1:SetOperation(s.thop)
				
				-- 如果当前正处于战斗阶段，则标记当前回合数，避开当前这回合的战阶，确保是“下个”战阶
				local ph=Duel.GetCurrentPhase()
				if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
					e1:SetLabel(Duel.GetTurnCount())
				else
					e1:SetLabel(0)
				end
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end

-- ==================== 延迟效果：下个战阶回收墓地 ====================
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	-- 如果 Label 记录了回合数，说明它是在某个战阶发动的，要跳过那一回合
	if e:GetLabel()~=0 and e:GetLabel()==Duel.GetTurnCount() then return false end
	return true
end
function s.thfilter(c)
	return c:IsSetCard(0x3328) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id) -- 提示玩家这是「魁杓七圣-文曲天权」的延迟效果
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then -- aux.Stringid(id,3) 需在cdb填入 "是否把墓地的「魁杓七圣」加入手卡？"
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	e:Reset() -- 触发过一次（无论你是否选择加手）后自动注销，防止以后战阶再弹
end