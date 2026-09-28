--刻律德菈-执棋的君主-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①手卡特招手续：自己场上有装备卡存在
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.hspcon)
	c:RegisterEffect(e0)
	--②召唤·特殊召唤成功：选对方场上1张卡破坏
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--③1回合1次：从墓地选1只战士族或是有「翁法罗斯英雄纪」卡名记述的怪兽加入手卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--泰坦权能「塔兰顿-公正之秤-」：自己场上其他怪兽不会被战斗破坏（需自身code flag，基础·升级两态共有）
	local t1=Effect.CreateEffect(c)
	t1:SetType(EFFECT_TYPE_FIELD)
	t1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	t1:SetRange(LOCATION_MZONE)
	t1:SetTargetRange(LOCATION_MZONE,0)
	t1:SetCondition(cm.titancon)
	t1:SetTarget(cm.othertg)
	t1:SetValue(1)
	c:RegisterEffect(t1)
	--献予「律法」之诗：升级版追加——有卡装备的怪兽攻守上升 装备数×记述怪兽数×1000
	local t2=Effect.CreateEffect(c)
	t2:SetType(EFFECT_TYPE_FIELD)
	t2:SetCode(EFFECT_UPDATE_ATTACK)
	t2:SetRange(LOCATION_MZONE)
	t2:SetTargetRange(LOCATION_MZONE,0)
	t2:SetCondition(cm.upcon)
	t2:SetTarget(cm.othertg)
	t2:SetValue(cm.eqval)
	c:RegisterEffect(t2)
	local t3=t2:Clone()
	t3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(t3)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.eqfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function cm.desfilter(c)
	return c:IsOnField() and c:IsDestructable()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and cm.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsRace(RACE_WARRIOR) or aux.IsCodeListed(c,71290201))
		and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--泰坦权能：其他怪兽=TargetRange(LOCATION_MZONE,0)+othertg排除自身
function cm.othertg(e,c)
	return c~=e:GetHandler()
end
function cm.titancon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.upcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)~=0
end
function cm.eqval(e,c)
	local ec=c:GetEquipCount()
	if ec==0 then return 0 end
	local rec=Duel.GetMatchingGroupCount(cm.recfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return ec*rec*1000
end
function cm.recfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,71290201)
end
