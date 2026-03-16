local s,id=GetID()

function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	--xyz summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetLabel(0)
	e0:SetCondition(s.XyzCondition(s.xyzf,4,2,2))
	e0:SetTarget(s.XyzTarget(s.xyzf,4,2,2))
	e0:SetOperation(s.XyzOperation(s.xyzf,4,2,2))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)

	-- ①：拔除1个超量素材，攻击力上升500
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION) -- 文本未写二速时点，默认为自己主阶段的起动效果
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.atkcost)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)

	-- ②：因战斗·效果以外送去墓地的场合，赋予本家怪兽2次攻击
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) -- 场合型诱发 + 取对象
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id) -- 这个卡名的②效果1回合只能使用1次
	e2:SetCondition(s.gycon)
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
	return c:IsLevel(4) and c:IsSetCard(0x5328) and posck
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
					if #mg~=#mg:Filter(s.xyzf,nil) or #mg>2 then ogck=false end
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
				if g and g:GetCount()<2 and #dg>0 then 
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
					if #g==0 and #sg==1 then 
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

-- ==================== ①效果：提升攻击力 ====================
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 判断这张卡在效果处理时是否还在场上表侧表示
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		-- 永久上升500攻击力（直到离场或被无效）
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

-- ==================== ②效果：赋予2次攻击 ====================
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 因战斗·效果以外送去墓地（例如：作为超量/连接素材、被解放作为Cost等）
	return not c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_EFFECT)
end
function s.tgfilter(c)
	-- 取对象：自己场上、表侧表示的「特诺奇」怪兽
	return c:IsFaceup() and c:IsSetCard(0x5328)
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc) end
	if chk==0 then return Duel.GetTurnPlayer()==tp and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		-- 赋予在同1次的战斗阶段中可以作2次攻击的状态
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1) -- Value 为“额外”的攻击次数，1 代表额外1次，总共2次
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end