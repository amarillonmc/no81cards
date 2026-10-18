-- 灼红之矢
local cm,m,o=GetID()

-- 计数·标记一律用 m、m+10000000、m+20000000… 的编号规则
local F_LPLIM=m+10000000	-- 记录器的次数限制code
local RecTurn=0		-- Lua 侧兜底：本回合是否已经记录过
cm.LP=cm.LP or {}	-- cm.LP[玩家]={对方LP,自己LP}

-- 内置的「刻刻帝」子弹（场地魔法以外的「刻刻帝」魔法卡）
local B1=60013040	-- 一之弹
local B4=60013041	-- 四之弹
local B8=60013042	-- 八之弹
local B7=60013047	-- 七之弹

function cm.initial_effect(c)
	-- 作为永续魔法发动（没有这条，卡片无法从手卡发动/放置到魔陷区）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- ①：对方把效果发动的场合才能发动（场合类：等那个连锁处理完再另开连锁）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)	-- 场合类效果，不在对方效果发动的时点插连锁
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁上最多1次
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	-- 记录：每个「自己的回合」结束时记录一次双方基本分（全场共用，只注册一次）
	if not cm.lprec then
		cm.lprec=true
		for p=0,1 do
			local ge=Effect.CreateEffect(c)
			ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge:SetCode(EVENT_PHASE+PHASE_END)
			ge:SetCountLimit(1,F_LPLIM+p)	-- 强制限次，避免结束阶段反复触发
			ge:SetOperation(cm.lprecop)
			Duel.RegisterEffect(ge,p)
		end
	end
end

-- ①的condition：对方把效果发动
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
-- ①的cost：丢弃1张手卡
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
-- ①的filter：场地魔法以外的「刻刻帝」魔法卡
function cm.bltfilter(c)
	if not c:IsType(TYPE_SPELL) or c:IsType(TYPE_FIELD) then return false end
	return c:IsCode(B1) or c:IsCode(B4) or c:IsCode(B8) or c:IsCode(B7)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.bltfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
-- ①的operation：从卡组选1张子弹送去墓地，那之后可以适用那张卡发动时的效果
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.bltfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local code=tc:GetCode()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	cm.Apply(e,tp,code)
end

-- 分配：按送墓的子弹种类，适用对应的「发动时的效果」
function cm.Apply(e,tp,code)
	if code==B1 then
		cm.b1(e,tp)
	elseif code==B4 then
		cm.b4(e,tp)
	elseif code==B8 then
		cm.b8(e,tp)
	elseif code==B7 then
		cm.b7(e,tp)
	end
end
-- 选1项（只列出能适用的项；id 用来取那张子弹自己的选项文本）
function cm.selectop(tp,id,bs)
	local t={}
	for i=1,3 do
		if bs[i] then table.insert(t,i) end
	end
	if #t==0 then return 0 end
	if #t==1 then return t[1] end
	local s={}
	for i=1,#t do s[i]=aux.Stringid(id,t[i]-1) end
	return t[Duel.SelectOption(tp,table.unpack(s))+1]
end

-- 通用 filter
function cm.affil(c)
	return c:IsCode(60013039)
