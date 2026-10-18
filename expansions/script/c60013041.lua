-- 刻刻帝·四之弹（Dalet）
local cm,m,o=GetID()

-- 计数·标记一律用 m、m+10000000、m+20000000… 的编号规则
local F_REW=m+10000000	-- ●时间回溯：每场决斗1次
local F_SIGN=m+20000000	-- 本回合结束阶段是否已经记录过
local F_LIM=m+30000000	-- 记录器的次数限制code
local F_KKKD=60013040+10000000	-- 「刻刻帝」②的适用次数（场地 6048 与陷阱 6043~6046 共用同一个计数器，锚在 6040 号段）
local F_KDRAW=60013040+20000000	-- 「每3次抽1张」已经抽过的次数（系列共用）
local SignTurn=0	-- Lua 侧兜底：本回合是否已经记录过

-- 记录自己回合结束时的场面（参考「罗塔花园广场」的记录方式）
Rewind=Rewind or {}
Rewind.data={}

function cm.initial_effect(c)
	-- 卡名记述：「时崎狂三·时崎狂三」
	aux.AddCodeList(c,60013039)
	-- 作为通常魔法发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	-- 这张卡在加入手卡的对方回合也能从手卡发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.handcon)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)

	-- ②：双方的回合结束阶段发动。墓地的这张卡回到卡组
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)	-- 结束阶段的效果必须限次，否则会在结束阶段反复诱发
	e3:SetRange(LOCATION_GRAVE)
	e3:SetOperation(cm.gyop)
	c:RegisterEffect(e3)

	-- 记录：每次自己的回合结束时记录一次（全场共用，只注册一次）
	if not Rewind.check then
		Rewind.check=true
		for p=0,1 do
			local ge=Effect.CreateEffect(c)
			ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge:SetCode(EVENT_PHASE+PHASE_END)
			ge:SetCountLimit(1,F_LIM)	-- 强制限次：每回合最多执行1次，避免结束阶段反复触发卡死
			ge:SetOperation(cm.signop)
			Duel.RegisterEffect(ge,p)
		end
	end
end

-- 记录操作：只有「自己的回合」的结束阶段才记录，且每个结束阶段只记录一次
function cm.signop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	-- 同一回合只记一次：flag + Lua 双保险，防止结束阶段被反复触发卡死
	if SignTurn==Duel.GetTurnCount() then return end
	SignTurn=Duel.GetTurnCount()
	if Duel.GetFlagEffect(p,F_SIGN)==0 then
		Duel.RegisterFlagEffect(p,F_SIGN,RESET_PHASE+PHASE_END,1,1)
	end
	cm.ReSign(p)
end
-- 记录：双方手卡·场上·墓地·除外（「时崎狂三·时崎狂三」与衍生物除外）
function cm.rewfil(c)
	return not c:IsCode(60013039) and not c:IsType(TYPE_TOKEN)
