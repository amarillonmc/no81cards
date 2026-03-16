local s,id,o=GetID()
function s.initial_effect(c)
	--Xyz Summon
	--7星怪兽×2
	--「（这个卡名）」1回合1次也能把1张手卡除外，在持有超量素材2个以上的自己的超量怪兽上面重叠来超量召唤。
	aux.AddXyzProcedure(c,nil,7,2,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
	c:EnableReviveLimit()
	
	--Effect 1
	--①：把这张卡作为超量素材中的2只持有等级的怪兽取除才能发动。
	--从自己的手卡·卡组·墓地选种族·属性·等级之内只有种族、只有属性和只有等级是在取除的怪兽中存在的3只怪兽，给双方确认。
	--那之内的1只特殊召唤，剩下的卡除外。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

-- 超量召唤替代条件：持有超量素材2个以上的自己的超量怪兽
function s.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>=2
end

-- 超量召唤替代手续：除外1张手卡，并注册HOPT
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

-- Cost过滤器：持有等级的怪兽
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()>0
end

-- 判定核心：c 与 mc 是否仅在 mode 方面相同
-- mode 1: Race, 2: Attribute, 3: Level
function s.check_match(c,mc,mode)
	local r = c:GetRace()==mc:GetRace()
	local a = c:GetAttribute()==mc:GetAttribute()
	local l = c:GetLevel()==mc:GetLevel()
	
	if mode==1 then -- Only Race
		return r and not a and not l
	elseif mode==2 then -- Only Attribute
		return not r and a and not l
	elseif mode==3 then -- Only Level
		return not r and not a and l
	end
	return false
end

-- 检查 c 是否与 group 中的任意一张卡满足 mode 匹配
function s.is_match_in_group(c,group,mode)
	return group:IsExists(function(mc) return s.check_match(c,mc,mode) end, 1, nil)
end

-- SelectSubGroup 的检查函数：sg（3张）必须分别对应三种匹配
function s.gcheck(sg,e,tp,mg,detached_g)
	-- 由于“仅种族相同”隐含了属性和等级不同，三种匹配是互斥的。
	-- 因此只要sg中存在满足条件的卡各1张即可。
	return sg:IsExists(s.is_match_in_group,1,nil,detached_g,1) -- 存在满足种族匹配的
	   and sg:IsExists(s.is_match_in_group,1,nil,detached_g,2) -- 存在满足属性匹配的
	   and sg:IsExists(s.is_match_in_group,1,nil,detached_g,3) -- 存在满足等级匹配的
end

-- Target chk==0 时的预检查函数：检查是否存在一组素材 mg，使得 H/D/G 中有满足条件的组合
function s.cost_preview_check(mg,tp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	-- 检查是否能从 g 中选出 3 张满足 mg 条件的卡
	return g:CheckSubGroup(s.gcheck,3,3,nil,tp,nil,mg)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup():Filter(s.cfilter,nil)
	if chk==0 then
		-- 精确检查：是否存在 2 个素材，使得能满足 Target 的条件
		if e:GetLabelObject() then return true end -- 如果已经支付过cost（罕见情况），直接通过
		return og:CheckSubGroup(s.cost_preview_check,2,2,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=og:SelectSubGroup(tp,s.cost_preview_check,false,2,2,tp)
	if sg then
		Duel.SendtoGrave(sg,REASON_COST)
		sg:KeepAlive()
		e:SetLabelObject(sg)
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 如果 chk==0 且 Cost 未支付（LabelObject 为空），由于 Cost 逻辑中包含了 CheckSubGroup，
		-- 这里只需返回 true（因为 CheckRemoveOverlayCard/Cost 逻辑已保证可行性）。
		-- 但为了严谨，如果 Cost 已经支付（LabelObject 存在），则检查剩余卡池。
		local detached_g=e:GetLabelObject()
		if detached_g then
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
			return g:CheckSubGroup(s.gcheck,3,3,nil,tp,nil,detached_g)
		else
			-- 尚未支付 Cost，由 Cost 函数负责检查可行性
			return true
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local detached_g=e:GetLabelObject()
	if not detached_g then return end
	
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,s.gcheck,false,3,3,nil,tp,nil,detached_g)
	
	if sg and sg:GetCount()==3 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			sg:RemoveCard(tc)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
	detached_g:DeleteGroup()
end