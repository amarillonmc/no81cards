--特诺奇的御兽师
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
	e0:SetCondition(s.XyzCondition(s.xyzf,4,3,3))
	e0:SetTarget(s.XyzTarget(s.xyzf,4,3,3))
	e0:SetOperation(s.XyzOperation(s.xyzf,4,3,3))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
-- ①：二速解放自身，给与1200伤害，下个准备阶段特召墓地本家
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.damcost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)

	-- ②：因战斗·效果以外送去墓地的场合，丢弃1手卡炸卡并可能抽卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1) -- 这个卡名的②效果1回合只能使用1次
	e2:SetCondition(s.gycon)
	e2:SetCost(s.gycost)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end

-- ===========================
-- 自定义超量召唤逻辑
-- ===========================
function s.xyzf(c)
	local posck=true
	if c:IsLocation(LOCATION_ONFIELD) and not c:IsFaceup() then posck=false end
	return c:IsLevel(4) and posck
end
function s.dmatfilter(c)
	return c:IsSetCard(0x5328) and c:IsLevel(4)
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
				return ogck and (Duel.CheckXyzMaterial(c,f,4,minc,maxc,mg) or (Duel.CheckXyzMaterial(c,f,4,minc-1,maxc,mg) and dg:GetCount()>0))
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
				g=Duel.SelectXyzMaterial(tp,c,f,4,minc-1,maxc,mg)
				if g and g:GetCount()<3 and #dg>0 then 
					sdg=Duel.SelectXyzMaterial(tp,c,f,4,1,1,dg) 
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
						sdg=Duel.SelectXyzMaterial(tp,c,f,4,1,1,dg)
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

-- ==================== ①效果：削血与延迟苏生 ====================
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	-- 解放这张卡作为Cost
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- 设定目标为对方玩家，伤害值为1200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)>0 then
		-- 伤害给与成功后，注册“下个回合的准备阶段”的延迟效果
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		-- 记录当前回合数，确保是在“下个”回合触发
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(s.spcon_delay)
		e1:SetOperation(s.spop_delay)
		-- 重置条件设为经过2次准备阶段自动注销，以防卡顿
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.spcon_delay(e,tp,eg,ep,ev,re,r,rp)
	-- 只有当回合数不等于发动时的回合数时，才代表来到了“下个回合”
	return Duel.GetTurnCount()~=e:GetLabel()
end
function s.spfilter_delay(c,e,tp)
	return c:IsSetCard(0x5328) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop_delay(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id) -- 提示玩家这是由于这张卡的延迟效果触发的
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter_delay),tp,LOCATION_GRAVE,0,nil,e,tp)
	-- 文本描述为必发效果，不需要 SelectYesNo
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	e:Reset() -- 执行完毕后立刻注销该效果
end

-- ==================== ②效果：非战斗·效果送墓的炸卡与抽卡 ====================
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- “因战斗·效果以外”在底层逻辑中表现为：不是因为战斗送墓，且不是因为卡片效果送墓。
	-- (这包含了作为代价解放、作为超量/连接/同调素材等情况)
	return not c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_EFFECT)
end
function s.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	
	-- 在将卡丢弃前，检查它是否为「特诺奇」卡，并使用 Label 暂存结果
	local tc=g:GetFirst()
	if tc:IsSetCard(0x5328) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	-- “选”表示不取对象
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	-- 选对方场上1张卡破坏
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		-- 破坏成功后，那之后：判断刚才当做Cost丢掉的卡是不是本家
		if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1) then
			Duel.BreakEffect() -- 由于是“那之后”，这里需要插入效果断点
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
