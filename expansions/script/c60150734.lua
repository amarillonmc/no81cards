--婚姻稼业 纯白型罗艾娜
function c60150734.initial_effect(c)
	c:SetUniqueOnField(1,0,60150734)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,60150724,60150798,true,true)
	--cannot fusion material
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60150734.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c60150734.spcon)
	e2:SetOperation(c60150734.spop)
	c:RegisterEffect(e2)
	--double
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c60150734.damcon)
	e4:SetOperation(c60150734.damop)
	c:RegisterEffect(e4)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c60150734.thtg)
	e3:SetOperation(c60150734.thop)
	c:RegisterEffect(e3)
end
function c60150734.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150734.spfilter1(c,tp,fc)
	return c:IsCode(60150724) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c60150734.spfilter2,tp,LOCATION_ONFIELD,0,1,c,fc)
end
function c60150734.spfilter2(c,fc)
	return c:IsCode(60150798) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
end
function c60150734.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local c1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local c2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if (c1 and c1:IsCode(60150798)) or (c2 and c2:IsCode(60150798)) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c60150734.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,fc)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
			and Duel.IsExistingMatchingCard(c60150734.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,fc)
	end
end
function c60150734.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150734,0))
		local g1=Duel.SelectMatchingCard(tp,c60150734.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150734,1))
		local g2=Duel.SelectMatchingCard(tp,c60150734.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
		g1:Merge(g2)
		c:SetMaterial(g1)
		Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150734,0))
		local g1=Duel.SelectMatchingCard(tp,c60150734.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150734,1))
		local g2=Duel.SelectMatchingCard(tp,c60150734.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
		g1:Merge(g2)
		c:SetMaterial(g1)
		Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	end
end
function c60150734.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil 
		and e:GetHandler():GetBattleTarget():IsAttribute(ATTRIBUTE_LIGHT)
end
function c60150734.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c60150734.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c60150734.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(60150734,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60150734,2))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150734,4))
		--double
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(60150734,3))
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e4:SetCondition(c60150734.damcon2)
		e4:SetOperation(c60150734.damop2)
		c:RegisterEffect(e4)
	end
end
function c60150734.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil 
		and e:GetHandler():GetBattleTarget():GetFlagEffect(60150734)~=0
end
function c60150734.damop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetBattleTarget():IsAttribute(ATTRIBUTE_LIGHT) then
		Duel.ChangeBattleDamage(ep,ev*4)
	else
		Duel.ChangeBattleDamage(ep,ev*2)
	end
end
