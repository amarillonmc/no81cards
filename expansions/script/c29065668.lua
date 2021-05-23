--灵知隐者 狱魔师厄手
function c29065668.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--selfdes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_SELF_DESTROY)
	e0:SetCondition(c29065668.descon)
	c:RegisterEffect(e0)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,29065668)
	e1:SetTarget(c29065668.sptg)
	e1:SetOperation(c29065668.spop)
	c:RegisterEffect(e1)
	--spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c29065668.cpcost)
	e2:SetTarget(c29065668.cptg)
	e2:SetOperation(c29065668.cpop)
	c:RegisterEffect(e2)
	--pendulum
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCountLimit(1,29000031)
	e8:SetCondition(c29065668.pencon)
	e8:SetTarget(c29065668.pentg)
	e8:SetOperation(c29065668.penop)
	c:RegisterEffect(e8)
end
function c29065668.descon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,c,0x87aa)
end
function c29065668.spfil(c,e,tp)
	return c:IsSetCard(0x87aa) and Duel.IsExistingMatchingCard(c29065668.syfil,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler(),c)   
end
function c29065668.syfil(c,xc,tc)
	local mg=Group.FromCards(xc,tc)
	return c:IsSynchroSummonable(nil,mg) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c29065668.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c29065668.spfil,tp,LOCATION_ONFIELD,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SelectTarget(tp,c29065668.spfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29065668.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c29065668.syfil,tp,LOCATION_EXTRA,0,nil,c,tc)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xc=g:Select(tp,1,1,nil):GetFirst()
	local mg=Group.FromCards(e:GetHandler(),tc)
	Duel.SynchroSummon(tp,xc,nil,mg)
	end
end
function c29065668.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c29065668.cpfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x87aa) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c29065668.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c29065668.cpfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c29065668.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c29065668.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c29065668.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 
end
function c29065668.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c29065668.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end