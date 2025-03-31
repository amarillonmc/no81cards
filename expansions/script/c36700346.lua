--[[
本lua的作者为藜奴儿，如果测试出bug请联系QQ：1502939196

未经允许不支持任何人的任何形式的修改，源数。如有需要请联系作者，而不是私自找人代为修改。
本人对于本lua的任何bug修改、源数和适配后来卡片均为免费，并且追诉期无限。

但是如果使用者私自修改了lua，不论是bug修复还是源数效果，本人对此lua都不会再提供任何形式的支持。
一旦发现任何其他人对本lua进行了任何形式的修改，本人首先自愿放弃此lua除必要署名权以外的所有权利，
同时再也会不承担对此lua的任何维护与后续适配，包括但不限于任何形式的bug修复、效果源数。

如果您想要修改此lua，可以先联系本人，本人会在第一时间进行回复。
并且我承诺，若本人在2天内没有回复您，上述注意事项可作废，您可以直接修改此lua，而后续debug与适配仍然由我来进行。

如果您对本lua有任何疑问，请联系本人，本人会在第一时间进行回复。
如果您对本lua有任何建议，请联系本人，本人会在第一时间进行处理。
]]
--恺撒·加图索
--aux.Stringid(id,0)="墓地装备"
--aux.Stringid(id,1)="送去墓地无效效果"
local s,id,o=GetID()
function s.initial_effect(c)
	-- 添加关联卡号
	aux.AddCodeList(c,36700306) -- 恺撒 火之晨曦
	
	--link summon
	c:EnableReviveLimit()
	
	--使用魔法陷阱卡作为连接素材
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.LinkCondition(s.matfilter,2,3,s.lcheck))
	e1:SetTarget(s.LinkTarget(s.matfilter,2,3,s.lcheck))
	e1:SetOperation(s.LinkOperation(s.matfilter,2,3,s.lcheck))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	
	--视为「恺撒 火之晨曦」
	aux.EnableChangeCode(c,36700304,LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE)
	
	--Equip from grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.eqcon)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	
	--不入连锁无效魔法陷阱效果
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.negcon)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
	s.effect_2=e2
end

--素材过滤器（允许使用魔法陷阱卡）
function s.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_MONSTER) or (c:IsSetCard(0xc50) and c:IsType(TYPE_SPELL+TYPE_TRAP))
end

--连接素材检查（需要包含战士族·炎属性怪兽）
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(s.filter,1,nil)
end

function s.filter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)
end	

--装备条件
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end

--装备目标过滤器
function s.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50)
end

--装备目标
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

--装备操作
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		if not Duel.Equip(tp,c,tc) then return end
		--增加守备力
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(1200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		--装备限制
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(s.eqlimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end

--装备限制条件
function s.eqlimit(e,c)
	return c:IsSetCard(0xc50)
end

--无效魔法陷阱效果条件
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
end

--无效魔法陷阱效果操作
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAbleToGrave() then return end
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_CARD,0,id)
		if Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
			local rc=re:GetHandler()
			if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) then
				Duel.Destroy(rc,REASON_EFFECT)
			end
		end
	end
end

function s.LinkCondition(f,minct,maxct,gf)
	return	function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
					local mgs=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_ONFIELD,0,nil)
					mg:Merge(mgs)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end

function s.LinkTarget(f,minct,maxct,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
					local mgs=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_ONFIELD,0,nil)
					mg:Merge(mgs)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end

function s.LinkOperation(f,minct,maxct,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Auxiliary.LExtraMaterialCount(g,c,tp)
				s.SzoneExtraMaterial(g,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end

function s.SzoneExtraMaterial(mg,tp)
	for tc in Auxiliary.Next(mg) do
		if tc:IsLocation(LOCATION_SZONE) and tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
