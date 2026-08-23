-- 星墟纪行×落渊星
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(function(e,se,sp,st) return st&SUMMON_TYPE_XYZ==0 end)
	c:RegisterEffect(e0)
	
	-- 【专有超量召唤手续】
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	
	-- ①：特殊召唤时适用。超量召唤1只「落渊」超量怪兽。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e2:SetOperation(cm.spsucop)
	c:RegisterEffect(e2)
end

-- =========================================
-- 超量召唤手续 (卡组1怪 + 手卡/卡组1魔1陷)
-- =========================================
function cm.altfilter(c,sc)
	if not ((c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK)) and c:IsSetCard(0x5978)) then return false end
	
	-- 手动检测该卡身上是否存在禁止作为超量素材的限制 (解决魔陷默认被 IsCanBeXyzMaterial 拦截的问题)
	local effs={c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL)}
	for _,te in ipairs(effs) do
		local val=te:GetValue()
		-- Value 可以是 Function(e, c) 也可以是固定数值 1
		if type(val)=="function" then
			if val(te,sc) then return false end
		elseif val~=0 then
			return false
		end
	end
	return true
end

function cm.altgoal(g)
	local deck_m = 0
	local deck_st = 0
	local hand_st = 0
	local s_ct = 0
	local t_ct = 0
	
	for tc in aux.Next(g) do
		local loc = tc:GetLocation()
		local typ = tc:GetOriginalType()
		
		if typ & TYPE_MONSTER > 0 then
			if loc == LOCATION_DECK then deck_m = deck_m + 1
			else return false end -- 怪兽必须来自卡组
		elseif typ & TYPE_SPELL > 0 then
			s_ct = s_ct + 1
			if loc == LOCATION_DECK then deck_st = deck_st + 1
			elseif loc == LOCATION_HAND then hand_st = hand_st + 1
			else return false end
		elseif typ & TYPE_TRAP > 0 then
			t_ct = t_ct + 1
			if loc == LOCATION_DECK then deck_st = deck_st + 1
			elseif loc == LOCATION_HAND then hand_st = hand_st + 1
			else return false end
		else
			return false
		end
	end
	
	-- 必须精准满足：卡组1只怪，手卡1张魔陷，卡组1张魔陷
	if deck_m ~= 1 or hand_st ~= 1 or deck_st ~= 1 then return false end
	-- 必须精准满足：魔法、陷阱各1张
	if s_ct ~= 1 or t_ct ~= 1 then return false end
	
	return true
end

function cm.spcon(e,c,og,min,max)
	if c==nil then return true end
	local tp = c:GetControler()
	if min and min > 3 then return false end
	if max and max < 3 then return false end
	-- 1回合1次限制
	if Duel.GetFlagEffect(tp,m) > 0 then return false end

	local mg = nil
	if og then
		mg = og:Filter(cm.altfilter, nil, c)
	else
		mg = Duel.GetMatchingGroup(cm.altfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil, c)
	end
	
	-- 官方补丁1：强制超量素材占用检测（如果没有包含场上的必须素材，则直接阻断）
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	
	-- 官方补丁2：调弦之魔术师自肃检测附加
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local res=mg:CheckSubGroup(cm.altgoal,3,3)
	aux.GCheckAdditional=nil
	
	return res
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end

	local mg = nil
	if og then
		mg = og:Filter(cm.altfilter, nil, c)
	else
		mg = Duel.GetMatchingGroup(cm.altfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil, c)
	end
	
	-- 官方补丁1：强制超量素材传入选择状态
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local cancel = Duel.IsSummonCancelable()
	
	-- 官方补丁2：调弦之魔术师自肃检测附加
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local g = mg:SelectSubGroup(tp,cm.altgoal,cancel,3,3)
	aux.GCheckAdditional=nil
	
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else 
		return false 
	end
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g = e:GetLabelObject()
	if not g then return end
	
	c:SetMaterial(g)
	Duel.Overlay(c,g)
	
	-- 记录1回合1次自肃并洗牌
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	if g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then Duel.ShuffleHand(tp) end
	
	g:DeleteGroup()
end

-- =========================================
-- ① 升阶效果（非起动，特殊召唤时直接适用）
-- =========================================
function cm.xyzfilter(c,e,tp,mc)
	return c:IsSetCard(0x5978) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end

function cm.spsucop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	-- 直接适用（不入连锁），若卡片被除外/里侧则跳过
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	local g = Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc = g:Select(tp,1,1,nil):GetFirst()
		if sc then
			local mg = c:GetOverlayGroup()
			if #mg > 0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end