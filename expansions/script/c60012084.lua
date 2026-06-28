-- 传奇教师·路西乌斯
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x624)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(s.optg)
	e2:SetOperation(s.opop)
	c:RegisterEffect(e2)

	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(s.atkcon)
	e4:SetValue(800)
	c:RegisterEffect(e4)

	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
end
s.listed_series={0x5624}
function s.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5624)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.opop(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	ops[off]=aux.Stringid(id,1)  -- 回复1200，给对方600伤害
	opval[off]=0
	off=off+1
	ops[off]=aux.Stringid(id,2)  -- 抽1张
	opval[off]=1
	off=off+1
	ops[off]=aux.Stringid(id,3)  -- 破坏对方场上1张卡
	opval[off]=2
	off=off+1
	if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil) then
		ops[off]=aux.Stringid(id,4)  -- 进行手卡1只怪兽的召唤
		opval[off]=3
		off=off+1
	end
	ops[off]=aux.Stringid(id,5)  -- 取消
	opval[off]=4
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	if sel==0 then
		Duel.Recover(tp,1200,REASON_EFFECT)
		Duel.Damage(1-tp,600,REASON_EFFECT)
	elseif sel==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND,0,1,1,nil,true,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
function s.atkcon(e)
	return e:GetHandler():GetCounter(0x624)>0
end