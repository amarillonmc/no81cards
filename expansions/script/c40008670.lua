--方界胤 平衡之布拉伏曼
function c40008670.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,c40008670.matfilter,1,1)  
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(15610297)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008670,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,40008670)
	e2:SetCondition(c40008670.hspcon)
	e2:SetOperation(c40008670.hspop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--reflect battle dam
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e4:SetCondition(c40008670.atkcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40008670,1))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(c40008670.cttg)
	e5:SetOperation(c40008670.ctop)
	c:RegisterEffect(e5)
end
function c40008670.matfilter(c)
	return c:IsLinkSetCard(0xe3) and not c:IsLinkCode(40008670)
end
function c40008670.hspfilter(c,tp,sc)
	return c:GetCounter(0x1038)>0 and c:IsType(TYPE_MONSTER) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0
end
function c40008670.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c40008670.hspfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c40008670.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c40008670.hspfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c40008670.atkcon(e)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:GetCounter(0x1038)>0
end
function c40008670.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x1038,1)
end
function c40008670.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008670.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1038)
end
function c40008670.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c40008670.ctfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1038,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetCondition(c40008670.condition)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c40008670.condition(e)
	return e:GetHandler():GetCounter(0x1038)>0
end