-- 刻刻帝·七之弹（Zayin）
local cm,m,o=GetID()

local F_KKKD=60013040+10000000	-- 「刻刻帝」②的适用次数（场地 6048 与陷阱 6043~6046 共用同一个计数器，锚在 6040 号段）
local F_KDRAW=60013040+20000000	-- 「每3次抽1张」已经抽过的次数（系列共用）

function cm.initial_effect(c)
	-- 卡名记述：「时崎狂三·时崎狂三」
	aux.AddCodeList(c,60013039)
	-- 作为通常魔法发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_REMOVE+CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	-- 这张卡在加入手卡的对方回合也能从手卡发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_REMOVE+CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
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
end

-- 手卡发动的condition：对方回合，且这张卡是这个回合加入手卡的
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and (c:GetTurnID()==Duel.GetTurnCount() or Duel.GetTurnCount()==1)
end
-- 「时崎狂三·时崎狂三」
function cm.affil(c)
	return c:IsCode(60013039)
end
-- 手卡发动处理完后，这张卡从手卡送去墓地（按魔法的用法）
function cm.togy(c)
	if c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function cm.disfil(c)
	return c:IsDiscardable()
end
-- 可选项目
function cm.op1can(tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
end
function cm.op2can(tp,ex)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if ex:IsLocation(LOCATION_HAND) then hg:RemoveCard(ex) end
	return hg:GetCount()>0
		and Duel.IsExistingMatchingCard(cm.negfilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.op3can(tp)
	return Duel.GetLP(tp)>1 and Duel.IsExistingMatchingCard(cm.affil,tp,LOCATION_MZONE,0,1,nil)
end
function cm.negfilter(c)
	return c:IsFaceup()
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
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return cm.op1can(tp) or cm.op2can(tp,c) or cm.op3can(tp)
	end
	if cm.op1can(tp) then Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5) end
	if cm.op2can(tp,c) then Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=cm.selectop(tp,cm.op1can(tp),cm.op2can(tp,c),cm.op3can(tp))
	if op==1 then
		-- ●自己卡组最上面5张卡送去墓地，那之中暗属性以外的怪兽全部除外
		local ct=math.min(5,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
		if ct<=0 then return end
		local g=Duel.GetDecktopGroup(tp,ct)
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT)
		local rg=g:Filter(cm.remfilter,nil)
		if rg:GetCount()>0 then
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	elseif op==2 then
		-- ●丢弃1张手卡，选对方场上1张卡效果无效化
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if c:IsLocation(LOCATION_HAND) then hg:RemoveCard(c) end
		if hg:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local dg=hg:Select(tp,1,1,nil)
		if #dg==0 or Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)==0 then return end
		if not Duel.IsExistingMatchingCard(cm.negfilter,tp,0,LOCATION_ONFIELD,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local ng=Duel.SelectMatchingCard(tp,cm.negfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #ng>0 then
			local tc=ng:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	elseif op==3 then
		-- ●支付一半基本分，这个回合自己场上的狂三攻击力·守备力变为8000
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		local g=Duel.GetMatchingGroup(cm.affil,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(8000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(8000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
	cm.togy(c)
end
-- ●1的filter：送去墓地的卡里，暗属性以外的怪兽
function cm.remfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
		and not c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
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
