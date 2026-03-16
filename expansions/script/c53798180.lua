local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--attach and remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	-- ①：自己·对方的主要阶段才能发动。
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 这个卡名的效果在同一阶段中只能使用1次。
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_MAIN1,0,1)
	else
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_MAIN2,0,1)
	end
end
function s.matfilter(c,att)
	return c:GetOriginalAttribute()&att~=0
end
function s.filter(c,sc)
	-- 原本属性相同的怪兽不在这张卡的超量素材中存在的自己或对方的墓地的1只怪兽
	if not c:IsType(TYPE_MONSTER) then return false end
	local att=c:GetOriginalAttribute()
	local og=sc:GetOverlayGroup()
	return not og:IsExists(s.matfilter,1,nil,att)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		-- 效果处理包含“那之后，那只怪兽以外的这张卡作为超量素材中的1只怪兽取除”，因此发动时必须已有素材（否则无法取出“那只以外”的素材）
		return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
			and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c)
	end
	-- 不取对象效果
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,c)
	local tc=g:GetFirst()
	if tc and Duel.Overlay(c,tc) then
		-- 那之后，那只怪兽以外的这张卡作为超量素材中的1只怪兽取除。
		local mg=c:GetOverlayGroup()
		mg:RemoveCard(tc) -- 排除刚才塞进去的卡
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
			local sg=mg:Select(tp,1,1,nil)
			-- 使用SendtoGrave来处理“取除素材”，这是脚本中处理特定素材被取除的标准写法
			-- 虽然通常使用RemoveOverlayCard，但为了满足“那只怪兽以外”的条件，必须手动筛选后送墓
			if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
				local rc=sg:GetFirst()
				if rc then
					Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
					Duel.RaiseEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
					-- 这次主要阶段中，双方不能把原本属性和取除的怪兽相同的怪兽召唤·特殊召唤。
					local att=rc:GetOriginalAttribute()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_CANNOT_SUMMON)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetTargetRange(1,1)
					e1:SetTarget(s.sumlimit)
					e1:SetLabel(att)
					if Duel.GetCurrentPhase()==PHASE_MAIN1 then
						e1:SetReset(RESET_PHASE+PHASE_MAIN1)
					else
						e1:SetReset(RESET_PHASE+PHASE_MAIN2)
					end
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					Duel.RegisterEffect(e2,tp)
				end
			end
		end
	end
end
function s.sumlimit(e,c)
	return c:GetOriginalAttribute()&e:GetLabel()~=0
end