--阿那克萨戈拉斯-殁世的学士-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①手卡：丢弃2张其他手卡才能发动，特殊召唤，那之后可让对方场上表侧表示的卡全部效果无效（1回合1次）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--①墓地：同上
	local e1b=e1:Clone()
	e1b:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e1b)
	--②从场上离开：从卡组检索7星以上记述怪兽（除自身）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--泰坦权能「瑟希斯-裂分之枝-」：1回合1次，把自己场上至多2只怪兽送去墓地才能发动。从手卡·墓地选那个相同数量的记述怪兽特殊召唤（需自身code flag）
	local t1=Effect.CreateEffect(c)
	t1:SetDescription(aux.Stringid(m,3))
	t1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.titancon2)
	t1:SetCost(cm.scost1)
	t1:SetTarget(cm.stg1)
	t1:SetOperation(cm.sop1)
	c:RegisterEffect(t1)
	--献予「理性」之诗：升级版——从手卡·卡组·墓地选那个相同数量的记述怪兽特殊召唤
	local t2=t1:Clone()
	t2:SetDescription(aux.Stringid(m,4))
	t2:SetCondition(cm.upcon2)
	t2:SetCost(cm.scost2)
	t2:SetTarget(cm.stg2)
	t2:SetOperation(cm.sop2)
	c:RegisterEffect(t2)
end
function cm.costfilter(c)
	return c:IsAbleToGraveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_HAND,0,e:GetHandler()):GetCount()>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.disfilter(c)
	return c:IsFaceup()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
	--那之后，可以让对方场上表侧表示的卡全部效果无效（离场失效）
	if Duel.IsExistingMatchingCard(cm.disfilter,tp,0,LOCATION_MZONE+LOCATION_SZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local g=Duel.GetMatchingGroup(cm.disfilter,tp,0,LOCATION_MZONE+LOCATION_SZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function cm.thfilter(c)
	return c:IsLevelAbove(7) and aux.IsCodeListed(c,71290201)
		and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--泰坦权能：记述怪兽特招filter（条件=自身flag+玩家71290201 flag互斥）
function cm.tspfilter(c,e,tp)
	return aux.IsCodeListed(c,71290201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.titancon2(e)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)==0
end
function cm.upcon2(e)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)~=0
end
--基础版：从手卡·墓地特招（cost送墓数量存label，tg/op读label）
function cm.scost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local range=LOCATION_HAND+LOCATION_GRAVE
	if chk==0 then
		return Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tspfilter,e,tp),tp,range,0,1,nil,e,tp)
	end
	if chk==1 then
		local maxn=math.min(2,
			Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil),
			Duel.GetMatchingGroupCount(aux.NecroValleyFilter(cm.tspfilter,e,tp),tp,range,0,nil,e,tp))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,maxn,nil)
		Duel.SendtoGrave(g,REASON_COST)
		e:SetLabel(g:GetCount())
	end
end
function cm.stg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.sop1(e,tp,eg,ep,ev,re,r,rp)
	local n=e:GetLabel()
	if n<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tspfilter,e,tp),tp,LOCATION_HAND+LOCATION_GRAVE,0,n,n,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
end
--升级版：从手卡·卡组·墓地特招（独立函数对硬编码区域，避免label冲突）
function cm.scost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local range=LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE
	if chk==0 then
		return Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tspfilter,e,tp),tp,range,0,1,nil,e,tp)
	end
	if chk==1 then
		local maxn=math.min(2,
			Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil),
			Duel.GetMatchingGroupCount(aux.NecroValleyFilter(cm.tspfilter,e,tp),tp,range,0,nil,e,tp))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,maxn,nil)
		Duel.SendtoGrave(g,REASON_COST)
		e:SetLabel(g:GetCount())
	end
end
function cm.stg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function cm.sop2(e,tp,eg,ep,ev,re,r,rp)
	local n=e:GetLabel()
	if n<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tspfilter,e,tp),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,n,n,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
end
