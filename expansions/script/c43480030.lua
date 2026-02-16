--被遗忘的研究者 夏露
function c4348030.initial_effect(c)
	--spe
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,4348030) 
	e1:SetTarget(c4348030.spetg)
	e1:SetOperation(c4348030.speop)
	c:RegisterEffect(e1) 
	--pl 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,4348031)
	e2:SetTarget(c4348030.pltg)
	e2:SetOperation(c4348030.plop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c4348030.desreptg)
	e2:SetOperation(c4348030.desrepop)
	c:RegisterEffect(e2)
end

function c4348030.eqfil(c,tp) 
	return c:IsFaceup() and c:IsSetCard(0x3f13) and c:GetOriginalType()&TYPE_PENDULUM~=0  
end 

function c4348030.spetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler() 
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c4348030.eqfil(chkc,tp) end 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c4348030.eqfil,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	local g=Duel.SelectTarget(tp,c4348030.eqfil,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c4348030.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then 
		if tc:IsRelateToEffect(e) then 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Equip(tp,tc,c)  
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(function(e,c)
			return e:GetOwner()==c end)
			tc:RegisterEffect(e1)
		end
	end
end
function c4348030.plfilter(c)
	return c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c4348030.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4348030.plfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c4348030.plop(e,tp,eg,ep,ev,re,r,rp) 
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c4348030.plfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
	end
end
function c4348030.repfilter(c)
	return c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c4348030.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c4348030.repfilter,1,nil)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,c4348030.repfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function c4348030.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end

