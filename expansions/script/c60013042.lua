-- 刻刻帝·八之弹（Het）
local cm,m,o=GetID()

local F_KKKD=60013040+10000000	-- 「刻刻帝」②的适用次数（场地 6048 与陷阱 6043~6046 共用同一个计数器，锚在 6040 号段）
local F_KDRAW=60013040+20000000	-- 「每3次抽1张」已经抽过的次数（系列共用）

function cm.initial_effect(c)
	-- 卡名记述：「时崎狂三·时崎狂三」
	aux.AddCodeList(c,60013039)
	-- 作为通常魔法发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	-- 这张卡在加入手卡的对方回合也能从手卡发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
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
function cm.spfilter(c,e,tp)
	return cm.affil(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.namefilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
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
-- ●3是否可行：手卡有卡，且卡组·墓地里存在同名卡
function cm.samecan(tp,ex)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if ex:IsLocation(LOCATION_HAND) then g:RemoveCard(ex) end
	for tc in aux.Next(g) do
		if Duel.IsExistingMatchingCard(cm.namefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tc:GetCode()) then
			return true
		end
	end
	return false
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
			or Duel.IsExistingMatchingCard(cm.affil,tp,LOCATION_MZONE,0,1,nil)
			or cm.samecan(tp,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.affil,tp,LOCATION_MZONE,0,1,nil)
	local b3=cm.samecan(tp,c)
	local op=cm.selectop(tp,b1,b2,b3)
	if op==1 then
		-- ●从卡组·墓地把1只「时崎狂三·时崎狂三」特殊召唤
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		-- ●这个回合，自己场上的「时崎狂三·时崎狂三」不受对方发动的效果影响
		local g=Duel.GetMatchingGroup(cm.affil,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(tc)
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
		if c:IsLocation(LOCATION_HAND) then hg:RemoveCard(c) end
		if hg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local g=hg:Select(tp,1,1,nil)
			if #g>0 then
				Duel.ConfirmCards(1-tp,g)
				local code=g:GetFirst():GetCode()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,cm.namefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,code)
				if #sg>0 then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
				end
			end
		end
	end
	cm.togy(c)
end
-- 不受对方发动的效果影响
function cm.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
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
