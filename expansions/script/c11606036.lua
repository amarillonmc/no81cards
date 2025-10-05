--绝海滋养的海天使
local s,id,o=GetID()
function s.initial_effect(c)
	--这张卡也能把任意数量的怪兽解放来上级召唤。
	--「守墓的审神者」「神兽王 巴巴罗斯」
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(s.ttcon)
	e0:SetOperation(s.ttop)
	e0:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e0)
	local e0s=e0:Clone()
	e0s:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e0s)
    --这张卡的等级·攻击力·守备力上升为这张卡的上级召唤而解放的怪兽的各自数值的合计
	--「暴君海王星」「天魔神 因维希尔」「加速同调士」
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.valcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetOperation(s.facechk)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
    --双方回合才能发动。选这张卡等级每4星最多1只的场上的怪兽解放。这张卡的等级·攻击力上升解放的怪兽的各自数值的合计。
	--「扰动骚蛇 响云蛇」「武装龙·雷电 LV10」「巨石遗物复活」「DD 计数测量员」
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,id)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(s.rltg)
	e3:SetOperation(s.rlop)
	c:RegisterEffect(e3)
    --这张卡被解放的场合才能发动。选场上1张卡解放。
    --「电子化天使-弁天-」「巨石遗物复活」
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_RELEASE+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,id+o)
	e4:SetTarget(s.rl2tg)
	e4:SetOperation(s.rl2op)
	c:RegisterEffect(e4)
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	local minr=minc
    if minc==0 then minr=1 end
	return Duel.CheckTribute(c,minr)
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local minr=minc
    if minc==0 then minr=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,minr,149)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function s.valcheck(e,c)
	if e:GetLabel()~=1 then return end
	e:SetLabel(0)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local atk=0
	local def=0
	local lv=0
	while tc do
		--获取卡片信息的时机参考「天魔神 因维希尔」
		local catk=tc:GetAttack()
		local cdef=tc:GetDefense()
		local clv=0
		if tc:IsLevelAbove(1) then clv=tc:GetLevel() end
		atk=atk+(catk>=0 and catk or 0)
		def=def+(cdef>=0 and cdef or 0)
		lv=lv+clv
		tc=g:GetNext()
	end
		--atk continuous effect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
		--def continuous effect
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
		--lv continuous effect
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetValue(lv)
		c:RegisterEffect(e3)
end
function s.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end
function s.rlfilter(c)
	return c:IsReleasableByEffect()
end
function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=e:GetHandler():GetLevel()//4
    local g=Duel.GetMatchingGroup(s.rlfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if chk==0 then return #g>0 and ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetLevel()//4
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end --「抒情歌鸲-独立夜莺」
    local g=Duel.GetMatchingGroup(s.rlfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    ct=math.min(#g,ct)
    if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local tg=g:Select(tp,1,ct,nil)
    --「DD 计数测量员」
	if Duel.Release(tg,REASON_EFFECT)>0 then
        local rg=Duel.GetOperatedGroup()
		local atk=rg:GetSum(Card.GetPreviousAttackOnField)
        local lv=rg:Filter(Card.IsLevelAbove,nil,1):GetSum(Card.GetPreviousLevelOnField)
		if c:IsFaceup() and c:IsRelateToEffect(e) and (atk>0 or lv>0) then --「圣炎王 大鹏不死鸟」
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_LEVEL)
			e2:SetValue(lv)
			c:RegisterEffect(e2)
		end
    end
end
function s.rl2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	return Duel.IsExistingMatchingCard(s.rlfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,LOCATION_ONFIELD)
end
function s.rl2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.rlfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Release(g,REASON_EFFECT)
	end
end