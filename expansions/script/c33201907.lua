--特诺奇的神庙司祭
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--xyz summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetLabel(0)
	e0:SetCondition(s.XyzCondition(s.xyzf,6,3,3))
	e0:SetTarget(s.XyzTarget(s.xyzf,6,3,3))
	e0:SetOperation(s.XyzOperation(s.xyzf,6,3,3))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
-- ①：超量召唤成功的场合，选最多素材数量的对方场上的卡除外
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	-- 注意：这里不需要写 CountLimit，因为文本里没写①效果1回合1次
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)

	-- ②：二速拔素材复活本家，之后可选“二速超量”或“补充素材”
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id) -- 这个卡名的②效果1回合只能使用1次
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- ===========================
-- 自定义超量召唤逻辑
-- ===========================
function s.xyzf(c)
	local posck=true
	if c:IsLocation(LOCATION_ONFIELD) and not c:IsFaceup() then posck=false end
	return c:IsLevel(6) and c:IsSetCard(0x5328) and posck
end
function s.dmatfilter(c)
	return c:IsSetCard(0x5328) and c:IsLevel(6)
end
function s.XyzCondition(f,lv,minct,maxct)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				local tp=c:GetControler()
				local mg=nil
				local ogck=true
				if og then
					mg=og
					if #mg~=#mg:Filter(s.xyzf,nil) or #mg>3 then ogck=false end
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local minc=minct
				local maxc=maxct
				if min then 
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local dg=Duel.GetMatchingGroup(s.dmatfilter,tp,LOCATION_DECK,0,nil)
				---oup.Merge(mg,dg)
				return ogck and (Duel.CheckXyzMaterial(c,f,6,minc,maxc,mg) or (Duel.CheckXyzMaterial(c,f,6,minc-1,maxc,mg) and dg:GetCount()>0))
			end
end

function s.XyzTarget(f,lv,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local dg=Duel.GetMatchingGroup(s.dmatfilter,tp,LOCATION_DECK,0,nil,c)
				local g=nil
				g=Duel.SelectXyzMaterial(tp,c,f,6,minc-1,maxc,mg)
				if g and g:GetCount()<3 and #dg>0 then 
					sdg=Duel.SelectXyzMaterial(tp,c,f,6,1,1,dg) 
					if sdg then Group.Merge(g,sdg) else return false end
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function s.XyzOperation(f,lv,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
-- ===========================effect xyz check==========================
					local sdg=Group.CreateGroup()
					local sg=og:Clone()
					local g=sg:Filter(Auxiliary.Xyz2XMaterialEffectFilter,nil,c,nil,nil,tp,true)
					if #g==0 and #sg==2 then 
						local dg=Duel.GetMatchingGroup(s.dmatfilter,tp,LOCATION_DECK,0,nil)
						sdg=Duel.SelectXyzMaterial(tp,c,f,6,1,1,dg)
					else
						while #sg<minct do
							if #g>1 then
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
								g=g:Select(tp,1,1,nil)
							end
							local tc=g:GetFirst()
							local te=tc:IsHasEffect(EFFECT_DOUBLE_XMATERIAL,tp)
							Duel.Hint(HINT_CARD,0,tc:GetCode())
							te:UseCountLimit(tp)
							sg:RemoveCard(tc)
							minct=minct-2
						end
					end
-- ===========================effect xyz check==========================

					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					local ovg=og:Clone()
					if sdg then ovg:AddCard(sdg:GetFirst()) end
					c:SetMaterial(ovg)
					Duel.Overlay(c,ovg)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
-- ===========================effect xyz check==========================
						local sdg=Group.CreateGroup()
						local sg=mg:Clone()
						local g=sg:Filter(Auxiliary.Xyz2XMaterialEffectFilter,nil,c,nil,nil,tp,true)
						if not #g==0 then 
							while #sg<minct do
								if #g>1 then
									Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
									g=g:Select(tp,1,1,nil)
								end
								local tc=g:GetFirst()
								local te=tc:IsHasEffect(EFFECT_DOUBLE_XMATERIAL,tp)
								Duel.Hint(HINT_CARD,0,tc:GetCode())
								te:UseCountLimit(tp)
								sg:RemoveCard(tc)
								minct=minct-2
							end
						end
-- ===========================effect xyz check==========================
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end


-- ==================== ①效果：不取对象动态除外 ====================
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetOverlayCount()>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	-- 动态声明除外数量的上限，方便系统预判
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 确保效果处理时这张卡还在场上且拥有素材
	if not c:IsRelateToEffect(e) or c:GetOverlayCount()==0 then return end
	
	local ct=c:GetOverlayCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	-- 从对方场上“选”（不取对象）1 到 ct（素材数量）张卡
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

-- ==================== ②效果：复活与二选一后续 ====================
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5328) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

-- 后续效果的合法性判定函数
function s.xyzfilter(c,mg)
	-- 判定是否能用当前场上的怪兽超量召唤
	return c:IsXyzSummonable(nil,mg)
end
function s.matxyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.matgyfilter(c)
	return c:IsType(TYPE_MONSTER)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	-- 步骤1：如果目标还在墓地，则特殊召唤
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		
		-- 步骤2：那之后，预判后续两个选项是否满足条件
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		
		-- 选项A：能否进行超量召唤
		local b1 = Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
		-- 选项B：场上是否有超量怪兽，且墓地是否有怪兽可以作为素材
		local b2 = Duel.IsExistingMatchingCard(s.matxyzfilter,tp,LOCATION_MZONE,0,1,nil)
				and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.matgyfilter),tp,LOCATION_GRAVE,0,1,nil)
		
		-- 如果两个都不满足，直接终止效果
		if not (b1 or b2) then return end
		
		-- 由于是“可以”，需要询问玩家是否发动后续效果
		if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
		Duel.BreakEffect()
		
		-- 让玩家在满足条件的选项中做出选择
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(id,3))
		else
			op=Duel.SelectOption(tp,aux.Stringid(id,4))+1
		end
		
		-- 执行选项A：进行超量召唤
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyzg=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
			local xyzc=xyzg:GetFirst()
			if xyzc then
				Duel.XyzSummon(tp,xyzc,nil,mg)
			end
			
		-- 执行选项B：补充超量素材
		elseif op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			-- 选自己场上1只超量怪兽
			local xyz_tc=Duel.SelectMatchingCard(tp,s.matxyzfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			if xyz_tc then
				Duel.HintSelection(Group.FromCards(xyz_tc))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				-- 选自己墓地1只怪兽（加入王家谷判定以防报错）
				local mat_tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.matgyfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
				if mat_tc then
					Duel.Overlay(xyz_tc,mat_tc)
				end
			end
		end
	end
end