end
function cm.spf(c,e,tp)
	return cm.affil(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.mztd(c)
	return cm.affil(c) and c:IsAbleToHand()
end
function cm.handtd(c)
	return cm.affil(c) and c:IsAbleToDeck()
end

------------------------------------------------------------------
-- 一之弹（Aleph）的3个效果
------------------------------------------------------------------
function cm.b1(e,tp)
	local b1=Duel.IsExistingMatchingCard(cm.spf,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.mztd,tp,LOCATION_MZONE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(cm.handtd,tp,LOCATION_HAND,0,1,nil)
	local op=cm.selectop(tp,B1,{b1,b2,b3})
	if op==1 then
		-- ●选自己手卡1只「时崎狂三·时崎狂三」特殊召唤
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spf,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		-- ●选自己场上1只「时崎狂三·时崎狂三」回到手卡，那之后可以抽1张
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.mztd,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(B1,4)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	elseif op==3 then
		-- ●选自己手卡1只「时崎狂三·时崎狂三」回到卡组，那之后可以抽2张
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.handtd,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			if Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(B1,4)) then
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
	end
end

------------------------------------------------------------------
-- 四之弹（Dalet）的3个效果
-- 特殊裁定：「灼红之矢」不能适用第1个效果（时间回溯），所以这里只有2、3
------------------------------------------------------------------
function cm.b4(e,tp)
	local d=cm.LP[tp]
	local b1=false	-- ●时间回溯：不能通过「灼红之矢」适用
	local b2=d~=nil
	local b3=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
	local op=cm.selectop(tp,B4,{b1,b2,b3})
	if op==1 then
		-- 本分支永远不可达（保留位置，方便以后调整裁定）
		return
	elseif op==2 then
		-- ●双方的基本分变为自己上个回合结束时的数值
		if d then
			Duel.SetLP(0,d[1])
			Duel.SetLP(1,d[2])
		end
	elseif op==3 then
		-- ●自己的手卡全部回到卡组，抽那个数量的卡
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if g:GetCount()>0 then
			local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			if ct>0 and Duel.IsPlayerCanDraw(tp,ct) then
				Duel.Draw(tp,ct,REASON_EFFECT)
			end
		end
	end
end
-- 记录自己回合结束时的双方基本分
function cm.lprecop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	if RecTurn==Duel.GetTurnCount() then return end
	RecTurn=Duel.GetTurnCount()
	cm.LP[p]={Duel.GetLP(0),Duel.GetLP(1)}
end

------------------------------------------------------------------
-- 八之弹（Het）的3个效果
------------------------------------------------------------------
function cm.namefilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.samecan(tp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	for tc in aux.Next(g) do
		if Duel.IsExistingMatchingCard(cm.namefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tc:GetCode()) then
			return true
		end
	end
	return false
end
function cm.b8(e,tp)
	local b1=Duel.IsExistingMatchingCard(cm.spf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.affil,tp,LOCATION_MZONE,0,1,nil)
	local b3=cm.samecan(tp)
	local op=cm.selectop(tp,B8,{b1,b2,b3})
	if op==1 then
		-- ●从卡组·墓地把1只「时崎狂三·时崎狂三」特殊召唤
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		-- ●这个回合，自己场上的「时崎狂三·时崎狂三」不受对方发动的效果影响
		local g=Duel.GetMatchingGroup(cm.affil,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetValue(cm.immval)
			tc:RegisterEffect(e1)
		end
	elseif op==3 then
		-- ●选1张手卡给对方确认，从卡组·墓地把1张相同卡名的卡加入手卡
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if hg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local g=hg:Select(tp,1,1,nil)
			if #g>0 then
				Duel.ConfirmCards(1-tp,g)
				local code=g:GetFirst():GetCode()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,cm.namefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,code)
				if #sg>0 then
					local fd=sg:GetFirst():IsLocation(LOCATION_DECK)
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
					if fd then Duel.ShuffleDeck(tp) end
				end
			end
		end
	end
end
-- 不受对方发动的效果影响
function cm.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

------------------------------------------------------------------
-- 七之弹（Zayin）的3个效果
------------------------------------------------------------------
function cm.remfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
		and not c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function cm.negfilter(c)
	return c:IsFaceup()
end
function cm.b7(e,tp)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.IsExistingMatchingCard(cm.negfilter,tp,0,LOCATION_ONFIELD,1,nil)
	local b3=Duel.GetLP(tp)>1 and Duel.IsExistingMatchingCard(cm.affil,tp,LOCATION_MZONE,0,1,nil)
	local op=cm.selectop(tp,B7,{b1,b2,b3})
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local dg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
		if #dg==0 or Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)==0 then return end
		if not Duel.IsExistingMatchingCard(cm.negfilter,tp,0,LOCATION_ONFIELD,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local ng=Duel.SelectMatchingCard(tp,cm.negfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #ng>0 then
			cm.Negate(e,ng:GetFirst())
		end
	elseif op==3 then
		-- ●支付一半基本分，这个回合自己场上的狂三攻击力·守备力变为8000
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		local g=Duel.GetMatchingGroup(cm.affil,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(8000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(8000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
-- 让1张卡的效果无效化
function cm.Negate(e,tc)
	local c=e:GetHandler()
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
