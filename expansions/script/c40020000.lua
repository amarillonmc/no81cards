--朱斯贝克·反抗黎骑·晃临
local m=40020000
local cm=_G["c"..m]
cm.named_with_Rebellionform=1
cm.named_with_Youthberk=1
function cm.initial_effect(c)
	aux.AddCodeList(c,40010499)
	-- 【基础设置】允许XYZ召唤，素材为3只8星怪兽
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,8,3)

	-- 【①效果】这张卡XYZ召唤成功时发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.xcon)	   -- 仅XYZ召唤时发动
	e1:SetCost(cm.xcost)		   -- 取除素材
	e1:SetTarget(cm.xtg)		   -- 设置效果
	e1:SetOperation(cm.xop)		-- 执行效果
	c:RegisterEffect(e1)

	-- 【②效果】这张卡作为素材时被送去墓地，不送去墓地而除外
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cm.rmcon)	  -- 仅当是素材状态
	e2:SetValue(LOCATION_REMOVED)		 -- 改为除外
	c:RegisterEffect(e2)
end

--【①效果条件】XYZ召唤的场合才发动
function cm.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

--【①效果成本】取除素材，同时判断可发动的效果数量
function cm.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetOverlayCount()
	if chk==0 then return ct>0 end
	local maxct=math.min(3,ct)
	-- 先移除1张素材
	Duel.RemoveOverlayCard(tp,tp,1,1,REASON_COST)

	-- 检查除外区是否存在同名卡，决定效果次数
	local ex_ct=0
	local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsCode,m),tp,LOCATION_REMOVED,0,nil)
	if #g>0 then
		ex_ct=maxct  -- 有同名卡 → 可发动取除数量个效果
	else
		ex_ct=1	  -- 否则只选1个效果
	end
	e:SetLabel(ex_ct) -- 保存可选效果次数
end

--【检索可特召的怪兽】烈光之骑士 朱斯或记述它的卡
function cm.spfilter(c,e,tp)
	return (c:IsCode(40010499) or aux.IsCodeListed(c,40010499))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

--【①效果目标设置】（这里只是通用处理）
function cm.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local opt=e:GetLabel()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,0,nil,opt,0,0) -- 表示会发动 opt 次效果
end

--【①效果操作】
function cm.xop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local options={}

	-- 效果1：破坏场上卡
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		table.insert(options,1)
	end

	-- 效果2：特召烈光之骑士 朱斯或记述其卡
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) then
		table.insert(options,2)
	end

	-- 效果3：倍伤（无条件可用）
	table.insert(options,3)

	-- 连续选ct次效果
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local sel=Duel.AnnounceNumber(tp,table.unpack(options))
		if sel==1 then
			-- 选择并破坏场上卡
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
		elseif sel==2 then
			-- 特召指定卡
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		elseif sel==3 then
			-- 倍伤效果
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetValue(function(e,re,val,r,rp,rc) return val*2 end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)

			-- 倍效果伤害
			local e2=e1:Clone()
			e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
			e2:SetCondition(function(e,re,val,r,rp,rc) return true end)
			Duel.RegisterEffect(e2,tp)
		end
	end
end

--【②效果条件】必须是作为素材状态时
function cm.rmcon(e)
	return e:GetHandler():IsLocation(LOCATION_OVERLAY)
end

