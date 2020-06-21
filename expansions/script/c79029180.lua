--汐斯塔·狙击干员-黑·战术的终结
function c79029180.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4779091,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c79029180.spcon)
	e2:SetTarget(c79029180.sptg)
	e2:SetOperation(c79029180.spop)
	c:RegisterEffect(e2)  
	--double
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c79029180.damcon)
	e3:SetOperation(c79029180.damop)
	c:RegisterEffect(e3)  
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4) 
	--to grave 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c79029180.tgtg)
	e5:SetOperation(c79029180.tgop)
	c:RegisterEffect(e5)  
	--cannot target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--change zone
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(10852583,0))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_BATTLED)
	e8:SetCountLimit(1)
	e8:SetCondition(c79029180.seqcon)
	e8:SetOperation(c79029180.seqop)
	c:RegisterEffect(e8)
end
c79029180.card_code_list={79029137}
c79029180.assault_name=79029030
function c79029180.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c79029180.filter(c,e,tp)
	return c:IsCode(79029030) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c79029180.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029180.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c79029180.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029180.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c79029180.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c79029180.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c79029180.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return cg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,cg:GetCount()*500)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,cg,cg:GetCount(),0,0)
end
function c79029180.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if cg:GetCount()>0 then
		Duel.BreakEffect()
		if Duel.SendtoGrave(cg,REASON_EFFECT)~=0 then 
		Duel.Damage(1-tp,cg:GetCount()*500,REASON_EFFECT)
	end
end
end
function c79029180.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c79029180.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end