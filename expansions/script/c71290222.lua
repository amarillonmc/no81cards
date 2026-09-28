--卡尼斯兰那-无名的英雄-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①自己场上有其他怪兽存在的场合，这张卡不能攻击宣言
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetCondition(cm.atkcon)
	c:RegisterEffect(e1)
	--①自己场上没有其他怪兽存在的场合，这张卡不受对方发动的效果影响
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.immcon)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--②装备1张以上：对方怪兽不能攻击宣言
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(cm.eqcon1)
	c:RegisterEffect(e3)
	--②装备3张以上：自己魔法与陷阱区域的卡不会被效果破坏
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetValue(1)
	e4:SetCondition(cm.eqcon2)
	c:RegisterEffect(e4)
	--泰坦权能「刻法勒-全世之座-」：选自己场上任意数量的其他怪兽破坏，从墓地选相同数量的记述怪兽给这张卡装备（需自身code flag）
	local t1=Effect.CreateEffect(c)
	t1:SetDescription(aux.Stringid(m,1))
	t1:SetCategory(CATEGORY_DESTROY+CATEGORY_EQUIP)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(33550336)
	t1:SetCondition(cm.titancon)
	t1:SetTarget(cm.t1tg)
	t1:SetOperation(cm.t1op)
	c:RegisterEffect(t1)
	--献予「负世」之诗：升级版——墓地选相同数量的卡（怪兽或装备魔法）装备
	local t2=t1:Clone()
	t2:SetDescription(aux.Stringid(m,2))
	t2:SetCondition(cm.upcon)
	t2:SetTarget(cm.t2tg)
	t2:SetOperation(cm.t2op)
	c:RegisterEffect(t2)
end
function cm.otherfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.atkcon(e)
	return Duel.IsExistingMatchingCard(cm.otherfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.immcon(e)
	return not Duel.IsExistingMatchingCard(cm.otherfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.eqcon1(e)
	return e:GetHandler():GetEquipCount()>=1
end
function cm.eqcon2(e)
	return e:GetHandler():GetEquipCount()>=3
end
function cm.titancon(e)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)==0
end
function cm.upcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)~=0
end
--基础版装备素材：墓地的记述怪兽
function cm.eqmfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,71290201)
end
--升级版装备素材：墓地的卡（怪兽或装备魔法，非装备卡无法装备）
function cm.eqmfilter2(c)
	return c:IsType(TYPE_MONSTER) or c:IsType(TYPE_EQUIP)
end
function cm.t1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,e:GetHandler()):GetCount()>0
			and Duel.IsExistingMatchingCard(cm.eqmfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function cm.t1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,c)
	local g2=Duel.GetMatchingGroup(cm.eqmfilter,tp,LOCATION_GRAVE,0,nil)
	local maxn=math.min(g1:GetCount(),g2:GetCount())
	if maxn<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g1:Select(tp,1,maxn,nil)
	local n=sg:GetCount()
	if n>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
	--破坏处理后再从墓地选（含刚被破坏送墓的记述怪兽）
	local g3=Duel.GetMatchingGroup(cm.eqmfilter,tp,LOCATION_GRAVE,0,nil)
	if n>0 and g3:GetCount()>=n and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eq=g3:Select(tp,n,n,nil)
		local tc=eq:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,false,true)
			tc=eq:GetNext()
		end
		Duel.EquipComplete()
	end
end
function cm.t2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,e:GetHandler()):GetCount()>0
			and Duel.IsExistingMatchingCard(cm.eqmfilter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function cm.t2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,c)
	local g2=Duel.GetMatchingGroup(cm.eqmfilter2,tp,LOCATION_GRAVE,0,nil)
	local maxn=math.min(g1:GetCount(),g2:GetCount())
	if maxn<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g1:Select(tp,1,maxn,nil)
	local n=sg:GetCount()
	if n>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
	local g3=Duel.GetMatchingGroup(cm.eqmfilter2,tp,LOCATION_GRAVE,0,nil)
	if n>0 and g3:GetCount()>=n and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eq=g3:Select(tp,n,n,nil)
		local tc=eq:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,false,true)
			tc=eq:GetNext()
		end
		Duel.EquipComplete()
	end
end
