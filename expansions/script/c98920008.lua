--进化龙 迷惑龙
function c98920008.initial_effect(c)
		--special summon
	  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98920008.dspcon)
	e1:SetOperation(c98920008.dspop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
 --des
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c98920008.destg)
	e2:SetOperation(c98920008.desop)
	c:RegisterEffect(e2) 
   --xyz level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c98920008.slevel)
	c:RegisterEffect(e2)
end
function c98920008.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 4*65536+lv
end
function c98920008.cfilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsAbleToGraveAsCost()
end
function c98920008.dspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroupEx(tp,c98920008.cfilter,1,nil,ft,tp)
end
function c98920008.dspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroupEx(tp,c98920008.cfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c98920008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_SZONE+LOCATION_FZONE,LOCATION_FZONE+LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_SZONE+LOCATION_FZONE,LOCATION_SZONE+LOCATION_FZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98920008.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	if (re:GetHandler():IsSetCard(0x304e) and re:GetHandler():IsType(TYPE_MONSTER)) or re:GetHandler():IsCode(5338223) then
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98920008,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end