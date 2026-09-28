--阿格莱雅-黄金的织者-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①自己把记述怪兽特招成功时必发：抽1张，那之后选1张手卡丢弃
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--②自己场上有2星以下的怪兽存在的场合才能发动：墓地的这张卡特殊召唤（1回合1次）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.lvcon)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--泰坦权能「墨涅塔-黄金之茧-」：1回合1次，从自己墓地选1只2星以下记述怪兽加入手卡（需自身code flag）
	local t1=Effect.CreateEffect(c)
	t1:SetDescription(aux.Stringid(m,1))
	t1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.titancon)
	t1:SetTarget(cm.t1tg)
	t1:SetOperation(cm.t1op)
	c:RegisterEffect(t1)
	--献予「浪漫」之诗：升级版——从自己卡组·墓地选1只2星以下记述怪兽加入手卡
	local t2=t1:Clone()
	t2:SetDescription(aux.Stringid(m,2))
	t2:SetCondition(cm.upcon)
	t2:SetTarget(cm.t2tg)
	t2:SetOperation(cm.t2op)
	c:RegisterEffect(t2)
end
function cm.spchk(c,tp)
	return aux.IsCodeListed(c,71290201) and c:GetSummonPlayer()==tp
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spchk,1,nil,tp)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
	end
end
function cm.lvfilter(c)
	return c:IsLevelBelow(2) and not c:IsType(TYPE_XYZ+TYPE_LINK)
end
function cm.lvcon(e)
	return Duel.IsExistingMatchingCard(cm.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
end
function cm.titancon(e)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)==0
end
function cm.upcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)~=0
end
function cm.th1filter(c)
	return c:IsLevelBelow(2) and not c:IsType(TYPE_XYZ+TYPE_LINK)
		and aux.IsCodeListed(c,71290201) and c:IsAbleToHand()
end
function cm.t1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.th1filter),tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.t1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.th1filter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.t2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.th1filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.t2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.th1filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
