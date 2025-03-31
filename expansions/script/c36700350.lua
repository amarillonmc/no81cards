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
--昂热 火之晨曦
--aux.Stringid(id,0)="亚特坎长刀·折刀装备"
--aux.Stringid(id,1)="放置火之晨曦魔法陷阱卡"
--aux.Stringid(id,2)="对方怪兽变成龙族并在回合结束时复活"
--aux.Stringid(id,3)="向守备表示怪兽攻击造成伤害并破坏"
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	
	--使用魔法陷阱卡作为连接素材
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.LinkCondition(s.matfilter,3,4,s.lcheck))
	e1:SetTarget(s.LinkTarget(s.matfilter,3,4,s.lcheck))
	e1:SetOperation(s.LinkOperation(s.matfilter,3,4,s.lcheck))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	
	--特召成功效果-创建装备
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	
	--放置火之晨曦魔法陷阱卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
	
	--离场时对方怪兽变龙族并在回合结束时复活
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.dragoncon)
	e4:SetTarget(s.dragontg)
	e4:SetOperation(s.dragonop)
	c:RegisterEffect(e4)
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

--装备目标
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

--装备操作 - 创建亚特坎长刀·折刀
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	local token=Duel.CreateToken(tp,36700354) -- 亚特坎长刀·折刀
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
			--装备效果 - 可以攻击全部怪兽
			local e2=Effect.CreateEffect(token)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_ATTACK_ALL)
			e2:SetValue(1)
			token:RegisterEffect(e2)
			
			--装备效果 - 对方怪兽变成守备表示
			local e3=Effect.CreateEffect(token)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_SET_POSITION)
			e3:SetRange(LOCATION_SZONE)
			e3:SetTargetRange(0,LOCATION_MZONE)
			e3:SetCondition(s.poscon)
			e3:SetTarget(aux.TRUE)
			e3:SetValue(POS_FACEUP_DEFENSE)
			token:RegisterEffect(e3)
			
			--装备效果 - 无法变守备表示的怪兽送去墓地
			local e4=Effect.CreateEffect(token)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetRange(LOCATION_SZONE)
			e4:SetCode(EVENT_ADJUST)
			e4:SetCondition(s.poscon)
			e4:SetOperation(s.desop2)
			token:RegisterEffect(e4)
			
			--攻击守备表示怪兽时效果
			local e5=Effect.CreateEffect(token)
			e5:SetDescription(aux.Stringid(id,3))
			e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e5:SetCode(EVENT_BATTLE_START)
			e5:SetRange(LOCATION_SZONE)
			e5:SetCondition(s.dmgcon)
			e5:SetTarget(s.dmgtg)
			e5:SetOperation(s.dmgop)
			token:RegisterEffect(e5)
		end
	end
end

--战斗阶段条件
function s.poscon(e)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end

--无法变守备表示的怪兽送去墓地
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c) return c:IsControler(1-tp) and not c:IsCanChangePosition() end,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE)
	end
end

--攻击守备表示怪兽条件
function s.dmgcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=Duel.GetAttackTarget()
	return Duel.GetAttacker()==ec and tc and tc:IsDefensePos()
end

--攻击守备表示怪兽目标
function s.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,Duel.GetAttackTarget(),1,0,0)
end

--攻击守备表示怪兽操作
function s.dmgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	local tc=Duel.GetAttackTarget()
	if tc and tc:IsRelateToBattle() then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

--放置火之晨曦魔法陷阱卡过滤器
function s.setfilter(c)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsSSetable() or (c:IsType(TYPE_CONTINUOUS) and c:IsSSetable(true)))
end

--放置火之晨曦魔法陷阱卡目标
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end

--放置火之晨曦魔法陷阱卡操作
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not tc then return end
	
	-- 永续魔法/陷阱可以选择明置放置
	if tc:IsType(TYPE_CONTINUOUS) and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.SSet(tp,tc)
	end
	
	-- 盖放的回合也能发动
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	tc:RegisterEffect(e2)
end

--离场触发条件
function s.dragoncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
		and c:IsReason(REASON_EFFECT) and rp==1-tp
end

--龙族变身目标
function s.dragontg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(Duel.GetTurnCount())
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

--龙族变身操作
function s.dragonop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 对方怪兽变成龙族
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_DRAGON)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	
	-- 回合结束时特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	e2:SetLabel(e:GetLabel())
	e2:SetLabelObject(c)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

--回合结束特召条件
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local turn=e:GetLabel()
	return Duel.GetTurnCount()==turn and tc:GetFlagEffect(id)>0
		and tc:GetLocation()~=LOCATION_EXTRA and tc:IsFaceupEx()
end

--回合结束特召操作
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,id)
	if tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		tc:ResetFlagEffect(id)
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
