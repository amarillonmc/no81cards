-- 落渊潮溯『未来永劫』
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	
	-- 【自定义动态超量召唤手续】
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
	
	-- ①：通天塔光环（向自己赋予标识，由你在怪兽效果中检测并自行执行 1回合1次 限制）
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	
	-- 【全局追踪】与动态客户端提示
	if not cm.global_check then
		cm.global_check=true
		cm.todeck_count={}
		cm.client_hint_eff={} -- 新增：用于缓存并动态覆盖客户端提示
		
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			-- 核心修正：使用 GetOperationInfo 获取效果的发动预告
			local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
			-- ex代表有此类别预告；tc>0 代表有具体的卡片数量预告；tg存在且数量>0 代表有明确对象预告
			if ex and ((tg and #tg>0) or tc>0) then
				local turn=Duel.GetTurnCount()
				local count=(cm.todeck_count[turn] or 0)+1
				cm.todeck_count[turn]=count
				
				-- =========================================================
				-- 【UI 刷新逻辑】：限制在 1~5 之间，向双方玩家刷新提示
				-- =========================================================
				local state = math.min(count, 5)
				
				for p = 0, 1 do
					-- 清理旧的 UI 提示
					if cm.client_hint_eff[p] then
						cm.client_hint_eff[p]:Reset()
						cm.client_hint_eff[p] = nil
					end
					
					-- 注册新的 UI 提示
					local de=Effect.CreateEffect(e:GetHandler())
					de:SetDescription(aux.Stringid(m, state)) -- 读取 1~5 号描述
					de:SetType(EFFECT_TYPE_FIELD)
					de:SetCode(EFFECT_FLAG_EFFECT)
					de:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
					de:SetTargetRange(1,0)
					de:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(de, p)
					
					-- 保存引用供下次检索时 Reset
					cm.client_hint_eff[p] = de
				end
			end
		end)
		Duel.RegisterEffect(ge1,0)
	end
end

-- =========================================
-- 超量召唤手续 (动态素材需求计算)
-- =========================================
function cm.get_req_count()
	local turn=Duel.GetTurnCount()
	local count=cm.todeck_count[turn] or 0
	-- 基础为 6，每有 1 次减少 1 个，最少为 1
	return math.max(1, 6 - count)
end

function cm.spfilter(c,sc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,2)
end

function cm.spcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local req=cm.get_req_count()
	local minc=req
	local maxc=req
	if min then
		minc=math.max(minc,min)
		maxc=math.min(maxc,max)
	end
	if maxc<minc then return false end
	
	local mg=nil
	if og then
		mg=og:Filter(cm.spfilter,c,c)
	else
		mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE,0,c,c)
	end
	
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local res=mg:CheckSubGroup(aux.XyzLevelFreeGoal,minc,maxc,tp,c)
	aux.GCheckAdditional=nil
	return res
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	local req=cm.get_req_count()
	local minc=req
	local maxc=req
	if min then
		minc=math.max(minc,min)
		maxc=math.min(maxc,max)
	end
	
	local mg=nil
	if og then
		mg=og:Filter(cm.spfilter,c,c)
	else
		mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE,0,c,c)
	end
	
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local cancel=Duel.IsSummonCancelable()
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local g=mg:SelectSubGroup(tp,aux.XyzLevelFreeGoal,cancel,minc,maxc,tp,c)
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
	local g=nil
	if og and not min then
		g=og
	else
		g=e:GetLabelObject()
	end
	
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
	
	if not (og and not min) then g:DeleteGroup() end
end