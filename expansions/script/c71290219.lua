--雅辛忒丝-摇光的医师-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①手卡发动（入连锁）：自身特殊召唤，自己场上的其他怪兽攻击力·守备力上升800
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--②召唤·特殊召唤成功：每有1只其他记述怪兽自己抽1张（1回合1次）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	--泰坦权能「艾格勒-晨昏之眼-」：自己把记述怪兽特招成功时1回合1次，回复1000，那之后可从墓地选1只记述怪兽入手（需自身code flag）
	local t1=Effect.CreateEffect(c)
	t1:SetDescription(aux.Stringid(m,1))
	t1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	t1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	t1:SetCode(EVENT_SPSUMMON_SUCCESS)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.tcon)
	t1:SetTarget(cm.t1tg)
	t1:SetOperation(cm.t1op)
	c:RegisterEffect(t1)
	--献予「天空」之诗：升级版——回复2000，墓地选1张卡（不限记述）入手
	local t2=t1:Clone()
	t2:SetDescription(aux.Stringid(m,2))
	t2:SetCondition(cm.ucon)
	t2:SetTarget(cm.t2tg)
	t2:SetOperation(cm.t2op)
	c:RegisterEffect(t2)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=2
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
	--自己场上的其他怪兽攻击力·守备力上升800（永久，离场失效）
	local g=Duel.GetMatchingGroup(cm.bufffilter,tp,LOCATION_MZONE,0,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function cm.bufffilter(c)
	return c:IsFaceup()
end
function cm.odfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,71290201)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(cm.odfilter,tp,LOCATION_MZONE,0,e:GetHandler())>0 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.odfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if ct>0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
--泰坦权能：eg中存在自己特招成功的记述怪兽
function cm.spchk(c,tp)
	return aux.IsCodeListed(c,71290201) and c:GetSummonPlayer()==tp
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
		and Duel.GetFlagEffect(tp,71290201)==0
		and eg:IsExists(cm.spchk,1,nil,tp)
end
function cm.ucon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
		and Duel.GetFlagEffect(tp,71290201)~=0
		and eg:IsExists(cm.spchk,1,nil,tp)
end
function cm.th1filter(c)
	return aux.IsCodeListed(c,71290201) and c:IsAbleToHand()
end
function cm.t1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.th1filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.t1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.th1filter),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.th1filter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.t2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.t2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,2000,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
