--星辉末裔 布拉德
function c33200959.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(33200959)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x632a),2,true)
	--cannot be target
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c33200959.imtg)
	e0:SetValue(aux.tgoval)
	c:RegisterEffect(e0)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c33200959.spcon)
	e2:SetOperation(c33200959.spop)
	c:RegisterEffect(e2)
	--spsummon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200959,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33200959)
	e3:SetTarget(c33200959.sptg2)
	e3:SetOperation(c33200959.spop2)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33200959.atkcon)
	e4:SetOperation(c33200959.atkop)
	c:RegisterEffect(e4)
end

--fusion
function c33200959.spfilter2(c,fc,tp,ct)
	return c:IsSetCard(0x632a) and c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL) and (Duel.GetLocationCountFromEx(tp,tp,c,fc)>0 or Duel.GetLocationCountFromEx(tp,tp,ct,fc)>0)
end
function c33200959.spfilter3(c,fc,tp)
	return c:IsSetCard(0x632a) and c:IsReleasable() and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL) and Duel.IsExistingMatchingCard(c33200959.spfilter2,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,c,fc,tp,c)
end
function c33200959.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not c:IsFaceup() and Duel.IsExistingMatchingCard(c33200959.spfilter3,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil,c,tp)
end
function c33200959.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c33200959.spfilter3,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c33200959.spfilter2,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,g1,c,tp,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	g1:RemoveCard(g2:GetFirst())
	Duel.Release(g1,REASON_COST)
	Duel.SendtoDeck(g2,nil,0,REASON_COST)
end

--e0
function c33200959.imtg(e,c)
	return (c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)) or (c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsType(TYPE_RITUAL))
end

--e3
function c33200959.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200959.dspfilter(c,e,tp,atk)
	return c:IsType(TYPE_RITUAL) and c:GetBaseAttack()<=atk and c:IsSetCard(0x632a) and c:IsAbleToHand()
end
function c33200959.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount()
	local atk=c:GetAttack()
	if ct>0 and g:FilterCount(c33200959.dspfilter,nil,e,tp,atk)>0
		and Duel.SelectYesNo(tp,aux.Stringid(33200959,2)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c33200959.dspfilter,1,1,nil,e,tp,atk)
		local sc=sg:GetFirst()
		Duel.SendtoHand(sc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
		Duel.ShuffleHand(tp)
		local satk=0-sc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(satk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	Duel.ShuffleDeck(tp)
end

--e4
function c33200959.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep==1-tp and tc:IsControler(tp) and tc:IsLocation(LOCATION_ONFIELD) and tc:IsSetCard(0x632a) and tc~=e:GetHandler()
end
function c33200959.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
end