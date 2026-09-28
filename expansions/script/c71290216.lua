--海列屈拉-奏浪的剑骑-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①手卡发动（入连锁）：自身特殊召唤，那之后可以从卡组·墓地把1只4星以下记述怪兽加入手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--②向守备表示怪兽攻击的场合给与贯通战斗伤害
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--泰坦权能「法吉娜-满溢之杯-」：自己把4星以下记述怪兽特招成功时，翻卡组顶3张选1张加入手卡，那之后洗切卡组（需自身code flag）
	local t1=Effect.CreateEffect(c)
	t1:SetDescription(aux.Stringid(m,1))
	t1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	t1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	t1:SetCode(EVENT_SPSUMMON_SUCCESS)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCondition(cm.tcon)
	t1:SetTarget(cm.t1tg)
	t1:SetOperation(cm.t1op)
	c:RegisterEffect(t1)
	--献予「海洋」之诗：升级版——不限星级
	local t2=t1:Clone()
	t2:SetDescription(aux.Stringid(m,2))
	t2:SetCondition(cm.ucon)
	c:RegisterEffect(t2)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confil,tp,LOCATION_MZONE,0,1,nil)
end
function cm.confil(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(7) and c:IsFaceup()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and aux.IsCodeListed(c,71290201) and c:IsAbleToHand()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
	--那之后，可以从卡组·墓地选1只4星以下记述怪兽加入手卡
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--泰坦权能：eg中存在自己特招成功的记述怪兽（maxlv为nil则不限星级）
function cm.spchk(c,tp,maxlv)
	return aux.IsCodeListed(c,71290201) and (not maxlv or c:IsLevelBelow(maxlv))
		and c:GetSummonPlayer()==tp
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
		and Duel.GetFlagEffect(tp,71290201)==0
		and eg:IsExists(cm.spchk,1,nil,tp,4)
end
function cm.ucon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
		and Duel.GetFlagEffect(tp,71290201)~=0
		and eg:IsExists(cm.spchk,1,nil,tp,nil)
end
function cm.t1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.t1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	--那之后，洗切卡组
	Duel.ShuffleDeck(tp)
end
