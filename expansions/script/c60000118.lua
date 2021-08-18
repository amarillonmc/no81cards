--休比·多拉 相位移动
function c60000118.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,60000118)
	e1:SetCost(c60000118.spcost)
	e1:SetTarget(c60000118.sptg)
	e1:SetOperation(c60000118.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60000118,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10000118)
	e2:SetCondition(c60000118.discon)
	e2:SetCost(c60000118.discost)
	e2:SetTarget(c60000118.distg)
	e2:SetOperation(c60000118.disop)
	c:RegisterEffect(e2)
end
function c60000118.ckfil(c)
	return c:IsFacedown() or not c:IsSetCard(0x56a9) and Duel.GetMZoneCount(tp,c)>0
end
function c60000118.rlfil(c)
	return c:IsReleasable() and c:IsSetCard(0x56a9) and Duel.GetMZoneCount(tp,c)>0
end
function c60000118.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
	local b1=g:CheckWithSumEqual(Card.GetLevel,8,1,99)
	local b2=not Duel.IsExistingMatchingCard(c60000118.ckfil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=0 and Duel.IsExistingMatchingCard(c60000118.rlfil,tp,LOCATION_DECK,0,1,nil) 
	if chk==0 then return b1 or b2 end 
	if b1 and b2 and Duel.SelectYesNo(tp,aux.Stringid(60000118,0)) then 
	e:SetLabel(0)
	elseif b2 then 
	e:SetLabel(0)
	else 
	e:SetLabel(1)
	end
end
function c60000118.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c60000118.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60000118.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c60000118.ctfil(c)
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsSetCard(0x56a9) and c:IsAbleToGraveAsCost()
end
function c60000118.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000118.ctfil,tp,LOCATION_DECK,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c60000118.ctfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	if tc:CheckActivateEffect(true,true,false)~=nil and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectEffectYesNo(tp,tc) then 
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true) 
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c60000118.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c60000118.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end







