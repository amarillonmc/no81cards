--蓝色链接
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimitTillChainEnd(cm.chlimit)
	end
end
-- 提取双方场上处于连接状态的怪兽（对方怪兽需要满足不受此卡效果免疫）
function cm.matfilter(c,e,tp)
	return c:IsFaceup() and c:IsLinkState() and (c:IsControler(tp) or not c:IsImmuneToEffect(e))
end

-- 限定该额外链接素材的效果只对挂载了此效果的那只额外卡组怪兽生效
function cm.matval(e,lc,mg,c,tp)
	if lc~=e:GetHandler() then return false,nil end
	return true,true
end

-- 检查挂载了额外素材权限后，能否合法进行连接召唤
function cm.slfilter(c,mg,e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(function(ef,tc) return cm.matfilter(tc,e,tp) end)
	e1:SetValue(cm.matval)
	c:RegisterEffect(e1,true)
	
	local res=c:IsLinkSummonable(mg)
	
	e1:Reset()
	return res
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.slfilter,tp,LOCATION_EXTRA,0,1,nil,mg,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.slfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg,e,tp)
	local sc=tg:GetFirst()
	if sc then
		-- 为选中的怪兽临时注册对方场上的合法选材权限
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(function(ef,tc) return cm.matfilter(tc,e,tp) end)
		e1:SetValue(cm.matval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1,true)

		-- 拦截送墓动作
		local _SendToGrave=Duel.SendtoGrave
		Duel.SendtoGrave=function(g,r)
			if r==REASON_MATERIAL+REASON_LINK and #g>0 and Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_LINK+REASON_TEMPORARY)>0 then
				local fid=sc:GetFieldID()
				local og=Duel.GetOperatedGroup():Filter(cm.rffilter,nil)
				for oc in aux.Next(og) do
					oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				end
				og:KeepAlive()
				
				-- 注册延后返回
				local e2=Effect.CreateEffect(sc)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetCountLimit(1)
				e2:SetLabel(fid)
				e2:SetLabelObject(og)
				e2:SetCondition(cm.retcon)
				e2:SetOperation(cm.retop)
				Duel.RegisterEffect(e2,tp)
				
				Duel.SendtoGrave=_SendToGrave
				return #og
			else
				return _SendToGrave(g,r)
			end
		end
		
		-- 执行连接召唤（引擎会自动使用赋予的权限跨场吃怪）
		Duel.LinkSummon(tp,sc,mg)
	end
end

function cm.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end

function cm.retfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end

function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end

function cm.retfilter2(c,p,loc)
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
end

function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	-- 每次结束阶段进行询问，选“是”才处理返回并消除效果，选“否”则保留到下个结束阶段
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local g=e:GetLabelObject()
		local sg=g:Filter(cm.retfilter,nil,e:GetLabel())
		g:DeleteGroup()
		
		local ft,mg2,ng={},{},Group.CreateGroup()
		ft[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)
		ft[2]=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		ft[3]=Duel.GetLocationCount(tp,LOCATION_SZONE)
		ft[4]=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
		mg2[1]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_MZONE)
		mg2[2]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_MZONE)
		mg2[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_SZONE)
		mg2[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_SZONE)
		
		for i=1,4 do
			if #mg2[i]>ft[i] then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
				local tg=mg2[i]:Select(tp,ft[i],ft[i],nil)
				local rg=mg2[i]-tg
				sg:Sub(rg)
				ng:Merge(rg)
			end
		end
		
		for tc in aux.Next(sg) do
			if tc:GetPreviousLocation()&LOCATION_ONFIELD>0 then
				Duel.ReturnToField(tc)
			elseif tc:IsPreviousLocation(LOCATION_HAND) then
				Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
			end
		end
		
		Duel.SendtoGrave(ng,REASON_RULE+REASON_RETURN)
		e:Reset()
	end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end