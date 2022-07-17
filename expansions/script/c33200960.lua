--星辉末裔 维奥莱特
function c33200960.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(33200960)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x632a),2,true)
	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c33200960.imtg)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e3=e0:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c33200960.spcon)
	e2:SetOperation(c33200960.spop)
	c:RegisterEffect(e2)
	--destory
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33200960,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,33200960)
	e5:SetTarget(c33200960.sptg2)
	e5:SetOperation(c33200960.spop2)
	c:RegisterEffect(e5)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33200960.atkcon)
	e4:SetOperation(c33200960.atkop)
	c:RegisterEffect(e4)
end

--fusion
function c33200960.spfilter2(c,fc,tp,ct)
	return c:IsSetCard(0x632a) and c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL) and (Duel.GetLocationCountFromEx(tp,tp,c,fc)>0 or Duel.GetLocationCountFromEx(tp,tp,ct,fc)>0)
end
function c33200960.spfilter3(c,fc,tp)
	return c:IsSetCard(0x632a) and c:IsReleasable() and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL) and Duel.IsExistingMatchingCard(c33200960.spfilter2,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,c,fc,tp,c)
end
function c33200960.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not c:IsFaceup() and Duel.IsExistingMatchingCard(c33200960.spfilter3,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil,c,tp)
end
function c33200960.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c33200960.spfilter3,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c33200960.spfilter2,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,g1,c,tp,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	g1:RemoveCard(g2:GetFirst())
	Duel.Release(g1,REASON_COST)
	Duel.SendtoDeck(g2,nil,0,REASON_COST)
end

--e0
function c33200960.imtg(e,c)
	return (c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)) or (c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsType(TYPE_RITUAL))
end

--e3
function c33200960.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c33200960.dspfilter(c)
	return c:IsSetCard(0x632a)
end
function c33200960.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local dc=g:FilterCount(c33200960.dspfilter,nil)
	if dc>0 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,dc,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end

--e4
function c33200960.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep==1-tp and tc:IsControler(tp) and tc:IsLocation(LOCATION_ONFIELD) and tc:IsSetCard(0x632a) and tc~=e:GetHandler()
end
function c33200960.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
end