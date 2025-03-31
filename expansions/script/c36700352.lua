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
--路明非·七宗罪
--aux.Stringid(id,0)="七宗罪·色欲装备"
--aux.Stringid(id,1)="The Gathering言灵效果"
--aux.Stringid(id,2)="选择对方效果怪兽无效并破坏"
local s,id,o=GetID()
function s.initial_effect(c)
	-- 添加关联卡号
	aux.AddCodeList(c,36700304,36700342,36700302) -- 路明非 火之晨曦、陈墨瞳 火之晨曦、路鸣泽 setcode
	
	--link summon
	c:EnableReviveLimit()
	
	--使用魔法陷阱卡作为连接素材
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.LinkCondition(s.matfilter,3,6,s.lcheck))
	e1:SetTarget(s.LinkTarget(s.matfilter,3,6,s.lcheck))
	e1:SetOperation(s.LinkOperation(s.matfilter,3,6,s.lcheck))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	
	--需要陈墨瞳在墓地才能特召
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(s.splimit)
	c:RegisterEffect(e2)
	
	--视为「路明非 火之晨曦」
	aux.EnableChangeCode(c,36700304,LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE)
	
	--特召成功效果-创建装备
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
	
	--The Gathering言灵效果
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.gathering_tg)
	e4:SetOperation(s.gathering_op)
	c:RegisterEffect(e4)
	
	--保护魔法陷阱区域的卡
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_FACEUP))
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(aux.indoval)
	c:RegisterEffect(e6)
end

--墓地陈墨瞳检查
function s.splimit(e,se,sp,st)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,36700302)
end

--素材过滤器（允许使用魔法陷阱卡）
function s.matfilter(c)
	return (c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE))
	or (c:IsSetCard(0xc50) and c:IsType(TYPE_SPELL+TYPE_TRAP))
end

--连接素材检查（需要包含战士族·炎属性怪兽）
function s.lcheck(g)
	return g:IsExists(s.cdfilter,1,nil) and aux.dncheck(g)
end

function s.cdfilter(c)
	return c:IsCode(36700342)
end	

--装备目标
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

--装备操作 - 创建色欲衍生物
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	local token=Duel.CreateToken(tp,id+1) -- 七宗罪·色欲衍生物
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		token:CancelToGrave()
		local e1_1=Effect.CreateEffect(token)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CHANGE_TYPE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
		e1_1:SetReset(RESET_EVENT+0x1fc0000)
		token:RegisterEffect(e1_1,true)
		local e1_2=Effect.CreateEffect(token)
		e1_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2:SetCode(EFFECT_EQUIP_LIMIT)
		e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_2:SetValue(1)
		token:RegisterEffect(e1_2,true)
		token:CancelToGrave()
		if Duel.Equip(tp,token,c,false) then

			--装备效果 - 保护火之晨曦怪兽
			local e2=Effect.CreateEffect(token)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetRange(LOCATION_SZONE)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc50))
			e2:SetValue(aux.tgoval)
			token:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e3:SetValue(aux.indoval)
			token:RegisterEffect(e3)
			
			--装备效果 - 相同纵列的对方卡无效
			local e4=Effect.CreateEffect(token)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetRange(LOCATION_SZONE)
			e4:SetTargetRange(0,LOCATION_ONFIELD)
			e4:SetTarget(s.distg)
			token:RegisterEffect(e4)
			
			--装备效果 - 无效并破坏对方效果怪兽
			local e5=Effect.CreateEffect(token)
			e5:SetDescription(aux.Stringid(id,2))
			e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
			e5:SetType(EFFECT_TYPE_QUICK_O)
			e5:SetCode(EVENT_FREE_CHAIN)
			e5:SetRange(LOCATION_SZONE)
			e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e5:SetCountLimit(1)
			e5:SetTarget(s.destg)
			e5:SetOperation(s.desop)
			token:RegisterEffect(e5)
		end
	
	end
end

--装备限制
function s.eqlimit(e,c)
	return c==e:GetOwner()
end

--相同纵列无效目标
function s.distg(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	if not ec or c:GetControler()==e:GetHandlerPlayer() then return false end
	local ecg=ec:GetColumnGroup()
	return ecg:IsContains(c)
end

--选择对方效果怪兽
function s.negfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and aux.NegateEffectMonsterFilter(c)
end

--破坏对方效果怪兽目标
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and aux.NegateEffectMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end

--破坏对方效果怪兽操作
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local token=e:GetHandler()
	if not token:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT)
		
		-- 无效化同名怪兽
		local e3=Effect.CreateEffect(token)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetTargetRange(0xff,0xff)
		e3:SetTarget(s.distg2)
		e3:SetLabel(code)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		Duel.RegisterEffect(e4,tp)
	end
end

--同名怪兽无效
function s.distg2(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end

--The Gathering言灵效果目标
function s.yanlingfilter(c)
	return c:IsSetCard(0xc52) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function s.gathering_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
	-- 宣言卡名
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	-- 宣言卡名 (使用逆波兰表达式正确过滤言灵卡片)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local announce_filter={0xc52,OPCODE_ISSETCARD,TYPE_SPELL+TYPE_TRAP,OPCODE_ISTYPE,OPCODE_AND}
	local code=Duel.AnnounceCard(tp,table.unpack(announce_filter))
	Duel.SetTargetParam(code)
	e:SetLabel(code)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end

--The Gathering言灵效果操作
function s.gathering_op(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	-- 尝试找到宣言的卡
	local tc=Duel.CreateToken(tp,code)
	if tc then
		Duel.Hint(HINT_CARD,1-tp,code)
		local te=tc:GetActivateEffect()
		if not te then return end
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
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