end
function cm.ReSign(tp)
	local d={hand={},mz={},sz={},gy={},rem={},lp={Duel.GetLP(0),Duel.GetLP(1)}}
	local g=Duel.GetMatchingGroup(cm.rewfil,tp,LOCATION_HAND,LOCATION_HAND,nil)
	for tc in aux.Next(g) do
		table.insert(d.hand,{c=tc})
	end
	g=Duel.GetMatchingGroup(cm.rewfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		table.insert(d.mz,{c=tc,p=tc:GetPosition(),cp=tc:GetControler()})
	end
	g=Duel.GetMatchingGroup(cm.rewfil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	for tc in aux.Next(g) do
		table.insert(d.sz,{c=tc,p=tc:GetPosition(),cp=tc:GetControler()})
	end
	g=Duel.GetMatchingGroup(cm.rewfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	for tc in aux.Next(g) do
		table.insert(d.gy,{c=tc})
	end
	g=Duel.GetMatchingGroup(cm.rewfil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	for tc in aux.Next(g) do
		table.insert(d.rem,{c=tc})
	end
	Rewind.data[tp]=d
end
-- 回溯：把记录过的卡送回记录的区域
function cm.ReMake(e,tp)
	local d=Rewind.data[tp]
	if not d then return end
	-- 手卡
	for _,v in ipairs(d.hand) do
		local tc=v.c
		if not tc:IsLocation(LOCATION_HAND) and tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
	-- 怪兽区
	for _,v in ipairs(d.mz) do
		local tc=v.c
		if not tc:IsLocation(LOCATION_MZONE) then
			local pos=POS_FACEUP_ATTACK
			if v.p==POS_FACEUP_DEFENSE then pos=POS_FACEUP_DEFENSE end
			if tc:IsCanBeSpecialSummoned(e,0,v.cp,false,false) then
				Duel.SpecialSummon(tc,0,v.cp,v.cp,false,false,pos)
			end
		end
	end
	-- 魔法陷阱区
	for _,v in ipairs(d.sz) do
		local tc=v.c
		if not tc:IsLocation(LOCATION_SZONE) then
			local pos=POS_FACEUP
			if v.p==POS_FACEDOWN or v.p==POS_FACEDOWN_DEFENSE then pos=POS_FACEDOWN end
			Duel.MoveToField(tc,v.cp,v.cp,LOCATION_SZONE,pos,true)
		end
	end
	-- 墓地
	for _,v in ipairs(d.gy) do
		local tc=v.c
		if not tc:IsLocation(LOCATION_GRAVE) and tc:IsAbleToGrave() then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
	-- 除外
	for _,v in ipairs(d.rem) do
		local tc=v.c
		if not tc:IsLocation(LOCATION_REMOVED) and tc:IsAbleToRemove() then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end

-- 手卡发动的condition：对方回合，且这张卡是这个回合加入手卡的
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and (c:GetTurnID()==Duel.GetTurnCount() or Duel.GetTurnCount()==1)
end
-- 选1项（只列出能适用的项）
function cm.selectop(tp,b1,b2,b3)
	local t={}
	if b1 then table.insert(t,1) end
	if b2 then table.insert(t,2) end
	if b3 then table.insert(t,3) end
	if #t==0 then return 0 end
	if #t==1 then return t[1] end
	local s={}
	for i=1,#t do s[i]=aux.Stringid(m,t[i]-1) end
	return t[Duel.SelectOption(tp,table.unpack(s))+1]
end
-- 手卡发动处理完后，这张卡从手卡送去墓地（按魔法的用法）
function cm.togy(c)
	if c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function cm.handcount(tp,c)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if c:IsLocation(LOCATION_HAND) then g:RemoveCard(c) end
	return g:GetCount()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return (Rewind.data[tp]~=nil and Duel.GetFlagEffect(tp,F_REW)==0)
			or Rewind.data[tp]~=nil
			or cm.handcount(tp,e:GetHandler())>0
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Rewind.data[tp]
	local b1=d~=nil and Duel.GetFlagEffect(tp,F_REW)==0
	local b2=d~=nil
	local b3=cm.handcount(tp,c)>0
	local op=cm.selectop(tp,b1,b2,b3)
	if op==1 then
		-- ●时间回溯：把双方的卡送回自己上个回合结束阶段的位置（每场决斗限1次）
		Duel.RegisterFlagEffect(tp,F_REW,0,0,1)
		cm.ReMake(e,tp)
	elseif op==2 then
		-- ●双方的基本分变为自己上个回合结束时的数值
		if d and d.lp then
			Duel.SetLP(0,d.lp[1])
			Duel.SetLP(1,d.lp[2])
		end
	elseif op==3 then
		-- ●自己的手卡全部回到卡组，抽那个回到卡组数量的卡
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if c:IsLocation(LOCATION_HAND) then g:RemoveCard(c) end
		if g:GetCount()>0 then
			local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			if ct>0 and Duel.IsPlayerCanDraw(tp,ct) then
				Duel.Draw(tp,ct,REASON_EFFECT)
			end
		end
	end
	cm.togy(c)
end
-- ②：墓地的这张卡回到卡组；自己每3次把「刻刻帝」的②的效果适用，可以抽1张
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_GRAVE) then return end
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	-- 「刻刻帝」②的适用次数：全系列（子弹·场地·陷阱）共用同一个计数器
	local ap=Duel.GetFlagEffect(tp,F_KKKD)+1
	Duel.RegisterFlagEffect(tp,F_KKKD,0,0,1)
	-- 每满3次可以抽1张（已抽过的次数用 F_KDRAW 记录，避免重复抽）
	local dr=Duel.GetFlagEffect(tp,F_KDRAW)
	if ap-dr*3>=3 and Duel.IsPlayerCanDraw(tp,1) then
		if Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.RegisterFlagEffect(tp,F_KDRAW,0,0,1)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
