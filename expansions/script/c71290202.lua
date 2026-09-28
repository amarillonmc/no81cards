--昔涟-无瑕的真我-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	c:EnableReviveLimit()
	--融合素材：包含有「翁法罗斯英雄纪」卡名记述的等级不同的怪兽3只
	aux.AddFusionProcFunRep(c,cm.matfilter,3,true)
	--泰坦权能「德缪歌」：攻击力·守备力变为场上翁法罗斯记述怪兽数量×4000（需自身code flag）
	local t1=Effect.CreateEffect(c)
	t1:SetType(EFFECT_TYPE_SINGLE)
	t1:SetCode(EFFECT_SET_ATTACK_FINAL)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCondition(cm.titancon)
	t1:SetValue(cm.atkval)
	c:RegisterEffect(t1)
	local t2=t1:Clone()
	t2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(t2)
	--献予「真我」之诗：升级版追加不会被效果破坏、不会成为对方效果的对象
	local t3=Effect.CreateEffect(c)
	t3:SetType(EFFECT_TYPE_SINGLE)
	t3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	t3:SetRange(LOCATION_MZONE)
	t3:SetCondition(cm.upcon)
	t3:SetValue(1)
	c:RegisterEffect(t3)
	local t4=Effect.CreateEffect(c)
	t4:SetType(EFFECT_TYPE_SINGLE)
	t4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	t4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	t4:SetRange(LOCATION_MZONE)
	t4:SetCondition(cm.upcon)
	t4:SetValue(cm.tgval)
	c:RegisterEffect(t4)
	--①融合召唤成功：这次决斗中修改泰坦权能（放置玩家升级flag）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--②丢弃1张手卡：场上翁法罗斯怪兽得到对应的泰坦权能
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--③从场上离开：回收记述怪兽
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.matfilter(c,fc,sub,mg,sg)
	if not aux.IsCodeListed(c,71290201) then return false end
	if not sg then return true end
	return not sg:IsExists(Card.IsLevel,1,c,c:GetLevel())
end
function cm.titancon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.omfilter,c:GetControler(),LOCATION_MZONE,0,nil)*4000
end
function cm.upcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)~=0
end
function cm.tgval(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	--泰坦权能升级flag：怪兽侧检测Duel.GetFlagEffect(自身控制者,71290201)~=0时用「献予xx之诗」版本
	Duel.RegisterFlagEffect(tp,71290201,0,0,1)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.omfilter(c)
	return aux.IsCodeListed(c,71290201) and c:IsFaceup()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.omfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.omfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		--泰坦之铭：以怪兽自身code为id放置flag，怪兽侧泰坦权能以GetFlagEffect(自身code)~=0为门槛
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(tc:GetOriginalCode(),1))
		tc=g:GetNext()
	end
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,71290201) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
