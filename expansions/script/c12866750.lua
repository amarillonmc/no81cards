--那由多
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(s.eqcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(s.eqcheck)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(s.spcost2)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.sptg2)
	e4:SetLabelObject(e5)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)
end
function s.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter(chkc,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and 
	Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
	Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,nil,tp) and 
	e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e)
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Equip(tp,tc,c,false)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e2:SetCode(EFFECT_EQUIP_LIMIT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(s.eqlimit)
			tc:RegisterEffect(e2)
			end
			if c:IsPreviousLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1,true)
		end
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.eqcon(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg:GetCount()>0
end
function s.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	local g=e:GetHandler():GetEquipGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
end
function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
end
function s.spfilter2(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-2000)
	if Duel.GetLP(tp)<lp and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
	Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local g=e:GetLabelObject():GetLabelObject()
		if g and g:IsExists(s.spfilter2,1,nil,e,tp) then
		local tc=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end