--一千零一夜·山鲁佐德
function c9951324.initial_effect(c)
	  c:SetSPSummonOnce(9951324)
	  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xba5),7,2,c9951324.ovfilter,aux.Stringid(9951324,1))
	c:EnableReviveLimit()
 --equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951324,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9951324.eqtg)
	e1:SetOperation(c9951324.eqop)
	c:RegisterEffect(e1)
 --control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_SET_CONTROL)
	e5:SetValue(c9951324.ctval)
	c:RegisterEffect(e5) 
 --sp
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,9951324)
	e3:SetCost(c9951324.spcost)
	e3:SetTarget(c9951324.sptg)
	e3:SetOperation(c9951324.spop)
	c:RegisterEffect(e3)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951324.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951324.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951324,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951324,4))
end
function c9951324.ovfilter(c)
	return c:IsFaceup() and c:IsCode(9951335) 
end
function c9951324.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():GetFlagEffect(9951324)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(9951324,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c9951324.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	--eqlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c9951324.eqlimit)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetLabelObject(tc)
	c:RegisterEffect(e4)
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951324,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951324,5))
end
function c9951324.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c9951324.ctval(e,c)
	return e:GetHandlerPlayer()
end
function c9951324.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetFlagEffect(tp,9951324)==0 end
	Duel.RegisterFlagEffect(tp,9951324,RESET_CHAIN,0,1)
end
function c9951324.spfilter(c,g,tp)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsCanBeXyzMaterial(g) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c9951324.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951324.spfilter,tp,LOCATION_ONFIELD,0,1,nil,e:GetHandler(),tp) 
	 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end
	 Duel.ConfirmCards(tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c9951324.xyzfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) 
end
function c9951324.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) then return end
   local g=Duel.SelectMatchingCard(tp,c9951324.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e:GetHandler(),tp)
   local t=g:GetFirst()
   if t  and not t:IsImmuneToEffect(e) then
		local mg=t:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(e:GetHandler(),mg)
		end
		e:GetHandler():SetMaterial(Group.FromCards(t))
		Duel.Overlay(e:GetHandler(),Group.FromCards(t))
		Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		e:GetHandler():CompleteProcedure()
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9951324,3))
			local tg=Duel.SelectMatchingCard(tp,c9951324.xyzfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.Overlay(c,tg)
		end
end
end